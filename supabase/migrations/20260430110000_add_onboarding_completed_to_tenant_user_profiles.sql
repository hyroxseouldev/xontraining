alter table public.tenant_user_profiles
  add column if not exists onboarding_completed boolean not null default false;

update public.tenant_user_profiles tup
set onboarding_completed = coalesce(p.onboarding_completed, false)
from public.profiles p
where p.id = tup.user_id
  and tup.onboarding_completed is distinct from coalesce(p.onboarding_completed, false);

comment on column public.tenant_user_profiles.onboarding_completed is
  'Tenant-scoped onboarding completion flag used by the app profile and onboarding flows.';
