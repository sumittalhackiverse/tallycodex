import { demoProfileIds } from "../data/profiles";
import type { CustomerProfile } from "../types";
import { Button } from "./Primitives";

const nav = [
  ["Welcome", "welcome"],
  ["Discovery", "discovery"],
  ["Routing", "routing"],
  ["Advisor", "advisor"],
  ["Impact", "impact"]
];

const goTo = (id: string) => document.getElementById(id)?.scrollIntoView({ behavior: "smooth", block: "start" });

export function Header({
  profiles,
  activeId,
  onSelect,
  demoMode,
  onDemo
}: {
  profiles: CustomerProfile[];
  activeId: string;
  onSelect: (id: string) => void;
  demoMode: boolean;
  onDemo: () => void;
}) {
  const demoProfiles = demoProfileIds.map((id) => profiles.find((profile) => profile.id === id)!);

  return (
    <header className="sticky top-0 z-40 border-b border-charcoal/10 bg-cream/88 backdrop-blur-xl">
      <div className="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-3 px-5 py-3 md:px-8">
        <button type="button" onClick={() => goTo("welcome")} className="flex items-center gap-3 text-left">
          <span className="grid h-9 w-9 place-items-center rounded-lg bg-sage-900 text-sm font-bold text-cream">T</span>
          <span>
            <span className="block text-base font-bold text-charcoal">TALly</span>
            <span className="block text-xs text-charcoal/60">AI Assisted Insurance Journey</span>
          </span>
        </button>

        <nav className="hidden items-center gap-1 lg:flex">
          {nav.map(([label, id]) => (
            <button key={id} type="button" onClick={() => goTo(id)} className="rounded-lg px-3 py-2 text-sm font-medium text-charcoal/70 transition hover:bg-sage-50 hover:text-charcoal">
              {label}
            </button>
          ))}
        </nav>

        <div className="flex items-center gap-2">
          {demoMode && <span className="rounded-lg bg-sage-900 px-3 py-2 text-xs font-semibold uppercase tracking-[0.08em] text-cream">Demo Mode Active</span>}
          <Button onClick={onDemo} className="py-2">
            Try Demo Mode
          </Button>
        </div>

        <div className="flex w-full flex-wrap items-center gap-2 rounded-lg border border-charcoal/10 bg-paper p-2 shadow-panel">
          <span className="px-2 text-xs font-semibold uppercase tracking-[0.08em] text-charcoal/55">Persona</span>
          {demoProfiles.map((profile) => (
            <button
              key={profile.id}
              type="button"
              onClick={() => onSelect(profile.id)}
              className={`rounded-lg px-3 py-2 text-sm font-semibold transition ${
                activeId === profile.id ? "bg-sage-900 text-cream" : "bg-sage-50 text-charcoal hover:bg-sage-100"
              }`}
            >
              {profile.demoPersona}
            </button>
          ))}
          <select
            value={activeId}
            onChange={(event) => onSelect(event.target.value)}
            className="ml-auto min-w-52 rounded-lg border border-charcoal/10 bg-white px-3 py-2 text-sm font-semibold text-charcoal outline-none focus:border-sage-700"
            aria-label="Switch customer profile"
          >
            {profiles.map((profile) => (
              <option key={profile.id} value={profile.id}>
                {profile.firstName} {profile.lastName} - {profile.recommendedPath}
              </option>
            ))}
          </select>
        </div>
      </div>
    </header>
  );
}
