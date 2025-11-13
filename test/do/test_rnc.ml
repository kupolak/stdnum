let test_compact () =
  let test_cases =
    [
      ("1-01-85004-3", "101850043")
    ; ("101850043", "101850043")
    ; ("1 01 85004 3", "101850043")
    ; ("131246796", "131246796")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Rnc.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("10185004", "3"); ("13124679", "6") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Rnc.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("1-01-85004-3", "101850043")
    ; ("131246796", "131246796")
    ; ("101581601", "101581601") (* whitelisted number *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Rnc.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("1-01-85004-3", true) (* Valid *)
    ; ("131246796", true) (* Valid *)
    ; ("101581601", true) (* Whitelisted *)
    ; ("1018A0043", false) (* Invalid format *)
    ; ("101850042", false) (* Invalid checksum *)
    ; ("12345678", false) (* Invalid length *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Rnc.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("131246796", "1-31-24679-6"); ("1-01-85004-3", "1-01-85004-3") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Rnc.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Do.Rnc" [ ("suite", suite) ]
