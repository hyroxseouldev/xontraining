-- Allow authenticated users to bootstrap and maintain their own
-- tenant_user_profiles row before tenant_memberships exists.

drop policy if exists "Users can read own tenant_user_profiles"
  on public.tenant_user_profiles;

create policy "Users can read own tenant_user_profiles"
  on public.tenant_user_profiles
  for select
  to authenticated
  using (user_id = auth.uid());

drop policy if exists "Users can create own tenant_user_profiles"
  on public.tenant_user_profiles;

create policy "Users can create own tenant_user_profiles"
  on public.tenant_user_profiles
  for insert
  to authenticated
  with check (user_id = auth.uid());

drop policy if exists "Users can update own tenant_user_profiles"
  on public.tenant_user_profiles;

create policy "Users can update own tenant_user_profiles"
  on public.tenant_user_profiles
  for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
