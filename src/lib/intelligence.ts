import type { AiOutputs, ComplexityBand, CustomerProfile } from "../types";

export const currency = (value: number) =>
  new Intl.NumberFormat("en-AU", {
    style: "currency",
    currency: "AUD",
    maximumFractionDigits: 0
  }).format(value);

export const getComplexityBand = (score: number): ComplexityBand => {
  if (score < 40) return "simple";
  if (score < 72) return "moderate";
  return "complex";
};

export const getRoute = (profile: CustomerProfile) => {
  const band = getComplexityBand(profile.complexityScore);
  const base = {
    simple: {
      code: "Route A",
      title: "Low complexity",
      path: "Continue digitally",
      tone: "green",
      confidence: 92,
      next: ["Continue online", "Confirm cover amount", "Fast-track application"],
      reasons: ["No major health disclosures", "Simple cover need", "Low missing-information risk"]
    },
    moderate: {
      code: "Route B",
      title: "Medium complexity",
      path: "Advisor review recommended",
      tone: "amber",
      confidence: 87,
      next: ["Schedule advisor call", "Pre-fill recommendation notes", "Fast-track review"],
      reasons: ["Dependants or debt protection need", "Coverage gap identified", "Advisor can improve fit"]
    },
    complex: {
      code: "Route C",
      title: "High complexity",
      path: "Advisor consultation required",
      tone: "red",
      confidence: 83,
      next: ["Advisor consultation", "Clarify underwriting details", "Prepare tailored advice"],
      reasons: ["Health or lifestyle disclosures", "Coverage and ownership complexity", "Specialist advice required"]
    }
  }[band];

  const healthReason =
    profile.healthConditions[0] === "None disclosed"
      ? "No disclosed medical conditions require follow-up."
      : `Health follow-up: ${profile.healthConditions.join(", ")}.`;

  return {
    ...base,
    confidence: Math.min(96, base.confidence + Math.round((100 - profile.complexityScore) / 20)),
    reasons: [healthReason, ...base.reasons]
  };
};

export const getAiOutputs = (profile: CustomerProfile): AiOutputs => {
  const band = getComplexityBand(profile.complexityScore);
  const hasDependants = profile.dependants > 0;
  const hasHealth = profile.healthConditions[0] !== "None disclosed";
  const hasExisting = !profile.existingCover.toLowerCase().includes("no existing");

  const dependantText = hasDependants
    ? `${profile.dependants} dependant${profile.dependants === 1 ? "" : "s"}`
    : "no dependants";

  const products = [
    hasDependants ? "Life cover sized to family and debt needs" : "Starter life cover with flexible increases",
    "Income protection with benefit-period options",
    hasHealth ? "Underwriting pre-check before formal application" : "TPD and trauma consideration as optional layers"
  ];

  return {
    summary: `${profile.firstName} is a ${profile.age}-year-old ${profile.occupation.toLowerCase()} with ${dependantText}, seeking ${profile.insuranceGoal.toLowerCase()}. The journey is currently ${band} complexity and the recommended path is ${profile.recommendedPath.toLowerCase()}.`,
    riskConsiderations: [
      hasHealth
        ? `Clarify disclosed health items: ${profile.healthConditions.join(", ")}.`
        : "No disclosed health conditions, so underwriting friction appears low.",
      profile.lifestyleFactors.some((item) => /smoker|manual|travel|hazard|motor|remote|aviation|climbing/i.test(item))
        ? `Lifestyle factor to confirm: ${profile.lifestyleFactors.join(", ")}.`
        : `Lifestyle profile appears straightforward: ${profile.lifestyleFactors.join(", ")}.`,
      hasDependants ? "Dependants increase the need for clear sum-insured reasoning." : "Cover need can likely be explained with simple income continuity framing."
    ],
    missingInformation: [
      hasExisting ? "Confirm benefit amounts and ownership of existing cover." : "Confirm whether any cover exists outside super.",
      hasDependants ? "Confirm mortgage balance and education-cost expectations." : "Confirm monthly expenses and savings buffer.",
      hasHealth ? "Confirm dates, medication, follow-up, and current stability." : "Confirm no recent investigations or pending tests."
    ],
    nextQuestions: [
      "What outcome would make this cover feel worth it for you?",
      hasDependants ? "If income stopped for six months, what would your family need protected first?" : "How many months of income would you want protected while you recover?",
      hasExisting ? "Would you like us to compare existing cover before recommending changes?" : "Would you prefer a lean starter option or broader protection?"
    ],
    productOptions: products,
    salesOpportunities: [
      hasDependants ? "TPD discussion is timely because family protection is the stated goal." : "Income protection is a natural first product based on age and goal.",
      profile.annualIncome > 150000 ? "Higher income creates room to discuss benefit caps and quality of cover." : "Lead with affordability and flexible staging.",
      band === "complex" ? "Use consultation to turn uncertainty into trust and reduce drop-off." : "Use digital completion to shorten the call and maintain momentum."
    ],
    coaching:
      band === "simple"
        ? "Keep the conversation short and confidence-building. Confirm assumptions, explain value, and help the customer finish online."
        : band === "moderate"
          ? "Lead with family outcomes, avoid jargon, and use the pre-filled facts to spend the call on trade-offs rather than data collection."
          : "Acknowledge complexity early. Explain that the advisor is here to reduce uncertainty, not add paperwork.",
    callNotes: `Customer intent: ${profile.insuranceGoal}. Current profile: ${profile.age}, ${profile.occupation}, ${profile.maritalStatus}, ${dependantText}. Existing cover: ${profile.existingCover}. Complexity score ${profile.complexityScore}/100. Recommended next step: ${profile.recommendedPath}.`,
    followUps: [
      "Send customer summary link",
      "Attach comparison of current and recommended cover",
      band === "complex" ? "Book underwriting clarification call" : "Confirm preferred cover level"
    ]
  };
};
