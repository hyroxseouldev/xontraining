create table if not exists public.program_session_reviews (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  program_id uuid not null references public.programs(id) on delete cascade,
  session_id uuid not null references public.sessions(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  completion_note text not null,
  status text not null default 'submitted',
  coach_feedback text not null default '',
  reviewed_by uuid references auth.users(id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint program_session_reviews_status_check
    check (status in ('submitted', 'reviewed')),
  constraint program_session_reviews_completion_note_length_check
    check (char_length(trim(completion_note)) between 30 and 300),
  constraint program_session_reviews_coach_feedback_length_check
    check (char_length(coach_feedback) <= 300),
  constraint program_session_reviews_review_state_check
    check (
      (status = 'submitted' and reviewed_by is null and reviewed_at is null)
      or (status = 'reviewed' and reviewed_by is not null and reviewed_at is not null)
    ),
  unique (tenant_id, session_id, user_id)
);

create index if not exists idx_program_session_reviews_tenant_user_created
  on public.program_session_reviews (tenant_id, user_id, created_at desc);

create index if not exists idx_program_session_reviews_tenant_session
  on public.program_session_reviews (tenant_id, session_id, created_at desc);

create index if not exists idx_program_session_reviews_tenant_program_status
  on public.program_session_reviews (tenant_id, program_id, status, created_at desc);

alter table public.program_session_reviews enable row level security;

drop policy if exists "Users can read own program session reviews" on public.program_session_reviews;
drop policy if exists "Users can create own program session reviews" on public.program_session_reviews;
drop policy if exists "Users can update own submitted program session reviews" on public.program_session_reviews;
drop policy if exists "Tenant managers can read program session reviews" on public.program_session_reviews;
drop policy if exists "Tenant managers can review program session reviews" on public.program_session_reviews;

create policy "Users can read own program session reviews"
  on public.program_session_reviews
  for select
  to authenticated
  using (
    (user_id = auth.uid() and public.is_tenant_member(tenant_id))
    or public.is_tenant_content_manager(tenant_id, auth.uid())
  );

create policy "Users can create own program session reviews"
  on public.program_session_reviews
  for insert
  to authenticated
  with check (
    user_id = auth.uid()
    and (
      public.is_tenant_member(tenant_id)
      or exists (
        select 1
        from public.program_entitlements pe
        where pe.tenant_id = program_session_reviews.tenant_id
          and pe.user_id = auth.uid()
          and pe.program_id = program_session_reviews.program_id
          and pe.is_active = true
          and pe.starts_at <= now()
          and (pe.ends_at is null or pe.ends_at >= now())
      )
    )
    and exists (
      select 1
      from public.sessions s
      where s.id = program_session_reviews.session_id
        and s.tenant_id = program_session_reviews.tenant_id
        and s.program_id = program_session_reviews.program_id
        and coalesce(s.session_type, 'training') <> 'rest'
    )
  );

create policy "Users can update own submitted program session reviews"
  on public.program_session_reviews
  for update
  to authenticated
  using (
    user_id = auth.uid()
    and public.is_tenant_member(tenant_id)
    and status = 'submitted'
    and reviewed_at is null
  )
  with check (
    user_id = auth.uid()
    and public.is_tenant_member(tenant_id)
    and status = 'submitted'
    and reviewed_by is null
    and reviewed_at is null
    and coach_feedback = ''
    and exists (
      select 1
      from public.sessions s
      where s.id = program_session_reviews.session_id
        and s.tenant_id = program_session_reviews.tenant_id
        and s.program_id = program_session_reviews.program_id
        and coalesce(s.session_type, 'training') <> 'rest'
    )
  );

create policy "Tenant managers can read program session reviews"
  on public.program_session_reviews
  for select
  to authenticated
  using (public.is_tenant_content_manager(tenant_id, auth.uid()));

create policy "Tenant managers can review program session reviews"
  on public.program_session_reviews
  for update
  to authenticated
  using (public.is_tenant_content_manager(tenant_id, auth.uid()))
  with check (
    public.is_tenant_content_manager(tenant_id, auth.uid())
    and exists (
      select 1
      from public.sessions s
      where s.id = program_session_reviews.session_id
        and s.tenant_id = program_session_reviews.tenant_id
        and s.program_id = program_session_reviews.program_id
    )
  );
