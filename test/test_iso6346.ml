let test_compact () =
  let test_cases =
    [
      ("csqu3054383", "CSQU3054383")
    ; ("CSQU3054383", "CSQU3054383")
    ; ("tasu117 000 0", "TASU1170000")
    ; ("tcnu7200794", "TCNU7200794")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso6346.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [ ("CSQU305438", "3"); ("TCNU720079", "4"); ("TOLU473478", "7") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso6346.calc_check_digit input in
      Alcotest.(check string) "test_calc_check_digit" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("CSQU3054383", "CSQU3054383")
    ; ("csqu3054383", "CSQU3054383")
    ; ("csQU3054383", "CSQU3054383")
    ; ("tcnu7200794", "TCNU7200794")
    ; ("tolu4734787", "TOLU4734787")
    ; ("GYOU4047990", "GYOU4047990")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso6346.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Iso6346.validate "CSQU3054384");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Iso6346.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Iso6346.validate "CSQU305438");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Iso6346.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Iso6346.validate "CSQU3054Z83");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Iso6346.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("CSQU3054383", true)
    ; ("csqu3054383", true)
    ; ("TCNU7200794", true)
    ; ("CSQU3054384", false) (* bad checksum *)
    ; ("CSQU305438", false) (* wrong length *)
    ; ("CSQU3054Z83", false) (* invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso6346.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("CSQU3054383", "CSQU 305438 3")
    ; ("tasu1170000", "TASU 117000 0")
    ; ("TCNU7200794", "TCNU 720079 4")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Iso6346.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Iso6346" [ ("suite", suite) ]
