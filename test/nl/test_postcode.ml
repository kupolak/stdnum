let test_compact () =
  let test_cases =
    [
      ("2601 DC", "2601DC")
    ; ("NL-2611ET", "2611ET")
    ; ("2611 ET", "2611ET")
    ; ("NL 2611 ET", "2611ET")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Postcode.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [ ("2601 DC", "2601 DC"); ("NL-2611ET", "2611 ET"); ("2611ET", "2611 ET") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Postcode.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("2601 DC", true) (* Valid *)
    ; ("NL-2611ET", true) (* Valid with NL prefix *)
    ; ("2611 ET", true) (* Valid with space *)
    ; ("26112 ET", false) (* Too many digits *)
    ; ("2611 SS", false) (* Blacklisted letter combination *)
    ; ("2611 SA", false) (* Blacklisted letter combination *)
    ; ("2611 SD", false) (* Blacklisted letter combination *)
    ; ("0611 ET", false) (* First digit cannot be 0 *)
    ; ("26A1 ET", false) (* Invalid format *)
    ; ("2611 E1", false) (* Last char not letter *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Postcode.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Nl.Postcode" [ ("suite", suite) ]
