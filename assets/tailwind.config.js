const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  plugins: [require("@tailwindcss/forms")],
  purge: {
    enabled: false,
    content: [
      "../**/*.leex",
      "../**/*.eex",
      "../**/*.ex",
      "../**/*.exs",
      "./**/*.js",
    ],
  },
  theme: {
    extend: {
      maxWidth: {
        card: "628px",
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      inset: {
        "2px": "2px",
      },
      scale: {
        flip: "-1",
      },
      gridTemplateColumns: {
        "sortable-list":
          "16px minmax(70px, 1fr)  minmax(140px, 1fr) minmax(40px, 1fr) 50px",
      },
    },
  },

  variants: {
    extend: {
      backgroundColor: ["checked"],
      borderColor: ["checked"],
    },
  },
}
