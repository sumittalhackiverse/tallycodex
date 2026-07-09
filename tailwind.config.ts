import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        cream: "#F7F1E6",
        paper: "#FFFDF8",
        charcoal: "#16211A",
        sage: {
          50: "#EEF4EA",
          100: "#DBE7D4",
          300: "#A9BE9B",
          500: "#6F8D67",
          700: "#335536",
          900: "#15361F"
        },
        orange: {
          400: "#F19A58",
          500: "#EA6F2F",
          600: "#C9511F"
        },
        amber: "#D9932E",
        routeRed: "#C94337"
      },
      boxShadow: {
        soft: "0 18px 55px rgba(22, 33, 26, 0.10)",
        panel: "0 10px 34px rgba(22, 33, 26, 0.08)"
      },
      fontFamily: {
        sans: ["Inter", "ui-sans-serif", "system-ui", "Segoe UI", "Arial", "sans-serif"]
      }
    }
  },
  plugins: []
};

export default config;
