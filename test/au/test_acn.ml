let test_compact () =
  let result = Au.Acn.compact " 004 085 616 " in
  Alcotest.(check string) "test_compact" "004085616" result

let test_calc_check_digit () =
  let result = Au.Acn.calc_check_digit "004085616" in
  Alcotest.(check string) "test_calc_check_digit" "6" result

let test_validate () =
  let result = Au.Acn.validate "004 085 616" in
  Alcotest.(check string) "test_validate" "004085616" result

let test_validate_invalid_checksum () =
  try
    ignore (Au.Acn.validate "999 999 999");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Au.Acn.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Au.Acn.validate "004 085 61");
    Alcotest.fail "Expected Invalid_length exception"
  with Au.Acn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Au.Acn.validate "004 085 61A");
    Alcotest.fail "Expected Invalid_format exception"
  with Au.Acn.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("004 085 616", true)
    ; ("010 499 966", true)
    ; ("999 999 999", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Au.Acn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Au.Acn.format "004085616" in
  Alcotest.(check string) "test_format" "004 085 616" result

let test_to_abn () =
  let result = Au.Acn.to_abn "002 724 334" in
  Alcotest.(check string) "test_to_abn" "43002724334" result

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
  ; ("test_to_abn", `Quick, test_to_abn)
  ]

let () = Alcotest.run "Stdnum.Au.Acn" [ ("suite", suite) ]
