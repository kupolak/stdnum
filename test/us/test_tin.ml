open Us.Tin

let test_compact () =
  let input = "123-45-6789" in
  let expected = "123456789" in
  let result = compact input in
  Alcotest.(check string) "compact should remove dashes" expected result

let test_validate_ssn () =
  let input = "123-45-6789" in
  let expected = "123456789" in
  let result = validate input in
  Alcotest.(check string) "validate SSN" expected result

let test_validate_itin () =
  let input = "911-70-1234" in
  let expected = "911701234" in
  let result = validate input in
  Alcotest.(check string) "validate ITIN" expected result

let test_validate_ein () =
  let input = "12-3456789" in
  let expected = "123456789" in
  let result = validate input in
  Alcotest.(check string) "validate EIN" expected result

let test_validate_atin () =
  let input = "900-93-0000" in
  let expected = "900-93-0000" in
  let result = validate input in
  Alcotest.(check string) "validate ATIN" expected result

let test_is_valid_true () =
  let input = "123-45-6789" in
  let result = is_valid input in
  Alcotest.(check bool) "is_valid should return true for valid SSN" true result

let test_is_valid_false () =
  let input = "000000000" in
  let result = is_valid input in
  Alcotest.(check bool)
    "is_valid should return false for invalid number" false result

let test_guess_type_ssn () =
  let input = "123456789" in
  let result = guess_type input in
  let contains_ssn = List.mem "ssn" result in
  Alcotest.(check bool) "guess_type SSN should contain ssn" true contains_ssn

let test_guess_type_itin () =
  let input = "911701234" in
  let result = guess_type input in
  let contains_itin = List.mem "itin" result in
  Alcotest.(check bool) "guess_type ITIN should contain itin" true contains_itin

let test_guess_type_ein () =
  let input = "123456789" in
  let result = guess_type input in
  let contains_ein = List.mem "ein" result in
  Alcotest.(check bool) "guess_type EIN should contain ein" true contains_ein

let test_format_ssn () =
  let input = "123456789" in
  let result = format input in
  let has_valid_format = String.contains result '-' in
  Alcotest.(check bool) "format should add formatting" true has_valid_format

let test_format_ein () =
  let input = "123456789" in
  let result = format input in
  let has_valid_format = String.contains result '-' in
  Alcotest.(check bool) "format should add formatting" true has_valid_format

let test_format_invalid () =
  let input = "123-456" in
  let result = format input in
  Alcotest.(check string)
    "format should not change invalid numbers" input result

let suite =
  [
    ("compact", `Quick, test_compact)
  ; ("validate SSN", `Quick, test_validate_ssn)
  ; ("validate ITIN", `Quick, test_validate_itin)
  ; ("validate EIN", `Quick, test_validate_ein)
  ; ("validate ATIN", `Quick, test_validate_atin)
  ; ("is_valid true", `Quick, test_is_valid_true)
  ; ("is_valid false", `Quick, test_is_valid_false)
  ; ("guess_type SSN", `Quick, test_guess_type_ssn)
  ; ("guess_type ITIN", `Quick, test_guess_type_itin)
  ; ("guess_type EIN", `Quick, test_guess_type_ein)
  ; ("format SSN", `Quick, test_format_ssn)
  ; ("format EIN", `Quick, test_format_ein)
  ; ("format invalid", `Quick, test_format_invalid)
  ]

let () = Alcotest.run "Us.Tin" [ ("suite", suite) ]
