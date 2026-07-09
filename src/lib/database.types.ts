import type { CustomerProfile, RecommendedPath } from "../types";

export type DatabaseComplexityBand = "simple" | "moderate" | "complex";
export type DatabaseRouteCode = "Route A" | "Route B" | "Route C";
export type JourneyStage = "About You" | "Goals" | "Cover" | "Health" | "Review" | "Completed";
export type JourneyStatus = "in_progress" | "saved" | "completed" | "abandoned";
export type ConsentStatus = "accepted" | "declined" | "withdrawn";
export type ComplianceRiskLevel = "low" | "medium" | "high";

export interface CustomerProfileViewRow {
  id: string;
  customer_code: string;
  first_name: string;
  last_name: string;
  age: number;
  occupation: string;
  marital_status: string;
  dependants: number;
  annual_income: number;
  existing_cover: string;
  insurance_goal: string;
  complexity_score: number;
  recommended_path: RecommendedPath;
  demo_persona: CustomerProfile["demoPersona"] | null;
  presenter_description: string | null;
  is_demo: boolean;
  health_conditions: string[];
  lifestyle_factors: string[];
  created_at: string;
  updated_at: string;
}

export interface AdvisorDashboardViewRow extends CustomerProfileViewRow {
  route_code: DatabaseRouteCode | null;
  complexity_band: DatabaseComplexityBand | null;
  confidence_score: number | null;
  decision_reasons: string[] | null;
  next_steps: string[] | null;
  customer_summary: string | null;
  risk_considerations: string[] | null;
  missing_information: string[] | null;
  recommended_next_questions: string[] | null;
  suggested_products: string[] | null;
  sales_opportunities: string[] | null;
  advisor_coaching: string | null;
  conversation_notes: string | null;
  follow_up_actions: string[] | null;
}

export interface BusinessImpactMetricRow {
  metric_key: string;
  label: string;
  metric_value: number;
  value_prefix: string;
  value_suffix: string;
  detail: string;
  sort_order: number;
}

export interface ComplianceDisclosureRow {
  disclosure_key: string;
  version: string;
  title: string;
  regulator_reference: string;
  required_context: string;
  content: string;
  effective_from: string;
  retired_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface CustomerConsentRow {
  id: string;
  customer_id: string;
  disclosure_key: string;
  disclosure_version: string;
  consent_status: ConsentStatus;
  capture_channel: string;
  consented_at: string;
  withdrawn_at: string | null;
  evidence: Record<string, unknown>;
  created_at: string;
  updated_at: string;
}

export interface ComplianceAuditEventRow {
  id: string;
  customer_id: string | null;
  actor_user_id: string | null;
  actor_type: "customer" | "advisor" | "system" | "ai_triage" | "compliance";
  event_type: string;
  event_summary: string;
  risk_level: ComplianceRiskLevel;
  metadata: Record<string, unknown>;
  created_at: string;
}

export interface AiGovernanceRecordRow {
  id: string;
  customer_id: string;
  model_purpose: string;
  data_inputs: string[];
  decision_output: string;
  explanation: string;
  limitations: string;
  confidence_score: number | null;
  human_review_required: boolean;
  reviewed_by: string | null;
  reviewed_at: string | null;
  generated_at: string;
  created_at: string;
}

export interface AdvisorComplianceReviewRow {
  id: string;
  customer_id: string;
  advisor_user_id: string | null;
  advice_boundary: string;
  fsg_required: boolean;
  fsg_provided: boolean;
  privacy_notice_provided: boolean;
  sensitive_data_consent_verified: boolean;
  replacement_cover_review_required: boolean;
  vulnerable_customer_flag: boolean;
  soa_required: boolean;
  status: "pending" | "ready_for_review" | "reviewed" | "blocked";
  review_notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface PrivacyRequestRow {
  id: string;
  customer_id: string | null;
  request_type: "access" | "correction" | "withdraw_consent" | "delete" | "export" | "complaint";
  status: "received" | "in_review" | "completed" | "declined";
  request_summary: string;
  response_due_at: string | null;
  completed_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface RetentionPolicyRow {
  policy_key: string;
  record_category: string;
  retention_period: string;
  deletion_trigger: string;
  legal_basis: string;
  created_at: string;
  updated_at: string;
}

export interface ComplianceCustomerSummaryViewRow {
  customer_id: string;
  customer_code: string;
  first_name: string;
  last_name: string;
  recommended_path: RecommendedPath;
  complexity_score: number;
  accepted_consent_count: number;
  ai_reviews_required: number;
  advisor_review_status: "pending" | "ready_for_review" | "reviewed" | "blocked" | null;
  fsg_provided: boolean | null;
  privacy_notice_provided: boolean | null;
  sensitive_data_consent_verified: boolean | null;
  replacement_cover_review_required: boolean | null;
  vulnerable_customer_flag: boolean | null;
  soa_required: boolean | null;
}

export type Database = {
  public: {
    Tables: {
      customer_profiles: {
        Row: Omit<CustomerProfileViewRow, "health_conditions" | "lifestyle_factors"> & {
          owner_user_id: string | null;
          advisor_user_id: string | null;
        };
        Insert: Partial<Omit<CustomerProfileViewRow, "health_conditions" | "lifestyle_factors" | "created_at" | "updated_at">>;
        Update: Partial<Omit<CustomerProfileViewRow, "health_conditions" | "lifestyle_factors" | "created_at" | "updated_at">>;
        Relationships: [];
      };
      business_impact_metrics: {
        Row: BusinessImpactMetricRow;
        Insert: BusinessImpactMetricRow;
        Update: Partial<BusinessImpactMetricRow>;
        Relationships: [];
      };
      compliance_disclosures: {
        Row: ComplianceDisclosureRow;
        Insert: Omit<ComplianceDisclosureRow, "created_at" | "updated_at">;
        Update: Partial<Omit<ComplianceDisclosureRow, "created_at" | "updated_at">>;
        Relationships: [];
      };
      customer_consents: {
        Row: CustomerConsentRow;
        Insert: Partial<Omit<CustomerConsentRow, "id" | "created_at" | "updated_at">> & Pick<CustomerConsentRow, "customer_id" | "disclosure_key" | "disclosure_version" | "consent_status">;
        Update: Partial<Omit<CustomerConsentRow, "id" | "created_at" | "updated_at">>;
        Relationships: [];
      };
      compliance_audit_events: {
        Row: ComplianceAuditEventRow;
        Insert: Partial<Omit<ComplianceAuditEventRow, "id" | "created_at">> & Pick<ComplianceAuditEventRow, "actor_type" | "event_type" | "event_summary">;
        Update: never;
        Relationships: [];
      };
      ai_governance_records: {
        Row: AiGovernanceRecordRow;
        Insert: Partial<Omit<AiGovernanceRecordRow, "id" | "created_at" | "generated_at">> & Pick<AiGovernanceRecordRow, "customer_id" | "model_purpose" | "decision_output" | "explanation" | "limitations">;
        Update: Partial<Omit<AiGovernanceRecordRow, "id" | "created_at" | "generated_at">>;
        Relationships: [];
      };
      advisor_compliance_reviews: {
        Row: AdvisorComplianceReviewRow;
        Insert: Partial<Omit<AdvisorComplianceReviewRow, "id" | "created_at" | "updated_at">> & Pick<AdvisorComplianceReviewRow, "customer_id">;
        Update: Partial<Omit<AdvisorComplianceReviewRow, "id" | "created_at" | "updated_at">>;
        Relationships: [];
      };
      privacy_requests: {
        Row: PrivacyRequestRow;
        Insert: Partial<Omit<PrivacyRequestRow, "id" | "created_at" | "updated_at">> & Pick<PrivacyRequestRow, "request_type" | "request_summary">;
        Update: Partial<Omit<PrivacyRequestRow, "id" | "created_at" | "updated_at">>;
        Relationships: [];
      };
      retention_policies: {
        Row: RetentionPolicyRow;
        Insert: Omit<RetentionPolicyRow, "created_at" | "updated_at">;
        Update: Partial<Omit<RetentionPolicyRow, "created_at" | "updated_at">>;
        Relationships: [];
      };
    };
    Views: {
      customer_profile_view: {
        Row: CustomerProfileViewRow;
        Relationships: [];
      };
      advisor_dashboard_view: {
        Row: AdvisorDashboardViewRow;
        Relationships: [];
      };
      compliance_customer_summary_view: {
        Row: ComplianceCustomerSummaryViewRow;
        Relationships: [];
      };
    };
    Functions: Record<string, never>;
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
};

export const mapCustomerProfileRow = (row: CustomerProfileViewRow): CustomerProfile => ({
  id: row.customer_code,
  firstName: row.first_name,
  lastName: row.last_name,
  age: row.age,
  occupation: row.occupation,
  maritalStatus: row.marital_status,
  dependants: row.dependants,
  annualIncome: Number(row.annual_income),
  existingCover: row.existing_cover,
  healthConditions: row.health_conditions,
  lifestyleFactors: row.lifestyle_factors,
  insuranceGoal: row.insurance_goal,
  complexityScore: row.complexity_score,
  recommendedPath: row.recommended_path,
  demoPersona: row.demo_persona ?? undefined,
  presenterDescription: row.presenter_description ?? undefined
});
