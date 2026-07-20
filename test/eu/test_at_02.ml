let test_compact () =
  let result = Eu.At_02.compact " ES++()+23ZZZ4//7690558N " in
  Alcotest.(check string) "test_compact" "ES23ZZZ47690558N" result

let test_validate () =
  let result = Eu.At_02.validate "ES 23 ZZZ 47690558N" in
  Alcotest.(check string) "test_validate_1" "ES23ZZZ47690558N" result;
  let result2 = Eu.At_02.validate "ES2300047690558N" in
  Alcotest.(check string) "test_validate_2" "ES2300047690558N" result2

let test_validate_invalid_checksum () =
  try
    ignore (Eu.At_02.validate "ES24ZZZ47690558N");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Eu.At_02.Invalid_checksum -> ()

let test_calc_check_digits () =
  let result = Eu.At_02.calc_check_digits "ESXXZZZ47690558N" in
  Alcotest.(check string) "test_calc_check_digits" "23" result

let test_is_valid () =
  let test_cases =
    [
      ("ES 23 ZZZ 47690558N", true)
    ; ("ES2300047690558N", true)
    ; ("ES24ZZZ47690558N", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Eu.At_02.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Eu.At_02" [ ("suite", suite) ]
