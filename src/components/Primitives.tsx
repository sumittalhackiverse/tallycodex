import type { ReactNode } from "react";

export function Section({
  id,
  children,
  className = ""
}: {
  id: string;
  children: ReactNode;
  className?: string;
}) {
  return (
    <section id={id} className={`mx-auto w-full max-w-7xl px-5 py-14 md:px-8 md:py-20 ${className}`}>
      {children}
    </section>
  );
}

export function Card({ children, className = "" }: { children: ReactNode; className?: string }) {
  return <div className={`rounded-lg border border-charcoal/10 bg-paper shadow-panel ${className}`}>{children}</div>;
}

export function Button({
  children,
  variant = "primary",
  onClick,
  className = ""
}: {
  children: ReactNode;
  variant?: "primary" | "secondary" | "quiet" | "danger";
  onClick?: () => void;
  className?: string;
}) {
  const variants = {
    primary: "bg-orange-500 text-white hover:bg-orange-600 shadow-soft",
    secondary: "border border-charcoal/15 bg-paper text-charcoal hover:border-sage-700 hover:bg-sage-50",
    quiet: "bg-sage-50 text-sage-900 hover:bg-sage-100",
    danger: "bg-routeRed text-white hover:brightness-95"
  };

  return (
    <button
      type="button"
      onClick={onClick}
      className={`inline-flex items-center justify-center gap-2 rounded-lg px-4 py-3 text-sm font-semibold transition active:scale-[0.98] ${variants[variant]} ${className}`}
    >
      {children}
    </button>
  );
}

export function Metric({ label, value, detail }: { label: string; value: string; detail: string }) {
  return (
    <Card className="p-4">
      <p className="text-xs font-semibold uppercase tracking-[0.08em] text-charcoal/55">{label}</p>
      <p className="mt-3 text-3xl font-semibold text-charcoal">{value}</p>
      <p className="mt-2 text-sm text-sage-700">{detail}</p>
    </Card>
  );
}
