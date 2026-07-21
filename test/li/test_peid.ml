let test_compact () =
  let result = Li.Peid.compact " 00001234567 " in
  Alcotest.(check string) "test_compact" "1234567" result

let test_validate () =
  let result1 = Li.Peid.validate "1234567" in
  Alcotest.(check string) "test_validate_1" "1234567" result1;
  let result2 = Li.Peid.validate "00001234567" in
  Alcotest.(check string) "test_validate_2" "1234567" result2

let test_validate_invalid_length () =
  try
    ignore (Li.Peid.validate "00001234568913454545");
    Alcotest.fail "Expected Invalid_length exception"
  with Li.Peid.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("1234567", true); ("00001234567", true); ("00001234568913454545", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Li.Peid.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Li.Peid" [ ("suite", suite) ]
