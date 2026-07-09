create table if not exists public.compliance_disclosures (
  disclosure_key text not null,
  version text not null,
  title text not null,
  regulator_reference text not null,
  required_context text not null,
  content text not null,
  effective_from date not null default current_date,
  retired_at date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (disclosure_key, version)
);

drop trigger if exists set_compliance_disclosures_updated_at on public.compliance_disclosures;
create trigger set_compliance_disclosures_updated_at
before update on public.compliance_disclosures
for each row execute function public.set_updated_at();

create table if not exists public.customer_consents (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customer_profiles(id) on delete cascade,
  disclosure_key text not null,
  disclosure_version text not null,
  consent_status text not null check (
    consent_status in ('accepted', 'declined', 'withdrawn')
  ),
  capture_channel text not null default 'digital_discovery',
  consented_at timestamptz not null default now(),
  withdrawn_at timestamptz,
  evidence jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (customer_id, disclosure_key, disclosure_version),
  foreign key (disclosure_key, disclosure_version)
    references public.compliance_disclosures(disclosure_key, version)
    on delete restrict
);

drop trigger if exists set_customer_consents_updated_at on public.customer_consents;
create trigger set_customer_consents_updated_at
before update on public.customer_consents
for each row execute function public.set_updated_at();

create table if not exists public.ai_governance_records (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customer_profiles(id) on delete cascade,
  model_purpose text not null,
  data_inputs text[] not null default '{}'::text[],
  decision_output text not null,
  explanation text not null,
  limitations text not null,
  confidence_score smallint check (confidence_score between 0 and 100),
  human_review_required boolean not null default true,
  reviewed_by uuid references auth.users(id) on delete set null,
  reviewed_at timestamptz,
  generated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.compliance_audit_events (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references public.customer_profiles(id) on delete cascade,
  actor_user_id uuid references auth.users(id) on delete set null,
  actor_type text not null check (
    actor_type in ('customer', 'advisor', 'system', 'ai_triage', 'compliance')
  ),
  event_type text not null,
  event_summary text not null,
  risk_level text not null default 'low' check (
    risk_level in ('low', 'medium', 'high')
  ),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.advisor_compliance_reviews (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null unique references public.customer_profiles(id) on delete cascade,
  advisor_user_id uuid references auth.users(id) on delete set null,
  advice_boundary text not null default 'general_information_until_advisor_review',
  fsg_required boolean not null default true,
  fsg_provided boolean not null default false,
  privacy_notice_provided boolean not null default false,
  sensitive_data_consent_verified boolean not null default false,
  replacement_cover_review_required boolean not null default false,
  vulnerable_customer_flag boolean not null default false,
  soa_required boolean not null default true,
  status text not null default 'pending' check (
    status in ('pending', 'ready_for_review', 'reviewed', 'blocked')
  ),
  review_notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_advisor_compliance_reviews_updated_at on public.advisor_compliance_reviews;
create trigger set_advisor_compliance_reviews_updated_at
before update on public.advisor_compliance_reviews
for each row execute function public.set_updated_at();

create table if not exists public.privacy_requests (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references public.customer_profiles(id) on delete set null,
  request_type text not null check (
    request_type in ('access', 'correction', 'withdraw_consent', 'delete', 'export', 'complaint')
  ),
  status text not null default 'received' check (
    status in ('received', 'in_review', 'completed', 'declined')
  ),
  request_summary text not null,
  response_due_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_privacy_requests_updated_at on public.privacy_requests;
create trigger set_privacy_requests_updated_at
before update on public.privacy_requests
for each row execute function public.set_updated_at();

create table if not exists public.retention_policies (
  policy_key text primary key,
  record_category text not null,
  retention_period text not null,
  deletion_trigger text not null,
  legal_basis text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_retention_policies_updated_at on public.retention_policies;
create trigger set_retention_policies_updated_at
before update on public.retention_policies
for each row execute function public.set_updated_at();

create index if not exists customer_consents_customer_status_idx
  on public.customer_consents (customer_id, consent_status);
create index if not exists customer_consents_disclosure_idx
  on public.customer_consents (disclosure_key, disclosure_version);
create index if not exists ai_governance_records_customer_generated_idx
  on public.ai_governance_records (customer_id, generated_at desc);
create index if not exists compliance_audit_events_customer_created_idx
  on public.compliance_audit_events (customer_id, created_at desc);
create index if not exists compliance_audit_events_type_risk_idx
  on public.compliance_audit_events (event_type, risk_level);
create index if not exists advisor_compliance_reviews_status_idx
  on public.advisor_compliance_reviews (status);
create index if not exists privacy_requests_customer_status_idx
  on public.privacy_requests (customer_id, status);

create or replace view public.compliance_customer_summary_view
with (security_invoker = true)
as
select
  p.id as customer_id,
  p.customer_code,
  p.first_name,
  p.last_name,
  p.recommended_path,
  p.complexity_score,
  coalesce((
    select count(*)::int
    from public.customer_consents c
    where c.customer_id = p.id
      and c.consent_status = 'accepted'
  ), 0) as accepted_consent_count,
  coalesce((
    select count(*)::int
    from public.ai_governance_records ai
    where ai.customer_id = p.id
      and ai.human_review_required = true
  ), 0) as ai_reviews_required,
  acr.status as advisor_review_status,
  acr.fsg_provided,
  acr.privacy_notice_provided,
  acr.sensitive_data_consent_verified,
  acr.replacement_cover_review_required,
  acr.vulnerable_customer_flag,
  acr.soa_required
from public.customer_profiles p
left join public.advisor_compliance_reviews acr on acr.customer_id = p.id;

alter table public.compliance_disclosures enable row level security;
alter table public.customer_consents enable row level security;
alter table public.ai_governance_records enable row level security;
alter table public.compliance_audit_events enable row level security;
alter table public.advisor_compliance_reviews enable row level security;
alter table public.privacy_requests enable row level security;
alter table public.retention_policies enable row level security;

drop policy if exists compliance_disclosures_select_public on public.compliance_disclosures;
create policy compliance_disclosures_select_public
on public.compliance_disclosures
for select
to anon, authenticated
using (retired_at is null);

drop policy if exists retention_policies_select_public on public.retention_policies;
create policy retention_policies_select_public
on public.retention_policies
for select
to anon, authenticated
using (true);

drop policy if exists customer_consents_select_visible on public.customer_consents;
create policy customer_consents_select_visible
on public.customer_consents
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_consents.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists customer_consents_write_own_or_assigned on public.customer_consents;
create policy customer_consents_write_own_or_assigned
on public.customer_consents
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_consents.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_consents.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists ai_governance_records_select_visible on public.ai_governance_records;
create policy ai_governance_records_select_visible
on public.ai_governance_records
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = ai_governance_records.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists ai_governance_records_write_assigned_advisor on public.ai_governance_records;
create policy ai_governance_records_write_assigned_advisor
on public.ai_governance_records
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = ai_governance_records.customer_id
      and p.advisor_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = ai_governance_records.customer_id
      and p.advisor_user_id = auth.uid()
  )
);

drop policy if exists compliance_audit_events_select_visible on public.compliance_audit_events;
create policy compliance_audit_events_select_visible
on public.compliance_audit_events
for select
to anon, authenticated
using (
  customer_id is null
  or exists (
    select 1 from public.customer_profiles p
    where p.id = compliance_audit_events.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists compliance_audit_events_insert_authenticated on public.compliance_audit_events;
create policy compliance_audit_events_insert_authenticated
on public.compliance_audit_events
for insert
to authenticated
with check (
  customer_id is null
  or exists (
    select 1 from public.customer_profiles p
    where p.id = compliance_audit_events.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists advisor_compliance_reviews_select_visible on public.advisor_compliance_reviews;
create policy advisor_compliance_reviews_select_visible
on public.advisor_compliance_reviews
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_compliance_reviews.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists advisor_compliance_reviews_write_assigned_advisor on public.advisor_compliance_reviews;
create policy advisor_compliance_reviews_write_assigned_advisor
on public.advisor_compliance_reviews
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_compliance_reviews.customer_id
      and p.advisor_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_compliance_reviews.customer_id
      and p.advisor_user_id = auth.uid()
  )
);

drop policy if exists privacy_requests_select_visible on public.privacy_requests;
create policy privacy_requests_select_visible
on public.privacy_requests
for select
to authenticated
using (
  customer_id is null
  or exists (
    select 1 from public.customer_profiles p
    where p.id = privacy_requests.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists privacy_requests_insert_authenticated on public.privacy_requests;
create policy privacy_requests_insert_authenticated
on public.privacy_requests
for insert
to authenticated
with check (
  customer_id is null
  or exists (
    select 1 from public.customer_profiles p
    where p.id = privacy_requests.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

grant select on
  public.compliance_disclosures,
  public.retention_policies,
  public.customer_consents,
  public.ai_governance_records,
  public.compliance_audit_events,
  public.advisor_compliance_reviews
to anon, authenticated;

grant select, insert, update, delete on
  public.customer_consents,
  public.ai_governance_records,
  public.advisor_compliance_reviews
to authenticated;

grant select, insert on
  public.compliance_audit_events,
  public.privacy_requests
to authenticated;

grant select on public.compliance_customer_summary_view to anon, authenticated;
grant usage, select on all sequences in schema public to authenticated;
