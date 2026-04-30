create or replace function public.soft_delete_my_account(p_tenant_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
  v_role text;
  v_now timestamptz := now();
begin
  if v_user_id is null then
    raise exception using
      errcode = 'P0001',
      message = 'Authentication required.';
  end if;

  if p_tenant_id is null then
    raise exception using
      errcode = 'P0001',
      message = 'tenantId is required.';
  end if;

  select tm.role
    into v_role
  from public.tenant_memberships tm
  where tm.tenant_id = p_tenant_id
    and tm.user_id = v_user_id
  limit 1;

  if v_role in ('coach', 'owner') then
    raise exception using
      errcode = 'P0001',
      message = 'Coach and owner accounts cannot be deleted.';
  end if;

  update public.profiles
  set is_deleted = true,
      deleted_at = coalesce(deleted_at, v_now)
  where id = v_user_id;

  if not found then
    raise exception using
      errcode = 'P0001',
      message = 'Profile not found.';
  end if;

  update public.tenant_user_profiles
  set tenant_status = 'deactivated',
      deactivated_at = coalesce(deactivated_at, v_now)
  where user_id = v_user_id
    and tenant_status <> 'deactivated';
end;
$$;

revoke all on function public.soft_delete_my_account(uuid) from public;
grant execute on function public.soft_delete_my_account(uuid) to authenticated;

comment on function public.soft_delete_my_account(uuid) is
  'Deactivates the caller account across profiles and tenant_user_profiles after validating the current tenant role.';
