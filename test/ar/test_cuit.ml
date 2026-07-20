let test_compact () =
  let result = Ar.Cuit.compact " 20-05536168-2 " in
  Alcotest.(check string) "test_compact" "20055361682" result

let test_calc_check_digit () =
  let result = Ar.Cuit.calc_check_digit "2005536168" in
  Alcotest.(check string) "test_calc_check_digit" "2" result

let test_validate () =
  let result = Ar.Cuit.validate "20-05536168-2" in
  Alcotest.(check string) "test_validate" "20055361682" result

let test_validate_invalid_checksum () =
  try
    ignore (Ar.Cuit.validate "20267565392");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ar.Cuit.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Ar.Cuit.validate "2005536168");
    Alcotest.fail "Expected Invalid_length exception"
  with Ar.Cuit.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Ar.Cuit.validate "2005536168A");
    Alcotest.fail "Expected Invalid_format exception"
  with Ar.Cuit.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (Ar.Cuit.validate "99055361682");
    Alcotest.fail "Expected Invalid_component exception"
  with Ar.Cuit.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("20-05536168-2", true)
    ; ("20267565392", false)
    ; ("99055361682", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ar.Cuit.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Ar.Cuit.format "20267565393" in
  Alcotest.(check string) "test_format" "20-26756539-3" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Ar.Cuit" [ ("suite", suite) ]
