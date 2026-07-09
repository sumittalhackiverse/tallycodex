import type { CustomerProfile, RecommendedPath } from "../types";

export type DatabaseComplexityBand = "simple" | "moderate" | "complex";
export type DatabaseRouteCode = "Route A" | "Route B" | "Route C";
export type JourneyStage = "About You" | "Goals" | "Cover" | "Health" | "Review" | "Completed";
export type JourneyStatus = "in_progress" | "saved" | "completed" | "abandoned";

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
