let test_compact () =
  let test_cases =
    [
      ("NO 995 525 828 MVA", "995525828MVA")
    ; ("995 525 828 MVA", "995525828MVA")
    ; ("995525828MVA", "995525828MVA")
    ; ("NO995525828MVA", "995525828MVA")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Mva.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("NO 995 525 828 MVA", "995525828MVA") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Mva.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("NO 995 525 828 MVA", true) (* Valid *)
    ; ("995525828MVA", true) (* Valid *)
    ; ("NO 995 525 829 MVA", false) (* Invalid checksum in orgnr *)
    ; ("995525828", false) (* Missing MVA suffix *)
    ; ("12345678MVA", false) (* Invalid length *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Mva.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("995525828MVA", "NO 995 525 828 MVA")
    ; ("NO 995 525 828 MVA", "NO 995 525 828 MVA")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Mva.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "No.Mva" [ ("suite", suite) ]
