let test_compact () =
  let result = Au.Abn.compact " 83 914 571 673 " in
  Alcotest.(check string) "test_compact" "83914571673" result

let test_calc_check_digits () =
  let result = Au.Abn.calc_check_digits "914571673" in
  Alcotest.(check string) "test_calc_check_digits" "83" result

let test_validate () =
  let result = Au.Abn.validate "83 914 571 673" in
  Alcotest.(check string) "test_validate" "83914571673" result

let test_validate_invalid_checksum () =
  try
    ignore (Au.Abn.validate "99 999 999 999");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Au.Abn.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Au.Abn.validate "8391457167");
    Alcotest.fail "Expected Invalid_length exception"
  with Au.Abn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Au.Abn.validate "8391457167A");
    Alcotest.fail "Expected Invalid_format exception"
  with Au.Abn.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("83 914 571 673", true); ("99 999 999 999", false); ("83914571673", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Au.Abn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Au.Abn.format "51824753556" in
  Alcotest.(check string) "test_format" "51 824 753 556" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Au.Abn" [ ("suite", suite) ]
