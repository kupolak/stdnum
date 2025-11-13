let test_compact () =
  let test_cases =
    [
      ("8601 11 17947", "86011117947")
    ; ("8601.11.17947", "86011117947")
    ; ("0000.4090403", "4090403") (* postgiro bank code *)
    ; ("86011117947", "86011117947")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Kontonr.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("8601 11 17947", "86011117947")
    ; ("0000.4090403", "4090403") (* postgiro *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Kontonr.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("8601 11 17947", true) (* Valid *)
    ; ("0000.4090403", true) (* Valid postgiro *)
    ; ("8601 11 17949", false) (* Invalid check digit *)
    ; ("12345", false) (* Invalid length *)
    ; ("86011117ABC", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Kontonr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("86011117947", "8601.11.17947"); ("8601 11 17947", "8601.11.17947") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Kontonr.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let test_to_iban () =
  let test_cases = [ ("8601 11 17947", "NO93 86011117947") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Kontonr.to_iban input in
      Alcotest.(check string) ("test_to_iban_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ; ("test_to_iban", `Quick, test_to_iban)
  ]

let () = Alcotest.run "No.Kontonr" [ ("suite", suite) ]
