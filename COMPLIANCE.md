# TALly Compliance Layer

This prototype includes a compliance-ready control layer for an Australian life-insurance journey. It is not legal advice and is not a substitute for insurer, legal, privacy, risk, security, or Australian Financial Services Licence review.

## Regulatory Baseline Used

- ASIC RG 175: financial product advice conduct and disclosure for retail clients.
- OAIC Australian Privacy Principle 5: notification at or before collection of personal information.
- Privacy Act / Australian Privacy Principles: privacy notice, consent, access, correction, disclosure, and sensitive-information handling.
- APRA CPS 230: operational risk management, accountability, and control evidence for regulated entities.
- Life Insurance Code of Practice: plain-English customer experience and vulnerable-customer awareness.

Official references:

- https://www.asic.gov.au/regulatory-resources/find-a-document/regulatory-guides/rg-175-afs-licensing-financial-product-advisers-conduct-and-disclosure/
- https://www.oaic.gov.au/privacy/australian-privacy-principles/australian-privacy-principles-guidelines/chapter-5-app-5-notification-of-the-collection-of-personal-information
- https://www.apra.gov.au/sites/default/files/2023-07/Prudential%20Standard%20CPS%20230%20Operational%20Risk%20Management.pdf

## Implemented App Controls

- General-information warning before the journey.
- Privacy collection notice summary before discovery.
- Sensitive health-information consent prompt and review checklist.
- Clear AI guidance boundary: AI assists completion and routing; advisors provide human review.
- Explainable routing with reasons, confidence, and next-step transparency.
- Advisor compliance guardrails for FSG/disclosure, replacement-cover review, vulnerability awareness, and Statement of Advice readiness.
- Compliance dashboard with regulatory mapping, audit-trail preview, customer rights, and retention controls.

## Implemented Database Controls

Migration:

```text
supabase/migrations/202607090002_compliance_controls.sql
```

Tables:

- `compliance_disclosures`
- `customer_consents`
- `ai_governance_records`
- `compliance_audit_events`
- `advisor_compliance_reviews`
- `privacy_requests`
- `retention_policies`

View:

- `compliance_customer_summary_view`

Seed data:

- disclosure documents
- retention policies
- accepted consent records for synthetic personas
- AI governance records
- advisor compliance review records
- compliance audit events

## Production Sign-Off Still Required

- Confirm whether the flow gives general advice, personal advice, factual information, or a mix under the licensee model.
- Review all privacy collection notices against the insurer's actual collection, disclosure, overseas recipient, retention, and complaint practices.
- Confirm health-information consent language and retention period.
- Confirm FSG, PDS, Target Market Determination, duty-of-disclosure, replacement-cover, and Statement of Advice requirements.
- Perform accessibility, penetration testing, logging, monitoring, incident response, model-risk, and third-party-risk reviews.
