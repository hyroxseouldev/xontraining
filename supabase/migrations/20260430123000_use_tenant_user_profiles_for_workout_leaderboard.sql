create or replace function public.get_workout_leaderboard(
  p_tenant_id uuid,
  p_exercise_key text,
  p_preset_key text,
  p_limit integer default 100
)
returns table (
  rank_position bigint,
  user_id uuid,
  full_name text,
  avatar_url text,
  record_type text,
  distance integer,
  record_seconds integer,
  record_weight_kg numeric,
  record_reps integer,
  recorded_at date
)
language sql
security definer
set search_path = public
as $$
  with access_granted as (
    select
      auth.uid() is not null
      and (
        public.is_tenant_member(p_tenant_id)
        or public.is_tenant_content_manager(p_tenant_id, auth.uid())
      ) as ok
  ),
  source as (
    select
      r.user_id,
      r.record_type,
      r.distance,
      r.record_seconds,
      r.record_weight_kg,
      r.record_reps,
      r.recorded_at,
      r.created_at
    from public.user_workout_records_v2 r
    join access_granted a on a.ok = true
    where r.tenant_id = p_tenant_id
      and r.exercise_key = p_exercise_key
      and r.preset_key = p_preset_key
  ),
  best_per_user as (
    select
      s.*,
      row_number() over (
        partition by s.user_id
        order by
          case
            when s.record_type = 'time' then s.record_seconds
            else null
          end asc nulls last,
          case
            when s.record_type = 'weight' then s.record_weight_kg
            else null
          end desc nulls last,
          case
            when s.record_type = 'weight' then s.record_reps
            else null
          end desc nulls last,
          s.recorded_at desc,
          s.created_at desc
      ) as rn
    from source s
  ),
  ranked as (
    select
      rank() over (
        order by
          case
            when b.record_type = 'time' then b.record_seconds
            else null
          end asc nulls last,
          case
            when b.record_type = 'weight' then b.record_weight_kg
            else null
          end desc nulls last,
          case
            when b.record_type = 'weight' then b.record_reps
            else null
          end desc nulls last
      ) as rank_position,
      b.user_id,
      b.record_type,
      b.distance,
      b.record_seconds,
      b.record_weight_kg,
      b.record_reps,
      b.recorded_at
    from best_per_user b
    where b.rn = 1
  )
  select
    r.rank_position,
    r.user_id,
    coalesce(nullif(trim(tup.display_name), ''), substring(r.user_id::text from 1 for 8)) as full_name,
    coalesce(tup.avatar_url, '') as avatar_url,
    r.record_type,
    r.distance,
    r.record_seconds,
    r.record_weight_kg,
    r.record_reps,
    r.recorded_at
  from ranked r
  left join public.tenant_user_profiles tup
    on tup.tenant_id = p_tenant_id
   and tup.user_id = r.user_id
  order by
    r.rank_position asc,
    r.recorded_at desc,
    r.user_id asc
  limit greatest(coalesce(p_limit, 100), 1);
$$;

revoke all on function public.get_workout_leaderboard(uuid, text, text, integer) from public;
grant execute on function public.get_workout_leaderboard(uuid, text, text, integer) to authenticated;
