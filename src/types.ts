export type ComplexityBand = "simple" | "moderate" | "complex";

export type RecommendedPath =
  | "Continue digitally"
  | "Advisor review recommended"
  | "Advisor consultation required";

export interface CustomerProfile {
  id: string;
  firstName: string;
  lastName: string;
  age: number;
  occupation: string;
  maritalStatus: string;
  dependants: number;
  annualIncome: number;
  existingCover: string;
  healthConditions: string[];
  lifestyleFactors: string[];
  insuranceGoal: string;
  complexityScore: number;
  recommendedPath: RecommendedPath;
  demoPersona?: "Young Professional" | "Family with Children" | "Complex Health Profile";
  presenterDescription?: string;
}

export interface AiOutputs {
  summary: string;
  riskConsiderations: string[];
  missingInformation: string[];
  nextQuestions: string[];
  productOptions: string[];
  salesOpportunities: string[];
  coaching: string;
  callNotes: string;
  followUps: string[];
}
