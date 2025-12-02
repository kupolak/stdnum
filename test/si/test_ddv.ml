let test_compact () =
  let test_cases =
    [
      ("SI 5022 3054", "50223054")
    ; ("SI50223054", "50223054")
    ; ("50223054", "50223054")
    ; ("SI 1234 5678", "12345678")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Ddv.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("5022305", "4"); ("1234567", "9"); ("9876543", "4") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Ddv.calc_check_digit input in
      Alcotest.(check string) "test_calc_check_digit" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("SI 5022 3054", "50223054")
    ; ("SI50223054", "50223054")
    ; ("50223054", "50223054")
    ; ("12345679", "12345679")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Ddv.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Si.Ddv.validate "SI 50223055");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Si.Ddv.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Si.Ddv.validate "5022305");
    Alcotest.fail "Expected Invalid_length exception"
  with Si.Ddv.Invalid_length -> ()

let test_validate_invalid_format_letters () =
  try
    ignore (Si.Ddv.validate "5022305A");
    Alcotest.fail "Expected Invalid_format exception"
  with Si.Ddv.Invalid_format -> ()

let test_validate_invalid_format_leading_zero () =
  try
    ignore (Si.Ddv.validate "01234567");
    Alcotest.fail "Expected Invalid_format exception"
  with Si.Ddv.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("SI 5022 3054", true)
    ; ("SI50223054", true)
    ; ("50223054", true)
    ; ("12345679", true)
    ; ("SI 50223055", false) (* bad checksum *)
    ; ("5022305", false) (* wrong length *)
    ; ("5022305A", false) (* invalid format *)
    ; ("01234567", false) (* starts with 0 *)
    ; ("502230549", false) (* too long *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Ddv.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_format_letters"
    , `Quick
    , test_validate_invalid_format_letters )
  ; ( "test_validate_invalid_format_leading_zero"
    , `Quick
    , test_validate_invalid_format_leading_zero )
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Si.Ddv" [ ("suite", suite) ]
