let test_compact () =
  let test_cases =
    [
      ("54362315-K", "54362315K")
    ; (" 54362315 K ", "54362315K")
    ; ("54362315K", "54362315K")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Dni.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  (* From Python doctest *)
  let result = Es.Dni.calc_check_digit "54362315" in
  Alcotest.(check string) "test_calc_check_digit" "K" result

let test_validate_valid () =
  (* From Python doctest: validate('54362315-K') *)
  let result = Es.Dni.validate "54362315-K" in
  Alcotest.(check string) "test_validate_valid" "54362315K" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('54362315Z') - invalid check digit *)
  Alcotest.check_raises "Invalid Checksum" Es.Dni.Invalid_checksum (fun () ->
      ignore (Es.Dni.validate "54362315Z"))

let test_validate_invalid_length () =
  (* From Python doctest: validate('54362315') - digit missing *)
  Alcotest.check_raises "Invalid Length" Es.Dni.Invalid_length (fun () ->
      ignore (Es.Dni.validate "54362315"))

let test_validate_invalid_format () =
  (* Non-digits in first 8 positions *)
  Alcotest.check_raises "Invalid Format" Es.Dni.Invalid_format (fun () ->
      ignore (Es.Dni.validate "5436231XK"))

let test_is_valid_true () =
  let result = Es.Dni.is_valid "54362315-K" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Es.Dni.is_valid "54362315Z" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_various_valid_dnis () =
  (* Test a few more valid DNIs to ensure modulo 23 algorithm works *)
  let valid_dnis =
    [
      "12345678Z"
    ; (* 12345678 mod 23 = 14, alphabet[14] = Z *)
      "00000000T" (* 0 mod 23 = 0, alphabet[0] = T *)
    ]
  in
  List.iter
    (fun dni ->
      Alcotest.(check bool) ("valid_" ^ dni) true (Es.Dni.is_valid dni))
    valid_dnis

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_various_valid_dnis", `Quick, test_various_valid_dnis)
  ]

let () = Alcotest.run "Es.Dni" [ ("suite", suite) ]
