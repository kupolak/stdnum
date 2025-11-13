let test_compact () =
  let test_cases =
    [
      ("CHE-107.787.577 IVA", "CHE107787577IVA")
    ; ("CHE107787577IVA", "CHE107787577IVA")
    ; ("CHE-107.787.577 MWST", "CHE107787577MWST")
    ; ("CHE-107.787.577 TVA", "CHE107787577TVA")
    ; ("CHE-107.787.577 TPV", "CHE107787577TPV")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch_stdnum.Vat.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("CHE-107.787.577 IVA", "CHE107787577IVA")
    ; ("CHE-107.787.577 MWST", "CHE107787577MWST")
    ; ("CHE-107.787.577 TVA", "CHE107787577TVA")
    ; ("CHE-107.787.577 TPV", "CHE107787577TPV")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch_stdnum.Vat.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("CHE-107.787.577 IVA", true) (* Valid *)
    ; ("CHE-107.787.577 MWST", true) (* Valid with MWST *)
    ; ("CHE-107.787.577 TVA", true) (* Valid with TVA *)
    ; ("CHE-107.787.577 TPV", true) (* Valid with TPV *)
    ; ("CHE-107.787.578 IVA", false) (* Invalid checksum *)
    ; ("CHE-107.787.577 XYZ", false) (* Invalid suffix *)
    ; ("CHE-107.787.577", false) (* Missing suffix *)
    ; ("CHE-107.787.5 IVA", false) (* Too short *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch_stdnum.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("CHE107787577IVA", "CHE-107.787.577 IVA")
    ; ("CHE-107.787.577 IVA", "CHE-107.787.577 IVA")
    ; ("CHE107787577MWST", "CHE-107.787.577 MWST")
    ; ("CHE107787577TVA", "CHE-107.787.577 TVA")
    ; ("CHE107787577TPV", "CHE-107.787.577 TPV")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch_stdnum.Vat.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Ch_stdnum.Vat" [ ("suite", suite) ]
