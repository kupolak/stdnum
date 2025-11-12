let test_compact () =
  let test_cases =
    [
      ("1234-1234-16 1234567890", "12341234161234567890")
    ; (" 1234 1234 16 1234567890 ", "12341234161234567890")
    ; ("1234123416 1234567890", "12341234161234567890")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Ccc.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Es.Ccc.format "12341234161234567890" in
  Alcotest.(check string) "test_format" "1234 1234 16 12345 67890" result

let test_calc_check_digits () =
  (* From Python doctest example *)
  let result = Es.Ccc.calc_check_digits "12341234001234567890" in
  Alcotest.(check string) "test_calc_check_digits" "16" result

let test_validate_valid () =
  (* From Python doctest: validate('1234-1234-16 1234567890') *)
  let result = Es.Ccc.validate "1234-1234-16 1234567890" in
  Alcotest.(check string) "test_validate_valid" "12341234161234567890" result

let test_validate_invalid_length () =
  (* From Python doctest: validate('134-1234-16 1234567890') - wrong length *)
  Alcotest.check_raises "Invalid Length" Es.Ccc.Invalid_length (fun () ->
      ignore (Es.Ccc.validate "134-1234-16 1234567890"))

let test_validate_invalid_format () =
  (* From Python doctest: validate('12X4-1234-16 1234567890') - non numbers *)
  Alcotest.check_raises "Invalid Format" Es.Ccc.Invalid_format (fun () ->
      ignore (Es.Ccc.validate "12X4-1234-16 1234567890"))

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('1234-1234-00 1234567890') - invalid check digits *)
  Alcotest.check_raises "Invalid Checksum" Es.Ccc.Invalid_checksum (fun () ->
      ignore (Es.Ccc.validate "1234-1234-00 1234567890"))

let test_is_valid_true () =
  let result = Es.Ccc.is_valid "1234-1234-16 1234567890" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Es.Ccc.is_valid "1234-1234-00 1234567890" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_to_iban () =
  (* From Python doctest: to_iban('21000418450200051331') *)
  let result = Es.Ccc.to_iban "21000418450200051331" in
  Alcotest.(check string) "test_to_iban" "ES2121000418450200051331" result

let test_to_iban_formatted () =
  (* Test with formatted input *)
  let result = Es.Ccc.to_iban "1234 1234 16 12345 67890" in
  Alcotest.(check string)
    "test_to_iban_formatted" "ES77 12341234161234567890" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_to_iban", `Quick, test_to_iban)
  ; ("test_to_iban_formatted", `Quick, test_to_iban_formatted)
  ]

let () = Alcotest.run "Es.Ccc" [ ("suite", suite) ]
