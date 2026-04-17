create table public.app_version_policies (
  id uuid primary key default gen_random_uuid(),
  platform text not null,
  minimum_version text not null,
  store_url text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint app_version_policies_platform_check
    check (platform in ('ios', 'android'))
);

create unique index app_version_policies_one_active_per_platform_idx
  on public.app_version_policies (platform)
  where is_active;

alter table public.app_version_policies enable row level security;

grant select on public.app_version_policies to anon, authenticated;

create policy "Public can read active app version policies"
  on public.app_version_policies
  for select
  to anon, authenticated
  using (is_active = true);

insert into public.app_version_policies (
  platform,
  minimum_version,
  store_url,
  is_active
) values (
  'ios',
  '1.0.1',
  'https://apps.apple.com/kr/app/xon-training/id6760121153',
  true
);
