let test_compact () =
  let test_cases =
    [
      ("1012.22.331", "101222331")
    ; ("101222331", "101222331")
    ; ("101 222 331", "101222331")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Onderwijsnummer.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_checksum () =
  let test_cases = [ ("101222331", 5); ("100252333", 0) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Onderwijsnummer.checksum input in
      Alcotest.(check int) ("test_checksum_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("1012.22.331", "101222331") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Onderwijsnummer.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("1012.22.331", true) (* Valid *)
    ; ("101222331", true) (* Valid without formatting *)
    ; ("100252333", false) (* Invalid checksum (0 instead of 5) *)
    ; ("1012.22.3333", false) (* Invalid length (10 digits) *)
    ; ("2112.22.337", false) (* Must start with 10 *)
    ; ("101222A31", false) (* Invalid format *)
    ; ("000000000", false) (* Zero is invalid *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Onderwijsnummer.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Nl.Onderwijsnummer" [ ("suite", suite) ]
