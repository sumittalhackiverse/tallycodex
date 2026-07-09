create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.customer_profiles (
  id uuid primary key default gen_random_uuid(),
  customer_code text not null unique,
  first_name text not null,
  last_name text not null,
  age smallint not null check (age between 18 and 75),
  occupation text not null,
  marital_status text not null,
  dependants smallint not null default 0 check (dependants between 0 and 12),
  annual_income numeric(12,2) not null check (annual_income >= 0),
  existing_cover text not null,
  insurance_goal text not null,
  complexity_score smallint not null check (complexity_score between 0 and 100),
  recommended_path text not null check (
    recommended_path in (
      'Continue digitally',
      'Advisor review recommended',
      'Advisor consultation required'
    )
  ),
  demo_persona text check (
    demo_persona is null or demo_persona in (
      'Young Professional',
      'Family with Children',
      'Complex Health Profile'
    )
  ),
  presenter_description text,
  is_demo boolean not null default false,
  owner_user_id uuid references auth.users(id) on delete set null,
  advisor_user_id uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_customer_profiles_updated_at on public.customer_profiles;
create trigger set_customer_profiles_updated_at
before update on public.customer_profiles
for each row execute function public.set_updated_at();

create table if not exists public.customer_health_conditions (
  id bigint generated always as identity primary key,
  customer_id uuid not null references public.customer_profiles(id) on delete cascade,
  condition text not null,
  sort_order smallint not null default 0,
  created_at timestamptz not null default now(),
  unique (customer_id, condition)
);

create table if not exists public.customer_lifestyle_factors (
  id bigint generated always as identity primary key,
  customer_id uuid not null references public.customer_profiles(id) on delete cascade,
  factor text not null,
  sort_order smallint not null default 0,
  created_at timestamptz not null default now(),
  unique (customer_id, factor)
);

create table if not exists public.journey_sessions (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customer_profiles(id) on delete cascade,
  current_stage text not null default 'About You' check (
    current_stage in ('About You', 'Goals', 'Cover', 'Health', 'Review', 'Completed')
  ),
  status text not null default 'in_progress' check (
    status in ('in_progress', 'saved', 'completed', 'abandoned')
  ),
  progress_percent smallint not null default 20 check (progress_percent between 0 and 100),
  saved_payload jsonb not null default '{}'::jsonb,
  autosaved_at timestamptz not null default now(),
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_journey_sessions_updated_at on public.journey_sessions;
create trigger set_journey_sessions_updated_at
before update on public.journey_sessions
for each row execute function public.set_updated_at();

create table if not exists public.journey_intelligence (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null unique references public.customer_profiles(id) on delete cascade,
  route_code text not null check (route_code in ('Route A', 'Route B', 'Route C')),
  complexity_band text not null check (complexity_band in ('simple', 'moderate', 'complex')),
  confidence_score smallint not null check (confidence_score between 0 and 100),
  decision_reasons text[] not null default '{}'::text[],
  next_steps text[] not null default '{}'::text[],
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_journey_intelligence_updated_at on public.journey_intelligence;
create trigger set_journey_intelligence_updated_at
before update on public.journey_intelligence
for each row execute function public.set_updated_at();

create table if not exists public.advisor_copilot_outputs (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null unique references public.customer_profiles(id) on delete cascade,
  customer_summary text not null,
  risk_considerations text[] not null default '{}'::text[],
  missing_information text[] not null default '{}'::text[],
  recommended_next_questions text[] not null default '{}'::text[],
  suggested_products text[] not null default '{}'::text[],
  sales_opportunities text[] not null default '{}'::text[],
  advisor_coaching text not null,
  conversation_notes text not null,
  follow_up_actions text[] not null default '{}'::text[],
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_advisor_copilot_outputs_updated_at on public.advisor_copilot_outputs;
create trigger set_advisor_copilot_outputs_updated_at
before update on public.advisor_copilot_outputs
for each row execute function public.set_updated_at();

create table if not exists public.advisor_actions (
  id bigint generated always as identity primary key,
  customer_id uuid not null references public.customer_profiles(id) on delete cascade,
  action_label text not null,
  action_type text not null check (
    action_type in ('question', 'recommendation', 'summary', 'callback')
  ),
  status text not null default 'suggested' check (
    status in ('suggested', 'accepted', 'completed', 'dismissed')
  ),
  sort_order smallint not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_advisor_actions_updated_at on public.advisor_actions;
create trigger set_advisor_actions_updated_at
before update on public.advisor_actions
for each row execute function public.set_updated_at();

create table if not exists public.business_impact_metrics (
  metric_key text primary key,
  label text not null,
  metric_value numeric(10,2) not null,
  value_prefix text not null default '',
  value_suffix text not null default '',
  detail text not null,
  sort_order smallint not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_business_impact_metrics_updated_at on public.business_impact_metrics;
create trigger set_business_impact_metrics_updated_at
before update on public.business_impact_metrics
for each row execute function public.set_updated_at();

create table if not exists public.business_impact_benchmarks (
  id bigint generated always as identity primary key,
  chart_key text not null,
  label text not null,
  before_value numeric(10,2) not null,
  after_value numeric(10,2) not null,
  value_suffix text not null default '',
  sort_order smallint not null default 0,
  created_at timestamptz not null default now(),
  unique (chart_key, label)
);

create index if not exists customer_profiles_recommended_path_idx
  on public.customer_profiles (recommended_path);
create index if not exists customer_profiles_complexity_score_idx
  on public.customer_profiles (complexity_score);
create index if not exists customer_profiles_demo_persona_idx
  on public.customer_profiles (demo_persona)
  where is_demo = true;
create index if not exists customer_profiles_owner_user_id_idx
  on public.customer_profiles (owner_user_id);
create index if not exists customer_profiles_advisor_user_id_idx
  on public.customer_profiles (advisor_user_id);

create index if not exists customer_health_conditions_customer_id_idx
  on public.customer_health_conditions (customer_id);
create index if not exists customer_lifestyle_factors_customer_id_idx
  on public.customer_lifestyle_factors (customer_id);
create index if not exists journey_sessions_customer_id_idx
  on public.journey_sessions (customer_id);
create index if not exists journey_sessions_status_autosaved_at_idx
  on public.journey_sessions (status, autosaved_at desc);
create index if not exists journey_intelligence_customer_id_idx
  on public.journey_intelligence (customer_id);
create index if not exists advisor_copilot_outputs_customer_id_idx
  on public.advisor_copilot_outputs (customer_id);
create index if not exists advisor_actions_customer_id_status_idx
  on public.advisor_actions (customer_id, status);
create index if not exists business_impact_metrics_sort_order_idx
  on public.business_impact_metrics (sort_order);
create index if not exists business_impact_benchmarks_chart_sort_idx
  on public.business_impact_benchmarks (chart_key, sort_order);

create or replace view public.customer_profile_view
with (security_invoker = true)
as
select
  p.id,
  p.customer_code,
  p.first_name,
  p.last_name,
  p.age,
  p.occupation,
  p.marital_status,
  p.dependants,
  p.annual_income,
  p.existing_cover,
  p.insurance_goal,
  p.complexity_score,
  p.recommended_path,
  p.demo_persona,
  p.presenter_description,
  p.is_demo,
  coalesce((
    select array_agg(h.condition order by h.sort_order, h.condition)
    from public.customer_health_conditions h
    where h.customer_id = p.id
  ), '{}'::text[]) as health_conditions,
  coalesce((
    select array_agg(l.factor order by l.sort_order, l.factor)
    from public.customer_lifestyle_factors l
    where l.customer_id = p.id
  ), '{}'::text[]) as lifestyle_factors,
  p.created_at,
  p.updated_at
from public.customer_profiles p;

create or replace view public.advisor_dashboard_view
with (security_invoker = true)
as
select
  p.id,
  p.customer_code,
  p.first_name,
  p.last_name,
  p.age,
  p.occupation,
  p.marital_status,
  p.dependants,
  p.annual_income,
  p.existing_cover,
  p.insurance_goal,
  p.complexity_score,
  p.recommended_path,
  ji.route_code,
  ji.complexity_band,
  ji.confidence_score,
  ji.decision_reasons,
  ji.next_steps,
  ac.customer_summary,
  ac.risk_considerations,
  ac.missing_information,
  ac.recommended_next_questions,
  ac.suggested_products,
  ac.sales_opportunities,
  ac.advisor_coaching,
  ac.conversation_notes,
  ac.follow_up_actions
from public.customer_profiles p
left join public.journey_intelligence ji on ji.customer_id = p.id
left join public.advisor_copilot_outputs ac on ac.customer_id = p.id;

alter table public.customer_profiles enable row level security;
alter table public.customer_health_conditions enable row level security;
alter table public.customer_lifestyle_factors enable row level security;
alter table public.journey_sessions enable row level security;
alter table public.journey_intelligence enable row level security;
alter table public.advisor_copilot_outputs enable row level security;
alter table public.advisor_actions enable row level security;
alter table public.business_impact_metrics enable row level security;
alter table public.business_impact_benchmarks enable row level security;

drop policy if exists customer_profiles_select_visible on public.customer_profiles;
create policy customer_profiles_select_visible
on public.customer_profiles
for select
to anon, authenticated
using (
  is_demo = true
  or owner_user_id = auth.uid()
  or advisor_user_id = auth.uid()
);

drop policy if exists customer_profiles_insert_own on public.customer_profiles;
create policy customer_profiles_insert_own
on public.customer_profiles
for insert
to authenticated
with check (owner_user_id = auth.uid());

drop policy if exists customer_profiles_update_own_or_assigned on public.customer_profiles;
create policy customer_profiles_update_own_or_assigned
on public.customer_profiles
for update
to authenticated
using (owner_user_id = auth.uid() or advisor_user_id = auth.uid())
with check (owner_user_id = auth.uid() or advisor_user_id = auth.uid());

drop policy if exists health_conditions_select_visible on public.customer_health_conditions;
create policy health_conditions_select_visible
on public.customer_health_conditions
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_health_conditions.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists health_conditions_write_own_or_assigned on public.customer_health_conditions;
create policy health_conditions_write_own_or_assigned
on public.customer_health_conditions
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_health_conditions.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_health_conditions.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists lifestyle_factors_select_visible on public.customer_lifestyle_factors;
create policy lifestyle_factors_select_visible
on public.customer_lifestyle_factors
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_lifestyle_factors.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists lifestyle_factors_write_own_or_assigned on public.customer_lifestyle_factors;
create policy lifestyle_factors_write_own_or_assigned
on public.customer_lifestyle_factors
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_lifestyle_factors.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = customer_lifestyle_factors.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists journey_sessions_select_visible on public.journey_sessions;
create policy journey_sessions_select_visible
on public.journey_sessions
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = journey_sessions.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists journey_sessions_write_own_or_assigned on public.journey_sessions;
create policy journey_sessions_write_own_or_assigned
on public.journey_sessions
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = journey_sessions.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = journey_sessions.customer_id
      and (p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists journey_intelligence_select_visible on public.journey_intelligence;
create policy journey_intelligence_select_visible
on public.journey_intelligence
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = journey_intelligence.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists journey_intelligence_write_assigned_advisor on public.journey_intelligence;
create policy journey_intelligence_write_assigned_advisor
on public.journey_intelligence
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = journey_intelligence.customer_id
      and p.advisor_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = journey_intelligence.customer_id
      and p.advisor_user_id = auth.uid()
  )
);

drop policy if exists advisor_copilot_outputs_select_visible on public.advisor_copilot_outputs;
create policy advisor_copilot_outputs_select_visible
on public.advisor_copilot_outputs
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_copilot_outputs.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists advisor_copilot_outputs_write_assigned_advisor on public.advisor_copilot_outputs;
create policy advisor_copilot_outputs_write_assigned_advisor
on public.advisor_copilot_outputs
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_copilot_outputs.customer_id
      and p.advisor_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_copilot_outputs.customer_id
      and p.advisor_user_id = auth.uid()
  )
);

drop policy if exists advisor_actions_select_visible on public.advisor_actions;
create policy advisor_actions_select_visible
on public.advisor_actions
for select
to anon, authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_actions.customer_id
      and (p.is_demo = true or p.owner_user_id = auth.uid() or p.advisor_user_id = auth.uid())
  )
);

drop policy if exists advisor_actions_write_assigned_advisor on public.advisor_actions;
create policy advisor_actions_write_assigned_advisor
on public.advisor_actions
for all
to authenticated
using (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_actions.customer_id
      and p.advisor_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.customer_profiles p
    where p.id = advisor_actions.customer_id
      and p.advisor_user_id = auth.uid()
  )
);

drop policy if exists business_impact_metrics_select_public on public.business_impact_metrics;
create policy business_impact_metrics_select_public
on public.business_impact_metrics
for select
to anon, authenticated
using (true);

drop policy if exists business_impact_benchmarks_select_public on public.business_impact_benchmarks;
create policy business_impact_benchmarks_select_public
on public.business_impact_benchmarks
for select
to anon, authenticated
using (true);

grant usage on schema public to anon, authenticated;
grant select on
  public.customer_profiles,
  public.customer_health_conditions,
  public.customer_lifestyle_factors,
  public.journey_sessions,
  public.journey_intelligence,
  public.advisor_copilot_outputs,
  public.advisor_actions,
  public.business_impact_metrics,
  public.business_impact_benchmarks
to anon, authenticated;

grant insert, update on public.customer_profiles to authenticated;
grant select, insert, update, delete on
  public.customer_health_conditions,
  public.customer_lifestyle_factors,
  public.journey_sessions,
  public.journey_intelligence,
  public.advisor_copilot_outputs,
  public.advisor_actions
to authenticated;
grant usage, select on all sequences in schema public to authenticated;

grant select on public.customer_profile_view to anon, authenticated;
grant select on public.advisor_dashboard_view to anon, authenticated;
grant select on public.business_impact_metrics to anon, authenticated;
grant select on public.business_impact_benchmarks to anon, authenticated;
