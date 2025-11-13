let test_compact () =
  let test_cases =
    [
      ("EM0000000", "EM0000000")
    ; ("XR 1001R5 8", "XR1001R58")
    ; ("xr1001r58", "XR1001R58")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Identiteitskaartnummer.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("EM0000000", "EM0000000"); ("XR1001R58", "XR1001R58") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Identiteitskaartnummer.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("EM0000000", true) (* Valid with zeros *)
    ; ("XR1001R58", true) (* Valid alphanumeric *)
    ; ("XR 1001R5 8", true) (* Valid with spaces *)
    ; ("XR1001R", false) (* Too short *)
    ; ("581001RXR", false) (* Wrong format: starts with digit *)
    ; ("XR1001R5", false) (* Too short *)
    ; ("XR1001R5A", false) (* Last char not digit *)
    ; ("XR1O01R58", false) (* Contains letter O *)
    ; ("XO1001R58", false) (* Contains letter O *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Identiteitskaartnummer.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Nl_stdnum.Identiteitskaartnummer" [ ("suite", suite) ]
