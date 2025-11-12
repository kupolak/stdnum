let test_compact () =
  let test_cases =
    [
      ("BE32 123-4567890-02", "BE32123456789002")
    ; ("BE 48 3200 7018 4927", "BE48320070184927")
    ; (" BE32123456789002 ", "BE32123456789002")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Be.Iban.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Be.Iban.format "BE32123456789002" in
  Alcotest.(check string) "test_format" "BE32 1234 5678 9002" result

let test_validate_valid () =
  (* From Python doctest: validate('BE32 123-4567890-02') *)
  let result = Be.Iban.validate "BE32 123-4567890-02" in
  Alcotest.(check string) "test_validate_valid" "BE32123456789002" result

let test_validate_valid_2 () =
  let result = Be.Iban.validate "BE 48 3200 7018 4927" in
  Alcotest.(check string) "test_validate_valid_2" "BE48320070184927" result

let test_validate_invalid_national_check () =
  (* From Python doctest: validate('BE41091811735141') - incorrect national check digits *)
  Alcotest.check_raises "Invalid Checksum" Be.Iban.Invalid_checksum (fun () ->
      ignore (Be.Iban.validate "BE41091811735141"))

let test_validate_unknown_bank () =
  (* From Python doctest: validate('BE83138811735115') - unknown bank code (138) *)
  Alcotest.check_raises "Invalid Component" Be.Iban.Invalid_component (fun () ->
      ignore (Be.Iban.validate "BE83138811735115"))

let test_validate_not_belgian () =
  (* From Python doctest: validate('GR1601101050000010547023795') - not a Belgian IBAN *)
  Alcotest.check_raises "Invalid Component" Be.Iban.Invalid_component (fun () ->
      ignore (Be.Iban.validate "GR1601101050000010547023795"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Be.Iban.Invalid_length (fun () ->
      ignore (Be.Iban.validate "BE32123456"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Be.Iban.Invalid_format (fun () ->
      ignore (Be.Iban.validate "BE321234567890@2"))

let test_to_bic () =
  (* From Python doctest: to_bic('BE 48 3200 7018 4927') - bank code 320 is ING *)
  let result = Be.Iban.to_bic "BE 48 3200 7018 4927" in
  match result with
  | Some bic -> Alcotest.(check string) "bic" "BBRUBEBB" bic
  | None -> Alcotest.fail "Expected Some BIC"

let test_to_bic_unknown () =
  (* From Python doctest: to_bic('BE83138811735115') is None - unknown bank *)
  let result = Be.Iban.to_bic "BE83138811735115" in
  match result with
  | None -> () (* Expected *)
  | Some _ -> Alcotest.fail "Expected None for unknown bank"

let test_is_valid_true () =
  let result = Be.Iban.is_valid "BE32 123-4567890-02" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Be.Iban.is_valid "BE41091811735141" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid_2", `Quick, test_validate_valid_2)
  ; ( "test_validate_invalid_national_check"
    , `Quick
    , test_validate_invalid_national_check )
  ; ("test_validate_unknown_bank", `Quick, test_validate_unknown_bank)
  ; ("test_validate_not_belgian", `Quick, test_validate_not_belgian)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_to_bic", `Quick, test_to_bic)
  ; ("test_to_bic_unknown", `Quick, test_to_bic_unknown)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Be.Iban" [ ("suite", suite) ]
