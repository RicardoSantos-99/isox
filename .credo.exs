%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: ["lib/isox/generated/"]
      },
      strict: true,
      checks: %{
        disabled: [
          # "Todos", "Todas", "método" etc. disparam esse check em qualquer
          # comentário em português — falso positivo sistêmico, não pontual.
          {Credo.Check.Design.TagTODO, []}
        ]
      }
    }
  ]
}
