let test_compact () =
  let test_cases =
    [ (" 172 917 160 60 ", "17291716060"); ("17291716060", "17291716060") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Tr.Tckimlik.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digits () =
  let test_cases = [ ("172917160", "60"); ("123456789", "50") ] in
  List.iter
    (fun (number, expected_result) ->
      let result = Tr.Tckimlik.calc_check_digits number in
      Alcotest.(check string)
        ("test_calc_check_digits_" ^ number)
        expected_result result)
    test_cases

let test_validate_valid () =
  let result = Tr.Tckimlik.validate "17291716060" in
  Alcotest.(check string) "test_validate_valid" "17291716060" result

let test_validate_invalid_format_starts_with_zero () =
  Alcotest.check_raises "Invalid Format (starts with 0)"
    Tr.Tckimlik.Invalid_format (fun () ->
      ignore (Tr.Tckimlik.validate "07291716092"))

let test_validate_invalid_format_non_digits () =
  Alcotest.check_raises "Invalid Format (non-digits)" Tr.Tckimlik.Invalid_format
    (fun () -> ignore (Tr.Tckimlik.validate "1729171606A"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Tr.Tckimlik.Invalid_length (fun () ->
      ignore (Tr.Tckimlik.validate "1729171606"))

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Tr.Tckimlik.Invalid_checksum
    (fun () -> ignore (Tr.Tckimlik.validate "17291716050"))

let test_is_valid_true () =
  let result = Tr.Tckimlik.is_valid "17291716060" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Tr.Tckimlik.is_valid "17291716050" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format () =
  let result = Tr.Tckimlik.format " 172 917 160 60 " in
  Alcotest.(check string) "test_format" "17291716060" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ( "test_validate_invalid_format_starts_with_zero"
    , `Quick
    , test_validate_invalid_format_starts_with_zero )
  ; ( "test_validate_invalid_format_non_digits"
    , `Quick
    , test_validate_invalid_format_non_digits )
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Tr.Tckimlik" [ ("suite", suite) ]
