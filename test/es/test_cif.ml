let test_compact () =
  let test_cases =
    [
      ("A13 585 625", "A13585625")
    ; (" J99216582 ", "J99216582")
    ; ("J-99216582", "J99216582")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Cif.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_split () =
  (* From Python doctest: split('A13 585 625') *)
  let type_letter, province, sequence, check = Es.Cif.split "A13 585 625" in
  Alcotest.(check string) "type_letter" "A" type_letter;
  Alcotest.(check string) "province" "13" province;
  Alcotest.(check string) "sequence" "58562" sequence;
  Alcotest.(check string) "check" "5" check

let test_calc_check_digits () =
  (* Calculate check digits for J9921658 *)
  let result = Es.Cif.calc_check_digits "J9921658" in
  (* Result should be "2B" per Python code *)
  Alcotest.(check string) "check digits" "2B" result

let test_validate_valid () =
  (* From Python doctest: validate('J99216582') *)
  let result = Es.Cif.validate "J99216582" in
  Alcotest.(check string) "test_validate_valid" "J99216582" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('J99216583') - invalid check digit *)
  Alcotest.check_raises "Invalid Checksum" Es.Cif.Invalid_checksum (fun () ->
      ignore (Es.Cif.validate "J99216583"))

let test_validate_invalid_length () =
  (* From Python doctest: validate('J992165831') - too long *)
  Alcotest.check_raises "Invalid Length" Es.Cif.Invalid_length (fun () ->
      ignore (Es.Cif.validate "J992165831"))

let test_validate_invalid_format_nif () =
  (* From Python doctest: validate('M-1234567-L') - valid NIF but not valid CIF *)
  (* M is not in the valid CIF first character list *)
  Alcotest.check_raises "Invalid Format" Es.Cif.Invalid_format (fun () ->
      ignore (Es.Cif.validate "M-1234567-L"))

let test_validate_invalid_format_first_char () =
  (* From Python doctest: validate('O-1234567-L') - invalid first character *)
  Alcotest.check_raises "Invalid Format" Es.Cif.Invalid_format (fun () ->
      ignore (Es.Cif.validate "O-1234567-L"))

let test_is_valid_true () =
  let result = Es.Cif.is_valid "J99216582" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Es.Cif.is_valid "J99216583" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_validate_with_alpha_check () =
  (* A13585625 has numeric check digit 5 *)
  let result = Es.Cif.validate "A13585625" in
  Alcotest.(check string) "test_validate_with_alpha_check" "A13585625" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_split", `Quick, test_split)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_format_nif"
    , `Quick
    , test_validate_invalid_format_nif )
  ; ( "test_validate_invalid_format_first_char"
    , `Quick
    , test_validate_invalid_format_first_char )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_validate_with_alpha_check", `Quick, test_validate_with_alpha_check)
  ]

let () = Alcotest.run "Es.Cif" [ ("suite", suite) ]
