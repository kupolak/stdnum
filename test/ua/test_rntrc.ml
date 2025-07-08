let test_compact () =
  let test_cases =
    [ (" 25 30 41 40 71 ", "2530414071"); ("1759013776", "1759013776") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ua.Rntrc.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("175901377", "6"); ("253041407", "1") ] in
  List.iter
    (fun (number, expected_result) ->
      let result = Ua.Rntrc.calc_check_digit number in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ number)
        expected_result result)
    test_cases

let test_validate_valid () =
  let result = Ua.Rntrc.validate "1759013776" in
  Alcotest.(check string) "test_validate_valid" "1759013776" result

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Ua.Rntrc.Invalid_format (fun () ->
      ignore (Ua.Rntrc.validate "ABC12abc34"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Ua.Rntrc.Invalid_length (fun () ->
      ignore (Ua.Rntrc.validate "12345"))

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Ua.Rntrc.Invalid_checksum (fun () ->
      ignore (Ua.Rntrc.validate "1759013770"))

let test_is_valid_true () =
  let result = Ua.Rntrc.is_valid "1759013776" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Ua.Rntrc.is_valid "1759013770" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format () =
  let result = Ua.Rntrc.format " 25 30 41 40 71 " in
  Alcotest.(check string) "test_format" "2530414071" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Ua.Rntrc" [ ("suite", suite) ]
