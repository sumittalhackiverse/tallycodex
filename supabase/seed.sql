insert into public.customer_profiles (
  id,
  customer_code,
  first_name,
  last_name,
  age,
  occupation,
  marital_status,
  dependants,
  annual_income,
  existing_cover,
  insurance_goal,
  complexity_score,
  recommended_path,
  demo_persona,
  presenter_description,
  is_demo
) values
('00000000-0000-0000-0000-000000001001','TAL-1001','Mia','Chen',29,'Software Engineer','Single',0,118000,'Employer default cover','Income protection while building savings',24,'Continue digitally','Young Professional','Simple journey: low complexity, digitally confident, fast self-service path.',true),
('00000000-0000-0000-0000-000000001002','TAL-1002','Daniel','Hughes',36,'Project Manager','Married',2,142000,'Basic life and TPD through super','Family protection and mortgage security',58,'Advisor review recommended','Family with Children','Moderate journey: strong advisor opportunity with dependants, mortgage, and cover gaps.',true),
('00000000-0000-0000-0000-000000001003','TAL-1003','Priya','Nair',48,'Small Business Owner','Married',1,196000,'Legacy retail policy, unsure of exclusions','Business continuity and family protection',84,'Advisor consultation required','Complex Health Profile','Complex journey: AI triage identifies underwriting and advice needs before the call.',true),
('00000000-0000-0000-0000-000000001004','TAL-1004','Oliver','Reed',41,'Architect','Married',1,155000,'Life cover through super','Protect family income',45,'Advisor review recommended',null,null,true),
('00000000-0000-0000-0000-000000001005','TAL-1005','Amara','King',33,'Dentist','Partnered',0,188000,'Income protection only','Income and trauma cover',34,'Continue digitally',null,null,true),
('00000000-0000-0000-0000-000000001006','TAL-1006','Noah','Patel',52,'Electrician','Married',3,121000,'Minimal super cover','Family protection and debt coverage',72,'Advisor consultation required',null,null,true),
('00000000-0000-0000-0000-000000001007','TAL-1007','Sofia','Martinez',27,'Marketing Specialist','Single',0,92000,'No existing cover','Affordable starter cover',18,'Continue digitally',null,null,true),
('00000000-0000-0000-0000-000000001008','TAL-1008','Ethan','Brooks',44,'Sales Director','Divorced',2,230000,'Multiple policies, unclear ownership','Review cover and beneficiary structure',68,'Advisor review recommended',null,null,true),
('00000000-0000-0000-0000-000000001009','TAL-1009','Grace','Wilson',38,'Teacher','Married',2,96000,'Basic super cover','Family and income protection',51,'Advisor review recommended',null,null,true),
('00000000-0000-0000-0000-000000001010','TAL-1010','Lucas','Brown',31,'Accountant','Partnered',0,104000,'Employer default cover','Protect future mortgage plans',22,'Continue digitally',null,null,true),
('00000000-0000-0000-0000-000000001011','TAL-1011','Ava','Thompson',46,'Nurse Unit Manager','Married',2,128000,'Life and trauma cover','Update cover after promotion',63,'Advisor review recommended',null,null,true),
('00000000-0000-0000-0000-000000001012','TAL-1012','Henry','Singh',57,'Restaurant Owner','Married',0,172000,'Old retail life policy','Business debt and succession protection',88,'Advisor consultation required',null,null,true),
('00000000-0000-0000-0000-000000001013','TAL-1013','Zara','Ibrahim',25,'Graduate Lawyer','Single',0,87000,'No existing cover','Starter income protection',16,'Continue digitally',null,null,true),
('00000000-0000-0000-0000-000000001014','TAL-1014','Jack','Morgan',39,'Mining Supervisor','Partnered',1,210000,'Super cover only','Income protection and life cover',66,'Advisor review recommended',null,null,true),
('00000000-0000-0000-0000-000000001015','TAL-1015','Lily','Evans',34,'Physiotherapist','Married',1,115000,'Income protection','Add life and TPD cover',37,'Continue digitally',null,null,true),
('00000000-0000-0000-0000-000000001016','TAL-1016','Marcus','Lee',50,'Airline Pilot','Married',3,255000,'Multiple employer-linked covers','Consolidate cover and protect family',71,'Advisor consultation required',null,null,true),
('00000000-0000-0000-0000-000000001017','TAL-1017','Hannah','Scott',42,'HR Consultant','Single parent',1,132000,'Basic super cover','Protect child and income',56,'Advisor review recommended',null,null,true),
('00000000-0000-0000-0000-000000001018','TAL-1018','Ben','Fraser',30,'UX Designer','Partnered',0,108000,'Default super cover','Income protection and trauma option',32,'Continue digitally',null,null,true),
('00000000-0000-0000-0000-000000001019','TAL-1019','Claire','Bennett',55,'Pharmacist','Married',0,146000,'Life cover, benefit amount unknown','Review trauma and estate cover',62,'Advisor review recommended',null,null,true),
('00000000-0000-0000-0000-000000001020','TAL-1020','Ryan','O''Connor',60,'Self-employed Builder','Married',2,168000,'Lapsed income protection','Rebuild cover before retirement transition',91,'Advisor consultation required',null,null,true)
on conflict (customer_code) do update set
  first_name = excluded.first_name,
  last_name = excluded.last_name,
  age = excluded.age,
  occupation = excluded.occupation,
  marital_status = excluded.marital_status,
  dependants = excluded.dependants,
  annual_income = excluded.annual_income,
  existing_cover = excluded.existing_cover,
  insurance_goal = excluded.insurance_goal,
  complexity_score = excluded.complexity_score,
  recommended_path = excluded.recommended_path,
  demo_persona = excluded.demo_persona,
  presenter_description = excluded.presenter_description,
  is_demo = excluded.is_demo,
  updated_at = now();

with seed(customer_code, health_conditions, lifestyle_factors) as (
  values
  ('TAL-1001', array['None disclosed']::text[], array['Runs weekly','Non-smoker']::text[]),
  ('TAL-1002', array['Mild asthma']::text[], array['Occasional skiing','Non-smoker']::text[]),
  ('TAL-1003', array['Type 2 diabetes','Recent knee surgery']::text[], array['Frequent travel','Former smoker']::text[]),
  ('TAL-1004', array['None disclosed']::text[], array['Cycling commuter']::text[]),
  ('TAL-1005', array['None disclosed']::text[], array['Pilates','Non-smoker']::text[]),
  ('TAL-1006', array['High blood pressure']::text[], array['Manual work','Weekend motorcycling']::text[]),
  ('TAL-1007', array['None disclosed']::text[], array['Gym 3x weekly']::text[]),
  ('TAL-1008', array['Sleep apnea']::text[], array['Frequent travel']::text[]),
  ('TAL-1009', array['Mild anxiety, managed']::text[], array['Non-smoker']::text[]),
  ('TAL-1010', array['None disclosed']::text[], array['Non-smoker']::text[]),
  ('TAL-1011', array['Back injury history']::text[], array['Shift work']::text[]),
  ('TAL-1012', array['High cholesterol','Past cardiac investigation']::text[], array['Long working hours']::text[]),
  ('TAL-1013', array['None disclosed']::text[], array['Social sport']::text[]),
  ('TAL-1014', array['None disclosed']::text[], array['Remote work','Hazardous occupation']::text[]),
  ('TAL-1015', array['None disclosed']::text[], array['Active lifestyle']::text[]),
  ('TAL-1016', array['None disclosed']::text[], array['Aviation occupation','International travel']::text[]),
  ('TAL-1017', array['Thyroid condition, managed']::text[], array['Non-smoker']::text[]),
  ('TAL-1018', array['None disclosed']::text[], array['Rock climbing']::text[]),
  ('TAL-1019', array['Family history of cancer']::text[], array['Non-smoker']::text[]),
  ('TAL-1020', array['Knee replacement','High BMI']::text[], array['Manual work','Occasional smoker']::text[])
)
delete from public.customer_health_conditions h
using public.customer_profiles p, seed s
where h.customer_id = p.id
  and p.customer_code = s.customer_code;

with seed(customer_code, health_conditions, lifestyle_factors) as (
  values
  ('TAL-1001', array['None disclosed']::text[], array['Runs weekly','Non-smoker']::text[]),
  ('TAL-1002', array['Mild asthma']::text[], array['Occasional skiing','Non-smoker']::text[]),
  ('TAL-1003', array['Type 2 diabetes','Recent knee surgery']::text[], array['Frequent travel','Former smoker']::text[]),
  ('TAL-1004', array['None disclosed']::text[], array['Cycling commuter']::text[]),
  ('TAL-1005', array['None disclosed']::text[], array['Pilates','Non-smoker']::text[]),
  ('TAL-1006', array['High blood pressure']::text[], array['Manual work','Weekend motorcycling']::text[]),
  ('TAL-1007', array['None disclosed']::text[], array['Gym 3x weekly']::text[]),
  ('TAL-1008', array['Sleep apnea']::text[], array['Frequent travel']::text[]),
  ('TAL-1009', array['Mild anxiety, managed']::text[], array['Non-smoker']::text[]),
  ('TAL-1010', array['None disclosed']::text[], array['Non-smoker']::text[]),
  ('TAL-1011', array['Back injury history']::text[], array['Shift work']::text[]),
  ('TAL-1012', array['High cholesterol','Past cardiac investigation']::text[], array['Long working hours']::text[]),
  ('TAL-1013', array['None disclosed']::text[], array['Social sport']::text[]),
  ('TAL-1014', array['None disclosed']::text[], array['Remote work','Hazardous occupation']::text[]),
  ('TAL-1015', array['None disclosed']::text[], array['Active lifestyle']::text[]),
  ('TAL-1016', array['None disclosed']::text[], array['Aviation occupation','International travel']::text[]),
  ('TAL-1017', array['Thyroid condition, managed']::text[], array['Non-smoker']::text[]),
  ('TAL-1018', array['None disclosed']::text[], array['Rock climbing']::text[]),
  ('TAL-1019', array['Family history of cancer']::text[], array['Non-smoker']::text[]),
  ('TAL-1020', array['Knee replacement','High BMI']::text[], array['Manual work','Occasional smoker']::text[])
)
insert into public.customer_health_conditions (customer_id, condition, sort_order)
select p.id, item.condition, item.ordinality::smallint
from seed s
join public.customer_profiles p on p.customer_code = s.customer_code
cross join lateral unnest(s.health_conditions) with ordinality as item(condition, ordinality);

with seed(customer_code, health_conditions, lifestyle_factors) as (
  values
  ('TAL-1001', array['None disclosed']::text[], array['Runs weekly','Non-smoker']::text[]),
  ('TAL-1002', array['Mild asthma']::text[], array['Occasional skiing','Non-smoker']::text[]),
  ('TAL-1003', array['Type 2 diabetes','Recent knee surgery']::text[], array['Frequent travel','Former smoker']::text[]),
  ('TAL-1004', array['None disclosed']::text[], array['Cycling commuter']::text[]),
  ('TAL-1005', array['None disclosed']::text[], array['Pilates','Non-smoker']::text[]),
  ('TAL-1006', array['High blood pressure']::text[], array['Manual work','Weekend motorcycling']::text[]),
  ('TAL-1007', array['None disclosed']::text[], array['Gym 3x weekly']::text[]),
  ('TAL-1008', array['Sleep apnea']::text[], array['Frequent travel']::text[]),
  ('TAL-1009', array['Mild anxiety, managed']::text[], array['Non-smoker']::text[]),
  ('TAL-1010', array['None disclosed']::text[], array['Non-smoker']::text[]),
  ('TAL-1011', array['Back injury history']::text[], array['Shift work']::text[]),
  ('TAL-1012', array['High cholesterol','Past cardiac investigation']::text[], array['Long working hours']::text[]),
  ('TAL-1013', array['None disclosed']::text[], array['Social sport']::text[]),
  ('TAL-1014', array['None disclosed']::text[], array['Remote work','Hazardous occupation']::text[]),
  ('TAL-1015', array['None disclosed']::text[], array['Active lifestyle']::text[]),
  ('TAL-1016', array['None disclosed']::text[], array['Aviation occupation','International travel']::text[]),
  ('TAL-1017', array['Thyroid condition, managed']::text[], array['Non-smoker']::text[]),
  ('TAL-1018', array['None disclosed']::text[], array['Rock climbing']::text[]),
  ('TAL-1019', array['Family history of cancer']::text[], array['Non-smoker']::text[]),
  ('TAL-1020', array['Knee replacement','High BMI']::text[], array['Manual work','Occasional smoker']::text[])
)
delete from public.customer_lifestyle_factors l
using public.customer_profiles p, seed s
where l.customer_id = p.id
  and p.customer_code = s.customer_code;

with seed(customer_code, health_conditions, lifestyle_factors) as (
  values
  ('TAL-1001', array['None disclosed']::text[], array['Runs weekly','Non-smoker']::text[]),
  ('TAL-1002', array['Mild asthma']::text[], array['Occasional skiing','Non-smoker']::text[]),
  ('TAL-1003', array['Type 2 diabetes','Recent knee surgery']::text[], array['Frequent travel','Former smoker']::text[]),
  ('TAL-1004', array['None disclosed']::text[], array['Cycling commuter']::text[]),
  ('TAL-1005', array['None disclosed']::text[], array['Pilates','Non-smoker']::text[]),
  ('TAL-1006', array['High blood pressure']::text[], array['Manual work','Weekend motorcycling']::text[]),
  ('TAL-1007', array['None disclosed']::text[], array['Gym 3x weekly']::text[]),
  ('TAL-1008', array['Sleep apnea']::text[], array['Frequent travel']::text[]),
  ('TAL-1009', array['Mild anxiety, managed']::text[], array['Non-smoker']::text[]),
  ('TAL-1010', array['None disclosed']::text[], array['Non-smoker']::text[]),
  ('TAL-1011', array['Back injury history']::text[], array['Shift work']::text[]),
  ('TAL-1012', array['High cholesterol','Past cardiac investigation']::text[], array['Long working hours']::text[]),
  ('TAL-1013', array['None disclosed']::text[], array['Social sport']::text[]),
  ('TAL-1014', array['None disclosed']::text[], array['Remote work','Hazardous occupation']::text[]),
  ('TAL-1015', array['None disclosed']::text[], array['Active lifestyle']::text[]),
  ('TAL-1016', array['None disclosed']::text[], array['Aviation occupation','International travel']::text[]),
  ('TAL-1017', array['Thyroid condition, managed']::text[], array['Non-smoker']::text[]),
  ('TAL-1018', array['None disclosed']::text[], array['Rock climbing']::text[]),
  ('TAL-1019', array['Family history of cancer']::text[], array['Non-smoker']::text[]),
  ('TAL-1020', array['Knee replacement','High BMI']::text[], array['Manual work','Occasional smoker']::text[])
)
insert into public.customer_lifestyle_factors (customer_id, factor, sort_order)
select p.id, item.factor, item.ordinality::smallint
from seed s
join public.customer_profiles p on p.customer_code = s.customer_code
cross join lateral unnest(s.lifestyle_factors) with ordinality as item(factor, ordinality);

delete from public.journey_sessions
where customer_id in (
  select id from public.customer_profiles where is_demo = true
);

insert into public.journey_sessions (
  customer_id,
  current_stage,
  status,
  progress_percent,
  saved_payload,
  autosaved_at
)
select
  p.id,
  case
    when p.complexity_score >= 72 then 'Health'
    when p.complexity_score >= 40 then 'Review'
    else 'Cover'
  end,
  'saved',
  case
    when p.complexity_score >= 72 then 80
    when p.complexity_score >= 40 then 100
    else 60
  end,
  jsonb_build_object(
    'source', 'synthetic_seed',
    'lastKnownPath', p.recommended_path
  ),
  now()
from public.customer_profiles p
where p.is_demo = true
;

insert into public.journey_intelligence (
  customer_id,
  route_code,
  complexity_band,
  confidence_score,
  decision_reasons,
  next_steps
)
select
  p.id,
  case
    when p.complexity_score < 40 then 'Route A'
    when p.complexity_score < 72 then 'Route B'
    else 'Route C'
  end,
  case
    when p.complexity_score < 40 then 'simple'
    when p.complexity_score < 72 then 'moderate'
    else 'complex'
  end,
  least(96, case
    when p.complexity_score < 40 then 92
    when p.complexity_score < 72 then 87
    else 83
  end + round((100 - p.complexity_score) / 20.0)::int),
  case
    when p.complexity_score < 40 then array['No major health disclosures','Simple cover need','Low missing-information risk']::text[]
    when p.complexity_score < 72 then array['Dependants or debt protection need','Coverage gap identified','Advisor can improve fit']::text[]
    else array['Health or lifestyle disclosures','Coverage and ownership complexity','Specialist advice required']::text[]
  end,
  case
    when p.complexity_score < 40 then array['Continue online','Confirm cover amount','Fast-track application']::text[]
    when p.complexity_score < 72 then array['Schedule advisor call','Pre-fill recommendation notes','Fast-track review']::text[]
    else array['Advisor consultation','Clarify underwriting details','Prepare tailored advice']::text[]
  end
from public.customer_profiles p
where p.is_demo = true
on conflict (customer_id) do update set
  route_code = excluded.route_code,
  complexity_band = excluded.complexity_band,
  confidence_score = excluded.confidence_score,
  decision_reasons = excluded.decision_reasons,
  next_steps = excluded.next_steps,
  updated_at = now();

insert into public.advisor_copilot_outputs (
  customer_id,
  customer_summary,
  risk_considerations,
  missing_information,
  recommended_next_questions,
  suggested_products,
  sales_opportunities,
  advisor_coaching,
  conversation_notes,
  follow_up_actions
)
select
  p.id,
  format('%s is a %s-year-old %s with %s, seeking %s. The recommended path is %s.',
    p.first_name,
    p.age,
    lower(p.occupation),
    case when p.dependants = 0 then 'no dependants' else p.dependants || ' dependant(s)' end,
    lower(p.insurance_goal),
    lower(p.recommended_path)
  ),
  array[
    case
      when exists (
        select 1 from public.customer_health_conditions h
        where h.customer_id = p.id and h.condition <> 'None disclosed'
      ) then 'Clarify disclosed health items before recommendation.'
      else 'No disclosed health conditions, so underwriting friction appears low.'
    end,
    'Confirm lifestyle factors and occupational risk before submission.',
    case
      when p.dependants > 0 then 'Dependants increase the need for clear sum-insured reasoning.'
      else 'Cover need can likely be explained with simple income continuity framing.'
    end
  ]::text[],
  array[
    'Confirm benefit amounts and ownership of existing cover.',
    case when p.dependants > 0 then 'Confirm mortgage balance and education-cost expectations.' else 'Confirm monthly expenses and savings buffer.' end,
    'Confirm no recent investigations or pending tests.'
  ]::text[],
  array[
    'What outcome would make this cover feel worth it for you?',
    case when p.dependants > 0 then 'If income stopped for six months, what would your family need protected first?' else 'How many months of income would you want protected while you recover?' end,
    'Would you prefer a lean starter option or broader protection?'
  ]::text[],
  array[
    case when p.dependants > 0 then 'Life cover sized to family and debt needs' else 'Starter life cover with flexible increases' end,
    'Income protection with benefit-period options',
    case when p.complexity_score >= 72 then 'Underwriting pre-check before formal application' else 'TPD and trauma consideration as optional layers' end
  ]::text[],
  array[
    case when p.dependants > 0 then 'TPD discussion is timely because family protection is the stated goal.' else 'Income protection is a natural first product based on age and goal.' end,
    case when p.annual_income > 150000 then 'Higher income creates room to discuss benefit caps and quality of cover.' else 'Lead with affordability and flexible staging.' end,
    case when p.complexity_score >= 72 then 'Use consultation to turn uncertainty into trust and reduce drop-off.' else 'Use digital completion to shorten the call and maintain momentum.' end
  ]::text[],
  case
    when p.complexity_score < 40 then 'Keep the conversation short and confidence-building. Confirm assumptions, explain value, and help the customer finish online.'
    when p.complexity_score < 72 then 'Lead with family outcomes, avoid jargon, and use the pre-filled facts to spend the call on trade-offs rather than data collection.'
    else 'Acknowledge complexity early. Explain that the advisor is here to reduce uncertainty, not add paperwork.'
  end,
  format('Customer intent: %s. Current profile: %s, %s, %s, %s dependant(s). Existing cover: %s. Complexity score %s/100. Recommended next step: %s.',
    p.insurance_goal,
    p.age,
    p.occupation,
    p.marital_status,
    p.dependants,
    p.existing_cover,
    p.complexity_score,
    p.recommended_path
  ),
  array[
    'Send customer summary link',
    'Attach comparison of current and recommended cover',
    case when p.complexity_score >= 72 then 'Book underwriting clarification call' else 'Confirm preferred cover level' end
  ]::text[]
from public.customer_profiles p
where p.is_demo = true
on conflict (customer_id) do update set
  customer_summary = excluded.customer_summary,
  risk_considerations = excluded.risk_considerations,
  missing_information = excluded.missing_information,
  recommended_next_questions = excluded.recommended_next_questions,
  suggested_products = excluded.suggested_products,
  sales_opportunities = excluded.sales_opportunities,
  advisor_coaching = excluded.advisor_coaching,
  conversation_notes = excluded.conversation_notes,
  follow_up_actions = excluded.follow_up_actions,
  updated_at = now();

delete from public.advisor_actions
where customer_id in (
  select id from public.customer_profiles where is_demo = true
);

insert into public.advisor_actions (customer_id, action_label, action_type, sort_order)
select p.id, action_label, action_type, sort_order
from public.customer_profiles p
cross join (
  values
  ('Ask next question','question',1),
  ('Recommend cover option','recommendation',2),
  ('Send summary link','summary',3),
  ('Schedule callback','callback',4)
) as actions(action_label, action_type, sort_order)
where p.is_demo = true;

insert into public.business_impact_metrics (
  metric_key,
  label,
  metric_value,
  value_prefix,
  value_suffix,
  detail,
  sort_order
) values
('call_time_reduced','Call time reduced',40,'-','%','Less intake admin',1),
('conversion_uplift','Conversion uplift',18,'+','%','Better-qualified calls',2),
('customer_effort','Customer effort',32,'-','%','No repetition',3),
('advisor_productivity','Advisor productivity',26,'+','%','More valuable calls',4),
('qualification_speed','Qualification speed',2.4,'','x','Faster triage',5),
('scalability','Scalability',22,'+','%','No added ops cost',6)
on conflict (metric_key) do update set
  label = excluded.label,
  metric_value = excluded.metric_value,
  value_prefix = excluded.value_prefix,
  value_suffix = excluded.value_suffix,
  detail = excluded.detail,
  sort_order = excluded.sort_order,
  updated_at = now();

insert into public.business_impact_benchmarks (
  chart_key,
  label,
  before_value,
  after_value,
  value_suffix,
  sort_order
) values
('conversion','Conversion uplift',54,72,'%',1),
('call_time','Average call minutes',88,52,'min',2),
('funnel','Qualified conversations',51,68,'%',3),
('advisor_productivity','Advisor productivity index',100,126,'',4)
on conflict (chart_key, label) do update set
  before_value = excluded.before_value,
  after_value = excluded.after_value,
  value_suffix = excluded.value_suffix,
  sort_order = excluded.sort_order;

insert into public.compliance_disclosures (
  disclosure_key,
  version,
  title,
  regulator_reference,
  required_context,
  content,
  effective_from
) values
('privacy_collection_notice','2026.07','Privacy collection notice','OAIC APP 5','before_personal_information_collection','Explains what information TALly collects, why it is collected, how it may be disclosed, and how a customer can access or correct it.','2026-07-09'),
('sensitive_health_consent','2026.07','Sensitive health information consent','Privacy Act / Australian Privacy Principles','before_health_questionnaire','Confirms customer consent before TALly captures health and lifestyle information for routing and advisor preparation.','2026-07-09'),
('general_information_warning','2026.07','General information and advice boundary','ASIC RG 175','before_ai_guidance_or_routing','Explains that digital guidance is general information only and personal advice requires licensed advisor review.','2026-07-09'),
('advisor_handoff_disclosure','2026.07','Advisor handoff disclosure pack','ASIC disclosure obligations','before_advisor_conversation','Confirms the customer profile, consent history, AI-generated summary, and outstanding questions are prepared for advisor review.','2026-07-09')
on conflict (disclosure_key, version) do update set
  title = excluded.title,
  regulator_reference = excluded.regulator_reference,
  required_context = excluded.required_context,
  content = excluded.content,
  effective_from = excluded.effective_from,
  updated_at = now();

insert into public.retention_policies (
  policy_key,
  record_category,
  retention_period,
  deletion_trigger,
  legal_basis
) values
('quote_journey_records','Digital discovery and quote journey records','7 years after last customer interaction','Retention period expiry or approved deletion request','Advice recordkeeping and complaint-handling readiness'),
('consent_records','Consent and disclosure acknowledgement records','7 years after consent is withdrawn or journey closes','Retention period expiry','Privacy and consent evidence'),
('ai_governance_records','AI routing and copilot governance records','7 years after advisor review','Retention period expiry or model-risk archive process','Explainability and auditability'),
('audit_events','Compliance audit trail events','7 years from event creation','Retention period expiry','Operational risk and compliance monitoring')
on conflict (policy_key) do update set
  record_category = excluded.record_category,
  retention_period = excluded.retention_period,
  deletion_trigger = excluded.deletion_trigger,
  legal_basis = excluded.legal_basis,
  updated_at = now();

delete from public.customer_consents
where customer_id in (
  select id from public.customer_profiles where is_demo = true
);

insert into public.customer_consents (
  customer_id,
  disclosure_key,
  disclosure_version,
  consent_status,
  capture_channel,
  evidence
)
select
  p.id,
  d.disclosure_key,
  d.version,
  'accepted',
  'digital_discovery',
  jsonb_build_object(
    'prototype', true,
    'customerCode', p.customer_code,
    'persona', p.demo_persona,
    'control', d.required_context
  )
from public.customer_profiles p
cross join public.compliance_disclosures d
where p.is_demo = true
  and d.version = '2026.07'
on conflict (customer_id, disclosure_key, disclosure_version) do update set
  consent_status = excluded.consent_status,
  capture_channel = excluded.capture_channel,
  evidence = excluded.evidence,
  updated_at = now();

delete from public.ai_governance_records
where customer_id in (
  select id from public.customer_profiles where is_demo = true
);

insert into public.ai_governance_records (
  customer_id,
  model_purpose,
  data_inputs,
  decision_output,
  explanation,
  limitations,
  confidence_score,
  human_review_required
)
select
  p.id,
  'Journey routing and advisor copilot summary',
  array['age','occupation','dependants','income','existing_cover','health_conditions','lifestyle_factors','insurance_goal']::text[],
  p.recommended_path,
  case
    when p.complexity_score < 40 then 'Low complexity profile can continue digitally with standard checks.'
    when p.complexity_score < 72 then 'Moderate complexity profile benefits from advisor review because cover gaps or dependants are present.'
    else 'High complexity profile requires advisor consultation because health, lifestyle, or coverage complexity may affect suitability.'
  end,
  'AI outputs do not provide personal financial product advice. A licensed advisor must review customer circumstances before recommendations.',
  least(96, case when p.complexity_score < 40 then 92 when p.complexity_score < 72 then 87 else 83 end + round((100 - p.complexity_score) / 20.0)::int),
  true
from public.customer_profiles p
where p.is_demo = true;

insert into public.advisor_compliance_reviews (
  customer_id,
  advice_boundary,
  fsg_required,
  fsg_provided,
  privacy_notice_provided,
  sensitive_data_consent_verified,
  replacement_cover_review_required,
  vulnerable_customer_flag,
  soa_required,
  status,
  review_notes
)
select
  p.id,
  'general_information_until_advisor_review',
  true,
  false,
  true,
  true,
  p.existing_cover not ilike 'No existing cover',
  p.complexity_score >= 72,
  p.recommended_path <> 'Continue digitally',
  case when p.complexity_score < 40 then 'ready_for_review' else 'pending' end,
  case
    when p.complexity_score >= 72 then 'Complex profile: advisor must verify health disclosures, replacement-cover implications, and customer understanding.'
    when p.complexity_score >= 40 then 'Moderate profile: advisor should confirm cover gaps and affordability before recommendation.'
    else 'Simple profile: confirm assumptions and keep guidance within licensed advice process.'
  end
from public.customer_profiles p
where p.is_demo = true
on conflict (customer_id) do update set
  advice_boundary = excluded.advice_boundary,
  fsg_required = excluded.fsg_required,
  fsg_provided = excluded.fsg_provided,
  privacy_notice_provided = excluded.privacy_notice_provided,
  sensitive_data_consent_verified = excluded.sensitive_data_consent_verified,
  replacement_cover_review_required = excluded.replacement_cover_review_required,
  vulnerable_customer_flag = excluded.vulnerable_customer_flag,
  soa_required = excluded.soa_required,
  status = excluded.status,
  review_notes = excluded.review_notes,
  updated_at = now();

delete from public.compliance_audit_events
where customer_id in (
  select id from public.customer_profiles where is_demo = true
);

insert into public.compliance_audit_events (
  customer_id,
  actor_type,
  event_type,
  event_summary,
  risk_level,
  metadata
)
select p.id, 'customer', 'privacy_notice_displayed', 'APP 5 collection notice displayed before discovery.', 'low', jsonb_build_object('customerCode', p.customer_code)
from public.customer_profiles p
where p.is_demo = true
union all
select p.id, 'customer', 'sensitive_health_consent_accepted', 'Sensitive health information consent accepted.', 'medium', jsonb_build_object('customerCode', p.customer_code)
from public.customer_profiles p
where p.is_demo = true
union all
select p.id, 'ai_triage', 'journey_route_generated', 'Explainable route generated with confidence and reasons.', case when p.complexity_score >= 72 then 'high' when p.complexity_score >= 40 then 'medium' else 'low' end, jsonb_build_object('recommendedPath', p.recommended_path, 'complexityScore', p.complexity_score)
from public.customer_profiles p
where p.is_demo = true
union all
select p.id, 'compliance', 'advisor_review_gate_applied', 'Advisor review gate applied before any personal advice recommendation.', case when p.complexity_score >= 72 then 'high' else 'medium' end, jsonb_build_object('soaRequired', p.recommended_path <> 'Continue digitally')
from public.customer_profiles p
where p.is_demo = true;
