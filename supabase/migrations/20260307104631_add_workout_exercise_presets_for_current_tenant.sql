-- Workout exercise master + preset catalog (current tenant only)

create table if not exists public.workout_exercises (
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  exercise_key text not null,
  record_type text not null check (record_type in ('time', 'weight')),
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (tenant_id, exercise_key)
);

create index if not exists idx_workout_exercises_tenant_sort
  on public.workout_exercises (tenant_id, sort_order, exercise_key);

create table if not exists public.workout_exercise_presets (
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  exercise_key text not null,
  preset_key text not null,
  distance_m integer,
  target_reps integer,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (tenant_id, exercise_key, preset_key),
  constraint workout_exercise_presets_exercise_fk
    foreign key (tenant_id, exercise_key)
    references public.workout_exercises (tenant_id, exercise_key)
    on delete cascade,
  constraint workout_exercise_presets_distance_check
    check (distance_m is null or distance_m > 0),
  constraint workout_exercise_presets_reps_check
    check (target_reps is null or target_reps > 0),
  constraint workout_exercise_presets_value_shape_check
    check (
      (distance_m is not null and target_reps is null)
      or (distance_m is null and target_reps is not null)
    )
);

create index if not exists idx_workout_exercise_presets_tenant_exercise_sort
  on public.workout_exercise_presets (tenant_id, exercise_key, sort_order);

alter table public.user_workout_records_v2
  add column if not exists preset_key text;

create index if not exists idx_user_workout_records_v2_tenant_exercise_preset
  on public.user_workout_records_v2 (tenant_id, exercise_key, preset_key);

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'user_workout_records_v2_preset_fk'
  ) then
    alter table public.user_workout_records_v2
      add constraint user_workout_records_v2_preset_fk
      foreign key (tenant_id, exercise_key, preset_key)
      references public.workout_exercise_presets (tenant_id, exercise_key, preset_key)
      on update cascade
      on delete set null;
  end if;
end
$$;

alter table public.workout_exercises enable row level security;
alter table public.workout_exercise_presets enable row level security;

drop policy if exists "Tenant members can read workout_exercises" on public.workout_exercises;
drop policy if exists "Tenant managers can manage workout_exercises" on public.workout_exercises;
drop policy if exists "Tenant members can read workout_exercise_presets" on public.workout_exercise_presets;
drop policy if exists "Tenant managers can manage workout_exercise_presets" on public.workout_exercise_presets;

create policy "Tenant members can read workout_exercises"
  on public.workout_exercises
  for select
  to authenticated
  using (
    public.is_tenant_member(tenant_id)
    or public.is_tenant_content_manager(tenant_id, auth.uid())
  );

create policy "Tenant managers can manage workout_exercises"
  on public.workout_exercises
  for all
  to authenticated
  using (public.is_tenant_content_manager(tenant_id, auth.uid()))
  with check (public.is_tenant_content_manager(tenant_id, auth.uid()));

create policy "Tenant members can read workout_exercise_presets"
  on public.workout_exercise_presets
  for select
  to authenticated
  using (
    public.is_tenant_member(tenant_id)
    or public.is_tenant_content_manager(tenant_id, auth.uid())
  );

create policy "Tenant managers can manage workout_exercise_presets"
  on public.workout_exercise_presets
  for all
  to authenticated
  using (public.is_tenant_content_manager(tenant_id, auth.uid()))
  with check (public.is_tenant_content_manager(tenant_id, auth.uid()));

with tenant_list as (
  select id as tenant_id
  from public.tenants
  where id = 'f95921fa-315f-4957-8f12-16a3ce5b9ac3'::uuid
),
exercise_seed as (
  select * from (values
    ('rowing', 'time', 10),
    ('ski', 'time', 20),
    ('running', 'time', 30),
    ('squat', 'weight', 40),
    ('deadlift', 'weight', 50),
    ('bench_press', 'weight', 60)
  ) as s(exercise_key, record_type, sort_order)
)
insert into public.workout_exercises (
  tenant_id,
  exercise_key,
  record_type,
  sort_order,
  is_active
)
select
  t.tenant_id,
  e.exercise_key,
  e.record_type,
  e.sort_order,
  true
from tenant_list t
cross join exercise_seed e
on conflict (tenant_id, exercise_key) do update
set
  record_type = excluded.record_type,
  sort_order = excluded.sort_order,
  is_active = true,
  updated_at = now();

with tenant_list as (
  select id as tenant_id
  from public.tenants
  where id = 'f95921fa-315f-4957-8f12-16a3ce5b9ac3'::uuid
),
preset_seed as (
  select * from (values
    ('rowing', '500m', 500, null::integer, 10),
    ('rowing', '2000m', 2000, null::integer, 20),
    ('ski', '500m', 500, null::integer, 10),
    ('ski', '2000m', 2000, null::integer, 20),
    ('running', '1km', 1000, null::integer, 10),
    ('running', '3km', 3000, null::integer, 20),
    ('running', '5km', 5000, null::integer, 30),
    ('running', '10km', 10000, null::integer, 40),
    ('squat', '1rm', null::integer, 1, 10),
    ('squat', '3rm', null::integer, 3, 20),
    ('squat', '5rm', null::integer, 5, 30),
    ('deadlift', '1rm', null::integer, 1, 10),
    ('deadlift', '3rm', null::integer, 3, 20),
    ('deadlift', '5rm', null::integer, 5, 30),
    ('bench_press', '1rm', null::integer, 1, 10),
    ('bench_press', '3rm', null::integer, 3, 20),
    ('bench_press', '5rm', null::integer, 5, 30)
  ) as s(exercise_key, preset_key, distance_m, target_reps, sort_order)
)
insert into public.workout_exercise_presets (
  tenant_id,
  exercise_key,
  preset_key,
  distance_m,
  target_reps,
  sort_order,
  is_active
)
select
  t.tenant_id,
  p.exercise_key,
  p.preset_key,
  p.distance_m,
  p.target_reps,
  p.sort_order,
  true
from tenant_list t
cross join preset_seed p
on conflict (tenant_id, exercise_key, preset_key) do update
set
  distance_m = excluded.distance_m,
  target_reps = excluded.target_reps,
  sort_order = excluded.sort_order,
  is_active = true,
  updated_at = now();
