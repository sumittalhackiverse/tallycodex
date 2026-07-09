# TALly Database Setup

This project is now ready for a Supabase/Postgres database while keeping the current demo fully frontend-only.

## What Is Included

- `supabase/config.toml` for local Supabase development.
- `supabase/migrations/202607090001_initial_tally_schema.sql` with tables, constraints, indexes, RLS policies, and app-ready views.
- `supabase/seed.sql` with the same 20 synthetic customer profiles used by the prototype.
- `.env.example` with frontend environment variables.

## Main Tables

- `customer_profiles`: core customer, routing, and persona fields.
- `customer_health_conditions`: normalized health disclosures.
- `customer_lifestyle_factors`: normalized lifestyle disclosures.
- `journey_sessions`: save/resume state and autosave payloads.
- `journey_intelligence`: AI routing result, confidence, reasons, and next steps.
- `advisor_copilot_outputs`: AI-generated advisor summaries and guidance.
- `advisor_actions`: suggested advisor actions.
- `business_impact_metrics` and `business_impact_benchmarks`: executive dashboard metrics and charts.

## Views For The App

- `customer_profile_view`: customer profile plus aggregated health and lifestyle arrays.
- `advisor_dashboard_view`: customer profile plus routing and copilot outputs.

Both views use `security_invoker = true` so Row Level Security still applies.

## Local Setup

1. Install the Supabase CLI.
2. Copy `.env.example` to `.env.local`.
3. Start Supabase:

```bash
supabase start
```

4. Apply migrations and seed data:

```bash
supabase db reset
```

5. Copy the local anon key from the Supabase CLI output into `VITE_SUPABASE_ANON_KEY`.

## Security Model

The seed rows are synthetic demo data and are marked `is_demo = true`, so anonymous users can read them for the prototype.

For real customer records:

- customers can read/update rows where `owner_user_id = auth.uid()`;
- advisors can read/update rows where `advisor_user_id = auth.uid()`;
- child records are visible only when the parent customer profile is visible;
- business impact metrics are public read-only.

Service-role operations can still perform controlled back-office writes outside the browser.

## Useful Queries

```sql
select *
from public.customer_profile_view
where is_demo = true
order by customer_code;
```

```sql
select *
from public.advisor_dashboard_view
where customer_code = 'TAL-1003';
```

```sql
select label, value_prefix || metric_value || value_suffix as value, detail
from public.business_impact_metrics
order by sort_order;
```
