let test_compact () =
  let result = At.Vnr.compact " 1237 010180 " in
  Alcotest.(check string) "test_compact" "1237010180" result

let test_calc_check_digit () =
  let result = At.Vnr.calc_check_digit "1237010180" in
  Alcotest.(check string) "test_calc_check_digit" "7" result

let test_validate () =
  let result = At.Vnr.validate "1237 010180" in
  Alcotest.(check string) "test_validate" "1237010180" result

let test_validate_invalid_checksum () =
  try
    ignore (At.Vnr.validate "2237 010180");
    Alcotest.fail "Expected Invalid_checksum exception"
  with At.Vnr.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (At.Vnr.validate "1237 01018");
    Alcotest.fail "Expected Invalid_length exception"
  with At.Vnr.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (At.Vnr.validate "123A 010180");
    Alcotest.fail "Expected Invalid_format exception"
  with At.Vnr.Invalid_format -> ()

let test_validate_invalid_format_starts_with_zero () =
  try
    ignore (At.Vnr.validate "0237 010180");
    Alcotest.fail "Expected Invalid_format exception"
  with At.Vnr.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("1237 010180", true)
    ; ("2237 010180", false)
    ; ("0237 010180", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = At.Vnr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_format_starts_with_zero", `Quick, test_validate_invalid_format_starts_with_zero)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.At.Vnr" [ ("suite", suite) ]
