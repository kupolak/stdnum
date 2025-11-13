let test_compact () =
  let test_cases =
    [
      ("NO93 8601 1117 947", "NO9386011117947")
    ; ("NO93-8601-1117-947", "NO9386011117947")
    ; ("NO9386011117947", "NO9386011117947")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Iban.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_to_kontonr () =
  let test_cases = [ ("NO93 8601 1117 947", "86011117947") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Iban.to_kontonr input in
      Alcotest.(check string)
        ("test_to_kontonr_" ^ input)
        expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("NO9386011117947", "NO93 8601 1117 947")
    ; ("NO93 8601 1117 947", "NO93 8601 1117 947")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Iban.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("NO93 8601 1117 947", "NO9386011117947") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Iban.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("NO93 8601 1117 947", true) (* Valid *)
    ; ("NO9386011117947", true) (* Valid *)
    ; ("NO92 8601 1117 947", false) (* Invalid IBAN check digit *)
    ; ("NO23 8601 1117 946", false) (* Invalid Konto nr. check digit *)
    ; ("GR1601101050000010547023795", false) (* Different country *)
    ; ("NO9386011117", false) (* Too short *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Iban.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_to_kontonr", `Quick, test_to_kontonr)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "No.Iban" [ ("suite", suite) ]
