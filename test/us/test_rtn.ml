let test_calc_check_digit () =
  let test_cases = [ ("11100002", "5"); ("12345678", "0") ] in
  List.iter
    (fun (number, expected_result) ->
      let result = Us.Rtn.calc_check_digit number in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ number)
        expected_result result)
    test_cases

let test_validate_valid () =
  let result = Us.Rtn.validate "111000025" in
  Alcotest.(check string) "test_validate_valid" "111000025" result

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Us.Rtn.Invalid_length (fun () ->
      ignore (Us.Rtn.validate "11100002"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Us.Rtn.Invalid_format (fun () ->
      ignore (Us.Rtn.validate "11100002B"))

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Us.Rtn.Invalid_checksum (fun () ->
      ignore (Us.Rtn.validate "112000025"))

let test_is_valid_true () =
  let result = Us.Rtn.is_valid "111000025" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Us.Rtn.is_valid "112000025" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_compact () =
  let result = Us.Rtn.compact " 111-000-025 " in
  Alcotest.(check string) "test_compact" "111000025" result

let test_format () =
  let result = Us.Rtn.format " 111-000-025 " in
  Alcotest.(check string) "test_format" "111000025" result

let suite =
  [
    ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Us.Rtn" [ ("suite", suite) ]
