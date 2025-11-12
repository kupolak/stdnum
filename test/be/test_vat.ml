let test_compact () =
  let test_cases =
    [
      ("BE403019261", "0403019261")
    ; ("(0)403019261", "0403019261")
    ; ("BE 428759497", "0428759497")
    ; (" 0403019261 ", "0403019261")
    ; ("403019261", "0403019261") (* 9-digit old format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Be.Vat.compact input in
      Alcotest.(check string)
        (Printf.sprintf "test_compact_%s" input)
        expected_result result)
    test_cases

let test_validate_valid () =
  (* From Python doctest: validate('BE 428759497') *)
  let result = Be.Vat.validate "BE 428759497" in
  Alcotest.(check string) "test_validate_valid" "0428759497" result

let test_validate_valid_2 () =
  (* From Python doctest: compact('BE403019261') *)
  let result = Be.Vat.validate "BE403019261" in
  Alcotest.(check string) "test_validate_valid_2" "0403019261" result

let test_validate_valid_old_format () =
  (* 9-digit old format *)
  let result = Be.Vat.validate "403019261" in
  Alcotest.(check string) "test_validate_valid_old_format" "0403019261" result

let test_validate_valid_parentheses () =
  (* (0) prefix format *)
  let result = Be.Vat.validate "(0)403019261" in
  Alcotest.(check string) "test_validate_valid_parentheses" "0403019261" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('BE431150351') - invalid checksum *)
  Alcotest.check_raises "Invalid Checksum" Be.Vat.Invalid_checksum (fun () ->
      ignore (Be.Vat.validate "BE431150351"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Be.Vat.Invalid_length (fun () ->
      ignore (Be.Vat.validate "BE12345"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Be.Vat.Invalid_format (fun () ->
      ignore (Be.Vat.validate "BE04030192A1"))

let test_validate_zero () =
  (* Number must be > 0 *)
  Alcotest.check_raises "Invalid Format" Be.Vat.Invalid_format (fun () ->
      ignore (Be.Vat.validate "0000000000"))

let test_validate_invalid_first_digit () =
  (* First digit must be 0 or 1 *)
  Alcotest.check_raises "Invalid Component" Be.Vat.Invalid_component (fun () ->
      ignore (Be.Vat.validate "2428759497"))

let test_is_valid_true () =
  let result = Be.Vat.is_valid "BE 428759497" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_true_2 () =
  let result = Be.Vat.is_valid "BE403019261" in
  Alcotest.(check bool) "test_is_valid_true_2" true result

let test_is_valid_false () =
  let result = Be.Vat.is_valid "BE431150351" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid_2", `Quick, test_validate_valid_2)
  ; ("test_validate_valid_old_format", `Quick, test_validate_valid_old_format)
  ; ("test_validate_valid_parentheses", `Quick, test_validate_valid_parentheses)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_zero", `Quick, test_validate_zero)
  ; ( "test_validate_invalid_first_digit"
    , `Quick
    , test_validate_invalid_first_digit )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_true_2", `Quick, test_is_valid_true_2)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Be.Vat" [ ("suite", suite) ]
