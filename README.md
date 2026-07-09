# TALly - AI Assisted Insurance Journey

TALly is a polished single-page prototype showing a hybrid insurance journey where customers complete discovery online, receive lightweight AI guidance, and advisors receive a pre-qualified customer profile.

## Demo

Open the self-contained preview:

```text
outputs/tally-demo.html
```

The React source lives in `src/`, with Tailwind styling and synthetic customer data.

## Database Setup

The project now includes a Supabase/Postgres database foundation:

- `supabase/migrations/202607090001_initial_tally_schema.sql`
- `supabase/seed.sql`
- `supabase/config.toml`
- `database/README.md`
- `.env.example`

The schema includes customer profiles, health and lifestyle disclosures, save/resume journey sessions, explainable AI routing, advisor copilot outputs, suggested actions, and business impact metrics.

The compliance layer is documented in `COMPLIANCE.md` and includes disclosure, consent, AI governance, audit, privacy request, retention, and advisor-review tables.

## Local Database Commands

```bash
supabase start
supabase db reset
```

Then copy the local anon key into `.env.local` using `.env.example` as the template.

## Frontend Commands

```bash
npm install
npm run dev
npm run build
```

Node/npm, Supabase CLI, and psql were not available in the Codex workspace where this was created. The self-contained preview can be opened locally from `outputs/tally-demo.html`.
