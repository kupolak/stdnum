let test_compact () =
  let test_cases =
    [
      ("ES77 1234-1234-16 1234567890", "ES7712341234161234567890")
    ; (" ES77 1234 1234 16 1234567890 ", "ES7712341234161234567890")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Iban.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_format () =
  (* From Python doctest: format('ES771234-1234-16 1234567890') *)
  let result = Es.Iban.format "ES7712341234161234567890" in
  Alcotest.(check string) "test_format" "ES77 1234 1234 1612 3456 7890" result

let test_to_ccc () =
  (* From Python doctest: to_ccc('ES77 1234-1234-16 1234567890') *)
  let result = Es.Iban.to_ccc "ES77 1234-1234-16 1234567890" in
  Alcotest.(check string) "test_to_ccc" "12341234161234567890" result

let test_validate_valid () =
  (* From Python doctest: validate('ES77 1234-1234-16 1234567890') *)
  let result = Es.Iban.validate "ES77 1234-1234-16 1234567890" in
  Alcotest.(check string)
    "test_validate_valid" "ES7712341234161234567890" result

let test_validate_different_country () =
  (* From Python doctest: validate('GR1601101050000010547023795') - different country *)
  Alcotest.check_raises "Invalid Component" Es.Iban.Invalid_component (fun () ->
      ignore (Es.Iban.to_ccc "GR1601101050000010547023795"))

let test_validate_invalid_iban_checksum () =
  (* From Python doctest: validate('ES12 1234-1234-16 1234567890') - invalid IBAN check digit *)
  Alcotest.check_raises "Invalid Checksum" Es.Iban.Invalid_checksum (fun () ->
      ignore (Es.Iban.validate "ES12 1234-1234-16 1234567890"))

let test_validate_invalid_ccc_checksum () =
  (* From Python doctest: validate('ES15 1234-1234-17 1234567890') - invalid CCC check digit *)
  Alcotest.check_raises "Invalid Checksum" Es.Iban.Invalid_checksum (fun () ->
      ignore (Es.Iban.validate "ES15 1234-1234-17 1234567890"))

let test_is_valid_true () =
  let result = Es.Iban.is_valid "ES77 1234-1234-16 1234567890" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false_iban () =
  let result = Es.Iban.is_valid "ES12 1234-1234-16 1234567890" in
  Alcotest.(check bool) "test_is_valid_false_iban" false result

let test_is_valid_false_ccc () =
  let result = Es.Iban.is_valid "ES15 1234-1234-17 1234567890" in
  Alcotest.(check bool) "test_is_valid_false_ccc" false result

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Es.Iban.Invalid_length (fun () ->
      ignore (Es.Iban.validate "ES771234"))

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ; ("test_to_ccc", `Quick, test_to_ccc)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_different_country", `Quick, test_validate_different_country)
  ; ( "test_validate_invalid_iban_checksum"
    , `Quick
    , test_validate_invalid_iban_checksum )
  ; ( "test_validate_invalid_ccc_checksum"
    , `Quick
    , test_validate_invalid_ccc_checksum )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false_iban", `Quick, test_is_valid_false_iban)
  ; ("test_is_valid_false_ccc", `Quick, test_is_valid_false_ccc)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ]

let () = Alcotest.run "Es.Iban" [ ("suite", suite) ]
