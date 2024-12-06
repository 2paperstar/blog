export default {
  plugins: [import("prettier-plugin-go-template")],
  overrides: [
    {
      files: ["*.html"],
      options: {
        parser: "go-template",
        goTemplateBracketSpacing: true,
        bracketSameLine: true,
      },
    },
  ],
};
