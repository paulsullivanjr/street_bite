%{
  configs: [
    %{
      name: "default",
      checks: [
        {Credo.Check.Warning.SpecWithStruct, false}
      ]
    }
  ]
}
