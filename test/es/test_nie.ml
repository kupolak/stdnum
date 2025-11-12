let test_compact () =
  let test_cases =
    [
      ("x-2482300w", "X2482300W")
    ; (" X-2482300W ", "X2482300W")
    ; ("y1234567x", "Y1234567X")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Nie.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [ ("X2482300", "W"); ("Y1234567", "X"); ("Z5435011", "R") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Nie.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate_valid () =
  (* From Python doctest: validate('x-2482300w') *)
  let result = Es.Nie.validate "x-2482300w" in
  Alcotest.(check string) "test_validate_valid" "X2482300W" result

let test_validate_valid_y () =
  let result = Es.Nie.validate "Y1234567X" in
  Alcotest.(check string) "test_validate_valid_y" "Y1234567X" result

let test_validate_valid_z () =
  let result = Es.Nie.validate "Z5435011R" in
  Alcotest.(check string) "test_validate_valid_z" "Z5435011R" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('x-2482300a') - invalid check digit *)
  Alcotest.check_raises "Invalid Checksum" Es.Nie.Invalid_checksum (fun () ->
      ignore (Es.Nie.validate "x-2482300a"))

let test_validate_invalid_length () =
  (* From Python doctest: validate('X2482300') - digit missing *)
  Alcotest.check_raises "Invalid Length" Es.Nie.Invalid_length (fun () ->
      ignore (Es.Nie.validate "X2482300"))

let test_validate_invalid_length_too_long () =
  Alcotest.check_raises "Invalid Length" Es.Nie.Invalid_length (fun () ->
      ignore (Es.Nie.validate "X2482300WW"))

let test_validate_invalid_format_first_char () =
  Alcotest.check_raises "Invalid Format" Es.Nie.Invalid_format (fun () ->
      ignore (Es.Nie.validate "A2482300W"))

let test_validate_invalid_format_middle_chars () =
  Alcotest.check_raises "Invalid Format" Es.Nie.Invalid_format (fun () ->
      ignore (Es.Nie.validate "X248A300W"))

let test_is_valid_true () =
  let result = Es.Nie.is_valid "x-2482300w" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false_checksum () =
  let result = Es.Nie.is_valid "x-2482300a" in
  Alcotest.(check bool) "test_is_valid_false_checksum" false result

let test_is_valid_false_length () =
  let result = Es.Nie.is_valid "X2482300" in
  Alcotest.(check bool) "test_is_valid_false_length" false result

let test_is_valid_false_format () =
  let result = Es.Nie.is_valid "A2482300W" in
  Alcotest.(check bool) "test_is_valid_false_format" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid_y", `Quick, test_validate_valid_y)
  ; ("test_validate_valid_z", `Quick, test_validate_valid_z)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_length_too_long"
    , `Quick
    , test_validate_invalid_length_too_long )
  ; ( "test_validate_invalid_format_first_char"
    , `Quick
    , test_validate_invalid_format_first_char )
  ; ( "test_validate_invalid_format_middle_chars"
    , `Quick
    , test_validate_invalid_format_middle_chars )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false_checksum", `Quick, test_is_valid_false_checksum)
  ; ("test_is_valid_false_length", `Quick, test_is_valid_false_length)
  ; ("test_is_valid_false_format", `Quick, test_is_valid_false_format)
  ]

let () = Alcotest.run "Es.Nie" [ ("suite", suite) ]
