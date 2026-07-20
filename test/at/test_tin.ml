let test_compact () =
  let result = At.Tin.compact " 59-119/9013 " in
  Alcotest.(check string) "test_compact" "591199013" result

let test_calc_check_digit () =
  let result = At.Tin.calc_check_digit "591199013" in
  Alcotest.(check string) "test_calc_check_digit" "3" result

let test_validate () =
  let result = At.Tin.validate "59-119/9013" in
  Alcotest.(check string) "test_validate" "591199013" result

let test_validate_invalid_checksum () =
  try
    ignore (At.Tin.validate "59-119/9014");
    Alcotest.fail "Expected Invalid_checksum exception"
  with At.Tin.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (At.Tin.validate "59-119/901");
    Alcotest.fail "Expected Invalid_length exception"
  with At.Tin.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (At.Tin.validate "59-A19/9013");
    Alcotest.fail "Expected Invalid_format exception"
  with At.Tin.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("59-119/9013", true)
    ; ("59-119/9014", false)
    ; ("59-A19/9013", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = At.Tin.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = At.Tin.format "591199013" in
  Alcotest.(check string) "test_format" "59-119/9013" result

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

let () = Alcotest.run "Stdnum.At.Tin" [ ("suite", suite) ]
