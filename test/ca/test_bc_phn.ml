let test_compact () =
  let result = Ca.Bc_phn.compact " 9698 658 215 " in
  Alcotest.(check string) "test_compact" "9698658215" result

let test_calc_check_digit () =
  let result = Ca.Bc_phn.calc_check_digit "69865821" in
  Alcotest.(check string) "test_calc_check_digit" "5" result

let test_validate () =
  let result = Ca.Bc_phn.validate "9698 658 215" in
  Alcotest.(check string) "test_validate" "9698658215" result

let test_validate_invalid_checksum () =
  try
    ignore (Ca.Bc_phn.validate "9698648215");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ca.Bc_phn.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Ca.Bc_phn.validate "5736504210");
    Alcotest.fail "Expected Invalid_component exception"
  with Ca.Bc_phn.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (Ca.Bc_phn.validate "9698 658 21");
    Alcotest.fail "Expected Invalid_length exception"
  with Ca.Bc_phn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Ca.Bc_phn.validate "9736A04212");
    Alcotest.fail "Expected Invalid_format exception"
  with Ca.Bc_phn.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("9698 658 215", true)
    ; ("9698648215", false)
    ; ("5736504210", false)
    ; ("9736A04212", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ca.Bc_phn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Ca.Bc_phn.format "9698658215" in
  Alcotest.(check string) "test_format" "9698 658 215" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Ca.Bc_phn" [ ("suite", suite) ]
