let test_compact () =
  let test_cases =
    [
      ("988 077 917", "988077917")
    ; ("988077917", "988077917")
    ; ("988  077  917", "988077917")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Orgnr.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_checksum () =
  let test_cases = [ ("988077917", 0); ("988077918", 1) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Orgnr.checksum input in
      Alcotest.(check int) ("test_checksum_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("988 077 917", "988077917") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Orgnr.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("988 077 917", true) (* Valid *)
    ; ("988077917", true) (* Valid *)
    ; ("988 077 918", false) (* Invalid checksum *)
    ; ("12345678", false) (* Invalid length *)
    ; ("98807791A", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Orgnr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("988077917", "988 077 917"); ("988 077 917", "988 077 917") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = No.Orgnr.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "No.Orgnr" [ ("suite", suite) ]
