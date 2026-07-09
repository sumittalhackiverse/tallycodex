type IconName =
  | "spark"
  | "shield"
  | "clock"
  | "user"
  | "family"
  | "heart"
  | "route"
  | "briefcase"
  | "check"
  | "chart"
  | "phone"
  | "send"
  | "save"
  | "calendar"
  | "arrow";

const paths: Record<IconName, string[]> = {
  spark: ["M12 2l1.6 5.2L19 9l-5.4 1.8L12 16l-1.6-5.2L5 9l5.4-1.8L12 2z", "M19 15l.8 2.2L22 18l-2.2.8L19 21l-.8-2.2L16 18l2.2-.8L19 15z"],
  shield: ["M12 3l7 3v5c0 4.6-3 8-7 10-4-2-7-5.4-7-10V6l7-3z", "M9 12l2 2 4-5"],
  clock: ["M12 21a9 9 0 100-18 9 9 0 000 18z", "M12 7v5l3 2"],
  user: ["M12 12a4 4 0 100-8 4 4 0 000 8z", "M5 21a7 7 0 0114 0"],
  family: ["M9 11a3 3 0 100-6 3 3 0 000 6z", "M17 12a2.5 2.5 0 100-5 2.5 2.5 0 000 5z", "M3 21a6 6 0 0112 0", "M13 21a5 5 0 018 0"],
  heart: ["M20.5 8.8c0 5.4-8.5 10.2-8.5 10.2S3.5 14.2 3.5 8.8A4.8 4.8 0 0112 5.7a4.8 4.8 0 018.5 3.1z"],
  route: ["M5 6h4a3 3 0 010 6H8a3 3 0 000 6h11", "M17 15l3 3-3 3", "M5 6a2 2 0 100-4 2 2 0 000 4z"],
  briefcase: ["M9 6V5a3 3 0 016 0v1", "M4 8h16v11H4z", "M4 12h16"],
  check: ["M20 6L9 17l-5-5"],
  chart: ["M4 19V5", "M4 19h17", "M8 15l3-4 3 2 5-7"],
  phone: ["M7 4h10v16H7z", "M11 17h2"],
  send: ["M21 3L10 14", "M21 3l-7 18-4-7-7-4 18-7z"],
  save: ["M5 4h12l2 2v14H5z", "M8 4v6h8", "M8 19v-5h8v5"],
  calendar: ["M7 3v4", "M17 3v4", "M4 8h16", "M5 5h14v16H5z"],
  arrow: ["M5 12h14", "M13 6l6 6-6 6"]
};

export function Icon({ name, className = "h-5 w-5" }: { name: IconName; className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      {paths[name].map((d) => (
        <path key={d} d={d} />
      ))}
    </svg>
  );
}
