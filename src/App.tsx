import { useMemo, useState, type CSSProperties } from "react";
import { Header } from "./components/Header";
import { Icon } from "./components/Icon";
import { Button, Card, Metric, Section } from "./components/Primitives";
import { customerProfiles, demoProfileIds } from "./data/profiles";
import { currency, getAiOutputs, getComplexityBand, getRoute } from "./lib/intelligence";

const stages = ["About You", "Goals", "Cover", "Health", "Review"] as const;

const scrollTo = (id: string) => document.getElementById(id)?.scrollIntoView({ behavior: "smooth", block: "start" });

function Hero({ onStart, onDemo }: { onStart: () => void; onDemo: () => void }) {
  return (
    <Section id="welcome" className="grid min-h-[calc(100vh-150px)] items-center gap-10 lg:grid-cols-[0.9fr_1.1fr]">
      <div className="animate-rise">
        <h1 className="max-w-2xl text-5xl font-semibold leading-[1.03] text-charcoal md:text-6xl xl:text-7xl">Get protected faster with less paperwork</h1>
        <p className="mt-6 max-w-xl text-xl leading-8 text-charcoal/72">Start your insurance journey in minutes, not hours</p>
        <div className="mt-8 grid gap-3 text-base text-charcoal/78 sm:grid-cols-3">
          {["Save time before the call", "No repeating information", "Smarter advisor conversations"].map((item) => (
            <div key={item} className="flex items-center gap-3 rounded-lg border border-charcoal/10 bg-paper p-3 shadow-panel">
              <span className="grid h-8 w-8 shrink-0 place-items-center rounded-lg bg-sage-50 text-sage-700">
                <Icon name="check" className="h-4 w-4" />
              </span>
              <span className="font-medium">{item}</span>
            </div>
          ))}
        </div>
        <div className="mt-9 flex flex-wrap gap-3">
          <Button onClick={onStart}>
            Start Journey <Icon name="arrow" />
          </Button>
          <Button variant="secondary" onClick={onStart}>
            Resume Journey <Icon name="save" />
          </Button>
          <Button variant="quiet" onClick={onDemo}>
            Try Demo Mode <Icon name="spark" />
          </Button>
        </div>
        <div className="mt-10 grid gap-4 sm:grid-cols-3">
          {[
            ["1", "Tell us about you", "Online discovery replaces repetitive call intake."],
            ["2", "Get guided", "Plain-English AI guidance keeps momentum high."],
            ["3", "Speak smarter with your advisor", "Advisors start with context, not admin."]
          ].map(([step, title, body]) => (
            <div key={step} className="rounded-lg border border-charcoal/10 bg-sage-50 p-4">
              <div className="mb-4 grid h-9 w-9 place-items-center rounded-lg bg-sage-900 font-bold text-cream">{step}</div>
              <h3 className="font-semibold text-charcoal">{title}</h3>
              <p className="mt-2 text-sm leading-6 text-charcoal/65">{body}</p>
            </div>
          ))}
        </div>
      </div>
      <div className="animate-fade rounded-lg border border-charcoal/10 bg-paper p-3 shadow-soft">
        <img src="/images/tally-hero-ai-journey.png" alt="AI assisted insurance journey with advisor support" className="aspect-[16/10] w-full rounded-lg object-cover" />
        <div className="mt-3 grid gap-3 md:grid-cols-3">
          <MiniProof icon="clock" label="10-15 min" body="Customer-guided discovery" />
          <MiniProof icon="spark" label="AI guided" body="Support without replacing humans" />
          <MiniProof icon="briefcase" label="Advisor ready" body="Summary before the call" />
        </div>
      </div>
    </Section>
  );
}

function MiniProof({ icon, label, body }: { icon: "clock" | "spark" | "briefcase"; label: string; body: string }) {
  return (
    <div className="rounded-lg bg-cream p-4">
      <Icon name={icon} className="h-5 w-5 text-sage-700" />
      <p className="mt-3 font-semibold text-charcoal">{label}</p>
      <p className="mt-1 text-sm text-charcoal/62">{body}</p>
    </div>
  );
}

function Discovery({ profile, stage, setStage }: { profile: (typeof customerProfiles)[number]; stage: number; setStage: (stage: number) => void }) {
  const ai = getAiOutputs(profile);
  const progress = ((stage + 1) / stages.length) * 100;

  return (
    <Section id="discovery" className="space-y-6">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h2 className="text-4xl font-semibold text-charcoal">Digital discovery that feels guided, not heavy</h2>
          <p className="mt-3 max-w-3xl text-lg text-charcoal/68">Customers complete key information online, save and resume any time, and arrive at the advisor conversation with less repetition.</p>
        </div>
        <div className="flex items-center gap-2 rounded-lg border border-charcoal/10 bg-paper p-2 shadow-panel">
          <span className="rounded-lg bg-sage-50 px-3 py-2 text-sm font-semibold text-sage-900">Auto-saved 18 sec ago</span>
          <Button variant="secondary" className="py-2">
            Save & Resume
          </Button>
        </div>
      </div>

      <Card className="overflow-hidden">
        <div className="border-b border-charcoal/10 bg-cream p-5">
          <div className="h-2 rounded-full bg-sage-100">
            <div className="h-full rounded-full bg-sage-700 transition-all duration-500" style={{ width: `${progress}%` }} />
          </div>
          <div className="mt-4 grid gap-2 md:grid-cols-5">
            {stages.map((label, index) => (
              <button
                key={label}
                type="button"
                onClick={() => setStage(index)}
                className={`rounded-lg px-3 py-3 text-left text-sm font-semibold transition ${
                  stage === index ? "bg-sage-900 text-cream" : index < stage ? "bg-sage-50 text-sage-900" : "bg-paper text-charcoal/58"
                }`}
              >
                {label}
              </button>
            ))}
          </div>
        </div>

        <div className="grid gap-6 p-5 lg:grid-cols-[1fr_360px]">
          <div className="min-h-[460px] rounded-lg border border-charcoal/10 bg-white p-5">
            <StageContent profile={profile} stage={stage} />
            <div className="mt-8 flex justify-between">
              <Button variant="secondary" onClick={() => setStage(Math.max(0, stage - 1))}>
                Back
              </Button>
              <Button onClick={() => (stage === stages.length - 1 ? scrollTo("routing") : setStage(Math.min(stages.length - 1, stage + 1)))}>
                {stage === stages.length - 1 ? "See Routing" : "Continue"}
                <Icon name="arrow" />
              </Button>
            </div>
          </div>

          <aside className="rounded-lg bg-sage-900 p-5 text-cream shadow-soft">
            <div className="flex items-center gap-3">
              <span className="grid h-10 w-10 place-items-center rounded-lg bg-cream/12">
                <Icon name="spark" />
              </span>
              <div>
                <h3 className="font-semibold">AI Assistant</h3>
                <p className="text-sm text-cream/68">Plain-English guidance</p>
              </div>
            </div>
            <div className="mt-6 space-y-3">
              <AssistantBubble title="Why we ask this" body={stage === 0 ? "Age, income, and family status help estimate appropriate cover without making you repeat these basics on a call." : stage === 3 ? "Health and lifestyle answers help route you to the right support early, before underwriting slows things down." : "Your answers help match the journey to your needs and keep advisor time focused on advice."} />
              <AssistantBubble title="Reassurance" body="This usually takes 10-15 minutes. You can save and resume any time, and an advisor only steps in when it adds value." />
              <AssistantBubble title="For your advisor" body={ai.summary} />
            </div>
          </aside>
        </div>
      </Card>
    </Section>
  );
}

function AssistantBubble({ title, body }: { title: string; body: string }) {
  return (
    <div className="rounded-lg bg-cream/10 p-4">
      <p className="text-sm font-semibold text-cream">{title}</p>
      <p className="mt-2 text-sm leading-6 text-cream/75">{body}</p>
    </div>
  );
}

function Field({ label, value, helper }: { label: string; value: string; helper?: string }) {
  return (
    <label className="block">
      <span className="text-sm font-semibold text-charcoal/72">{label}</span>
      <span className="mt-2 block rounded-lg border border-charcoal/12 bg-cream px-4 py-3 text-charcoal">{value}</span>
      {helper && <span className="mt-2 block text-sm leading-6 text-charcoal/58">{helper}</span>}
    </label>
  );
}

function StageContent({ profile, stage }: { profile: (typeof customerProfiles)[number]; stage: number }) {
  if (stage === 0) {
    return (
      <div>
        <SectionTitle icon="user" title="About You" body="A few basics replace the repetitive first 20 minutes of a traditional quote call." />
        <div className="mt-6 grid gap-4 md:grid-cols-2">
          <Field label="Age" value={String(profile.age)} />
          <Field label="Occupation" value={profile.occupation} />
          <Field label="Family status" value={profile.maritalStatus} />
          {profile.dependants > 0 && <Field label="Dependants" value={String(profile.dependants)} helper="Shown because family protection needs can change cover amounts." />}
          <Field label="Annual income" value={currency(profile.annualIncome)} />
        </div>
      </div>
    );
  }
  if (stage === 1) {
    return (
      <div>
        <SectionTitle icon="heart" title="Goals" body="Customers describe outcomes in plain English before product details." />
        <div className="mt-6 grid gap-4">
          <Field label="Insurance goal" value={profile.insuranceGoal} helper="Why we ask this: goals help route simple requests digitally and reserve advisor time for higher-value advice." />
          <div className="grid gap-3 md:grid-cols-3">
            {["Protect income", "Protect family", "Review existing cover"].map((goal) => (
              <div key={goal} className={`rounded-lg border p-4 ${profile.insuranceGoal.toLowerCase().includes(goal.split(" ")[1].toLowerCase()) ? "border-sage-700 bg-sage-50" : "border-charcoal/10 bg-white"}`}>
                <Icon name="shield" className="h-5 w-5 text-sage-700" />
                <p className="mt-3 font-semibold text-charcoal">{goal}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  }
  if (stage === 2) {
    return (
      <div>
        <SectionTitle icon="shield" title="Cover" body="Existing cover is captured once, then reused by routing and advisor copilot." />
        <div className="mt-6 grid gap-4 md:grid-cols-2">
          <Field label="Existing cover" value={profile.existingCover} />
          <Field label="Preferred support" value={profile.recommendedPath} helper="Conditional routing updates as the profile changes." />
        </div>
      </div>
    );
  }
  if (stage === 3) {
    return (
      <div>
        <SectionTitle icon="heart" title="Health and Lifestyle" body="Sensitive questions are explained clearly so customers understand the purpose." />
        <div className="mt-6 grid gap-4 md:grid-cols-2">
          <Field label="Health questionnaire" value={profile.healthConditions.join(", ")} helper="Why we ask this: health answers help identify whether an advisor should prepare underwriting follow-up." />
          <Field label="Lifestyle factors" value={profile.lifestyleFactors.join(", ")} />
        </div>
      </div>
    );
  }
  return (
    <div>
      <SectionTitle icon="check" title="Review" body="The customer can review the pre-call summary before it is shared with an advisor." />
      <div className="mt-6 grid gap-4 md:grid-cols-2">
        {[
          ["Customer", `${profile.firstName} ${profile.lastName}`],
          ["Goal", profile.insuranceGoal],
          ["Existing cover", profile.existingCover],
          ["Recommended path", profile.recommendedPath]
        ].map(([label, value]) => (
          <div key={label} className="rounded-lg border border-charcoal/10 bg-cream p-4">
            <p className="text-sm font-semibold text-charcoal/55">{label}</p>
            <p className="mt-2 font-semibold text-charcoal">{value}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

function SectionTitle({ icon, title, body }: { icon: "user" | "heart" | "shield" | "check"; title: string; body: string }) {
  return (
    <div className="flex gap-4">
      <span className="grid h-11 w-11 shrink-0 place-items-center rounded-lg bg-sage-50 text-sage-700">
        <Icon name={icon} />
      </span>
      <div>
        <h3 className="text-2xl font-semibold text-charcoal">{title}</h3>
        <p className="mt-2 max-w-2xl text-charcoal/65">{body}</p>
      </div>
    </div>
  );
}

function Routing({ profile }: { profile: (typeof customerProfiles)[number] }) {
  const route = getRoute(profile);
  const tone = route.tone === "green" ? "bg-sage-700" : route.tone === "amber" ? "bg-amber" : "bg-routeRed";
  return (
    <Section id="routing">
      <div className="mb-8">
        <h2 className="text-4xl font-semibold text-charcoal">Journey intelligence makes routing explainable</h2>
        <p className="mt-3 max-w-3xl text-lg text-charcoal/68">AI triage is transparent: customers see what happens next, while advisors receive a clear reason for intervention.</p>
      </div>
      <div className="grid gap-6 lg:grid-cols-[0.95fr_1.05fr]">
        <Card className="overflow-hidden">
          <div className={`${tone} p-6 text-white`}>
            <p className="text-sm font-semibold uppercase tracking-[0.10em]">{route.code}</p>
            <h3 className="mt-3 text-4xl font-semibold">{route.title}</h3>
            <p className="mt-3 text-lg opacity-90">{route.path}</p>
          </div>
          <div className="grid gap-5 p-6 md:grid-cols-2">
            <div>
              <p className="text-sm font-semibold text-charcoal/55">Confidence score</p>
              <div className="mt-4 flex items-center gap-4">
                <div className="route-gauge" style={{ "--score": `${route.confidence}%` } as CSSProperties}>
                  <span>{route.confidence}%</span>
                </div>
                <p className="text-sm leading-6 text-charcoal/65">Model confidence based on completion, health signals, cover complexity, and missing information.</p>
              </div>
            </div>
            <div>
              <p className="text-sm font-semibold text-charcoal/55">Recommended path</p>
              <p className="mt-4 text-2xl font-semibold text-charcoal">{profile.recommendedPath}</p>
              <p className="mt-2 text-sm leading-6 text-charcoal/65">The advisor is introduced only when the conversation can create material value.</p>
            </div>
          </div>
        </Card>

        <div className="grid gap-6">
          <Card className="p-6">
            <h3 className="text-xl font-semibold text-charcoal">Why this decision was made</h3>
            <div className="mt-5 grid gap-3">
              {route.reasons.map((reason) => (
                <div key={reason} className="flex gap-3 rounded-lg bg-cream p-4 text-charcoal/75">
                  <Icon name="check" className="h-5 w-5 shrink-0 text-sage-700" />
                  <span>{reason}</span>
                </div>
              ))}
            </div>
          </Card>
          <Card className="p-6">
            <h3 className="text-xl font-semibold text-charcoal">What happens next</h3>
            <div className="mt-5 grid gap-3 md:grid-cols-3">
              {route.next.map((item, index) => (
                <div key={item} className="rounded-lg border border-charcoal/10 bg-sage-50 p-4">
                  <span className="grid h-8 w-8 place-items-center rounded-lg bg-paper text-sm font-bold text-sage-700">{index + 1}</span>
                  <p className="mt-4 font-semibold text-charcoal">{item}</p>
                </div>
              ))}
            </div>
          </Card>
        </div>
      </div>
    </Section>
  );
}

function AdvisorDashboard({ profile }: { profile: (typeof customerProfiles)[number] }) {
  const ai = getAiOutputs(profile);
  const band = getComplexityBand(profile.complexityScore);
  return (
    <Section id="advisor" className="max-w-[1500px]">
      <div className="mb-8 flex flex-wrap items-end justify-between gap-4">
        <div>
          <h2 className="text-4xl font-semibold text-charcoal">Advisor Copilot workspace</h2>
          <p className="mt-3 max-w-3xl text-lg text-charcoal/68">The standout value: advisors start with a pre-qualified profile, AI summary, next-best questions, and less admin.</p>
        </div>
        <span className="rounded-lg bg-sage-900 px-4 py-3 text-sm font-semibold text-cream">Advisor time shifted to value-added conversations</span>
      </div>

      <div className="grid gap-6 xl:grid-cols-[320px_1fr_390px]">
        <Card className="p-5">
          <div className="flex items-center gap-4">
            <div className="grid h-14 w-14 place-items-center rounded-lg bg-sage-900 text-xl font-bold text-cream">{profile.firstName[0]}{profile.lastName[0]}</div>
            <div>
              <h3 className="text-2xl font-semibold text-charcoal">{profile.firstName} {profile.lastName}</h3>
              <p className="text-sm text-charcoal/60">{profile.id}</p>
            </div>
          </div>
          <div className="mt-6 grid gap-3">
            {[
              ["Age", String(profile.age)],
              ["Occupation", profile.occupation],
              ["Family", `${profile.maritalStatus}, ${profile.dependants} dependant${profile.dependants === 1 ? "" : "s"}`],
              ["Goal", profile.insuranceGoal],
              ["Income", currency(profile.annualIncome)]
            ].map(([label, value]) => (
              <div key={label} className="rounded-lg bg-cream p-3">
                <p className="text-xs font-semibold uppercase tracking-[0.08em] text-charcoal/50">{label}</p>
                <p className="mt-1 font-semibold text-charcoal">{value}</p>
              </div>
            ))}
          </div>
          <div className="mt-6 rounded-lg bg-sage-50 p-4">
            <p className="text-sm font-semibold text-sage-900">Intent summary</p>
            <p className="mt-2 text-sm leading-6 text-charcoal/68">{ai.summary}</p>
          </div>
          <div className="mt-6">
            <p className="text-sm font-semibold text-charcoal/55">Complexity score</p>
            <div className="mt-2 h-3 rounded-full bg-sage-100">
              <div className="h-full rounded-full bg-orange-500" style={{ width: `${profile.complexityScore}%` }} />
            </div>
            <p className="mt-2 text-sm font-semibold capitalize text-charcoal">{profile.complexityScore}/100 - {band}</p>
          </div>
        </Card>

        <div className="grid gap-6">
          <Card className="p-5">
            <h3 className="text-xl font-semibold text-charcoal">Risk insights</h3>
            <div className="mt-5 grid gap-4 md:grid-cols-3">
              {ai.riskConsiderations.map((item, index) => (
                <div key={item} className="rounded-lg border border-charcoal/10 bg-cream p-4">
                  <Icon name={index === 0 ? "heart" : index === 1 ? "briefcase" : "family"} className="h-5 w-5 text-sage-700" />
                  <p className="mt-3 text-sm leading-6 text-charcoal/72">{item}</p>
                </div>
              ))}
            </div>
          </Card>

          <div className="grid gap-6 md:grid-cols-2">
            <Card className="p-5">
              <h3 className="text-xl font-semibold text-charcoal">Missing information tracker</h3>
              <div className="mt-5 space-y-3">
                {ai.missingInformation.map((item, index) => (
                  <div key={item} className="flex gap-3 rounded-lg bg-cream p-3">
                    <span className={`mt-0.5 grid h-6 w-6 shrink-0 place-items-center rounded-full ${index === 0 ? "bg-orange-500 text-white" : "bg-sage-700 text-white"}`}>
                      <Icon name={index === 0 ? "spark" : "check"} className="h-3.5 w-3.5" />
                    </span>
                    <span className="text-sm leading-6 text-charcoal/72">{item}</span>
                  </div>
                ))}
              </div>
            </Card>
            <Card className="p-5">
              <h3 className="text-xl font-semibold text-charcoal">Next best actions</h3>
              <div className="mt-5 grid gap-3">
                {[
                  ["Ask next question", "phone"],
                  ["Recommend cover option", "shield"],
                  ["Send summary link", "send"],
                  ["Schedule callback", "calendar"]
                ].map(([label, icon]) => (
                  <button key={label} type="button" className="flex items-center justify-between rounded-lg border border-charcoal/10 bg-cream p-3 text-left font-semibold text-charcoal transition hover:border-sage-700 hover:bg-sage-50">
                    <span className="flex items-center gap-3">
                      <Icon name={icon as "phone"} className="h-5 w-5 text-sage-700" />
                      {label}
                    </span>
                    <Icon name="arrow" className="h-4 w-4" />
                  </button>
                ))}
              </div>
            </Card>
          </div>
        </div>

        <aside className="rounded-lg bg-sage-900 p-5 text-cream shadow-soft">
          <div className="flex items-center justify-between gap-4">
            <div>
              <h3 className="text-2xl font-semibold">AI Copilot</h3>
              <p className="mt-1 text-sm text-cream/65">Generated from discovery answers</p>
            </div>
            <span className="grid h-11 w-11 place-items-center rounded-lg bg-cream/12">
              <Icon name="spark" />
            </span>
          </div>
          <CopilotBlock title="Recommended questions" items={ai.nextQuestions} />
          <CopilotBlock title="Suggested cover options" items={ai.productOptions} />
          <CopilotBlock title="Sales opportunities" items={ai.salesOpportunities} />
          <div className="mt-5 rounded-lg bg-cream/10 p-4">
            <p className="text-sm font-semibold">Advisor coaching</p>
            <p className="mt-2 text-sm leading-6 text-cream/76">{ai.coaching}</p>
          </div>
        </aside>
      </div>

      <Card className="mt-6 p-5">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <h3 className="text-xl font-semibold text-charcoal">Conversation summary generator</h3>
            <p className="mt-2 max-w-4xl text-charcoal/68">{ai.callNotes}</p>
          </div>
          <Button variant="secondary">Send summary link</Button>
        </div>
        <div className="mt-5 grid gap-3 md:grid-cols-3">
          {ai.followUps.map((item) => (
            <div key={item} className="rounded-lg bg-sage-50 p-4 font-semibold text-charcoal">{item}</div>
          ))}
        </div>
      </Card>
    </Section>
  );
}

function CopilotBlock({ title, items }: { title: string; items: string[] }) {
  return (
    <div className="mt-5 rounded-lg border border-cream/12 bg-cream/8 p-4">
      <p className="text-sm font-semibold text-cream">{title}</p>
      <ul className="mt-3 space-y-3">
        {items.map((item) => (
          <li key={item} className="flex gap-3 text-sm leading-6 text-cream/75">
            <Icon name="check" className="mt-0.5 h-4 w-4 shrink-0 text-orange-400" />
            {item}
          </li>
        ))}
      </ul>
    </div>
  );
}

function BusinessImpact() {
  return (
    <Section id="impact">
      <div className="mb-8">
        <h2 className="text-4xl font-semibold text-charcoal">Same advisors, higher sales, lower effort</h2>
        <p className="mt-3 max-w-4xl text-lg text-charcoal/68">TALly enables scalable growth by shifting routine effort online, improving advisor efficiency, and preserving expert human guidance where it matters most.</p>
      </div>
      <div className="grid gap-4 md:grid-cols-3 xl:grid-cols-6">
        <Metric label="Call time reduced" value="-40%" detail="Less intake admin" />
        <Metric label="Conversion uplift" value="+18%" detail="Better-qualified calls" />
        <Metric label="Customer effort" value="-32%" detail="No repetition" />
        <Metric label="Advisor productivity" value="+26%" detail="More valuable calls" />
        <Metric label="Qualification speed" value="2.4x" detail="Faster triage" />
        <Metric label="Scalability" value="+22%" detail="No added ops cost" />
      </div>
      <div className="mt-6 grid gap-6 lg:grid-cols-[0.8fr_1.2fr]">
        <Card className="grid gap-4 p-5 md:grid-cols-2">
          <CompareList title="Before" items={["60-90 minute calls", "Repetitive questioning", "Fragmented journey", "Higher drop-off", "Higher manual effort"]} />
          <CompareList title="After" items={["Pre-filled applications", "Better triage", "Focused advisor conversations", "Lower friction", "Scalable growth without extra operational burden"]} positive />
        </Card>
        <div className="grid gap-6 md:grid-cols-3">
          <ChartCard title="Conversion uplift" bars={[54, 72]} labels={["Before", "After"]} />
          <ChartCard title="Time savings" bars={[88, 52]} labels={["Traditional", "TALly"]} inverse />
          <FunnelCard />
        </div>
      </div>
    </Section>
  );
}

function CompareList({ title, items, positive = false }: { title: string; items: string[]; positive?: boolean }) {
  return (
    <div className={`rounded-lg p-5 ${positive ? "bg-sage-50" : "bg-cream"}`}>
      <h3 className="text-xl font-semibold text-charcoal">{title}</h3>
      <ul className="mt-4 space-y-3">
        {items.map((item) => (
          <li key={item} className="flex gap-3 text-sm leading-6 text-charcoal/72">
            <Icon name="check" className={`mt-0.5 h-4 w-4 shrink-0 ${positive ? "text-sage-700" : "text-orange-500"}`} />
            {item}
          </li>
        ))}
      </ul>
    </div>
  );
}

function ChartCard({ title, bars, labels, inverse = false }: { title: string; bars: number[]; labels: string[]; inverse?: boolean }) {
  return (
    <Card className="p-5">
      <h3 className="font-semibold text-charcoal">{title}</h3>
      <div className="mt-6 flex h-48 items-end gap-5">
        {bars.map((bar, index) => (
          <div key={labels[index]} className="flex flex-1 flex-col items-center gap-3">
            <div className="flex h-36 w-full items-end rounded-lg bg-cream p-2">
              <div className={`w-full rounded-md ${inverse ? (index === 1 ? "bg-sage-700" : "bg-orange-500") : index === 1 ? "bg-orange-500" : "bg-sage-300"}`} style={{ height: `${bar}%` }} />
            </div>
            <span className="text-xs font-semibold text-charcoal/62">{labels[index]}</span>
          </div>
        ))}
      </div>
    </Card>
  );
}

function FunnelCard() {
  return (
    <Card className="p-5">
      <h3 className="font-semibold text-charcoal">Funnel improvement</h3>
      <div className="mt-8 space-y-2">
        {[100, 82, 66, 51].map((width, index) => (
          <div key={width} className="mx-auto h-8 rounded-md bg-sage-700/80" style={{ width: `${width}%`, opacity: 1 - index * 0.12 }} />
        ))}
      </div>
      <p className="mt-6 text-sm leading-6 text-charcoal/65">More customers reach qualified advisor conversations because routine discovery is completed earlier.</p>
    </Card>
  );
}

export default function App() {
  const [activeId, setActiveId] = useState(demoProfileIds[1]);
  const [demoMode, setDemoMode] = useState(true);
  const [stage, setStage] = useState(0);
  const profile = useMemo(() => customerProfiles.find((item) => item.id === activeId) ?? customerProfiles[0], [activeId]);

  const selectProfile = (id: string) => {
    setActiveId(id);
    setDemoMode(demoProfileIds.includes(id));
    setStage(0);
  };

  const activateDemo = () => {
    setDemoMode(true);
    setActiveId(demoProfileIds[1]);
    setStage(0);
    scrollTo("discovery");
  };

  return (
    <main className="min-h-screen bg-cream text-charcoal">
      <Header profiles={customerProfiles} activeId={activeId} onSelect={selectProfile} demoMode={demoMode} onDemo={activateDemo} />
      {demoMode && profile.presenterDescription && (
        <div className="mx-auto mt-5 max-w-7xl px-5 md:px-8">
          <div className="rounded-lg border border-sage-700/20 bg-sage-50 p-4 text-sm font-semibold text-sage-900 shadow-panel">{profile.presenterDescription}</div>
        </div>
      )}
      <Hero onStart={() => scrollTo("discovery")} onDemo={activateDemo} />
      <Discovery profile={profile} stage={stage} setStage={setStage} />
      <Routing profile={profile} />
      <AdvisorDashboard profile={profile} />
      <BusinessImpact />
      <footer className="border-t border-charcoal/10 py-8 text-center text-sm text-charcoal/55">Synthetic data only. Frontend-only prototype for hackathon demonstration.</footer>
    </main>
  );
}
