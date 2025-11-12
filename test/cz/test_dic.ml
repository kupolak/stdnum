let test_compact () =
  let test_cases =
    [
      ("CZ 25123891", "25123891")
    ; ("CZ25123891", "25123891")
    ; (" 25123891 ", "25123891")
    ; ("cz 25123891", "25123891")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cz.Dic.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit_legal () =
  (* From Python example: 25123891 where 1 is the check digit *)
  let result = Cz.Dic.calc_check_digit_legal "2512389" in
  Alcotest.(check string) "test_calc_check_digit_legal" "1" result

let test_calc_check_digit_special () =
  (* From Python example: 640903926 where 6 is the check digit *)
  (* Skip first digit (6) and last digit (6), middle is "4090392" *)
  let result = Cz.Dic.calc_check_digit_special "4090392" in
  Alcotest.(check string) "test_calc_check_digit_special" "6" result

let test_validate_legal_entity () =
  (* Valid 8-digit legal entity from Python doctest *)
  let result = Cz.Dic.validate "25123891" in
  Alcotest.(check string) "test_validate_legal_entity" "25123891" result

let test_validate_legal_entity_invalid_checksum () =
  (* From Python doctest - incorrect check digit *)
  Alcotest.check_raises "Invalid Checksum" Cz.Dic.Invalid_checksum (fun () ->
      ignore (Cz.Dic.validate "25123890"))

let test_validate_legal_entity_starts_with_9 () =
  (* 8-digit numbers cannot start with 9 *)
  Alcotest.check_raises "Invalid Component" Cz.Dic.Invalid_component (fun () ->
      ignore (Cz.Dic.validate "95123891"))

let test_validate_special_case () =
  (* Valid 9-digit special case from Python doctest: 640903926 *)
  let result = Cz.Dic.validate "640903926" in
  Alcotest.(check string) "test_validate_special_case" "640903926" result

let test_validate_special_case_invalid_checksum () =
  (* Invalid checksum for special case *)
  Alcotest.check_raises "Invalid Checksum" Cz.Dic.Invalid_checksum (fun () ->
      ignore (Cz.Dic.validate "640903920"))

let test_validate_rc_10_digit () =
  (* Valid 10-digit RČ from Python doctest: 7103192745 *)
  let result = Cz.Dic.validate "7103192745" in
  Alcotest.(check string) "test_validate_rc_10_digit" "7103192745" result

let test_validate_rc_9_digit () =
  (* Valid 9-digit RČ (not starting with 6, so treated as RČ) *)
  (* From Python doctest: validate('991231123') *)
  let result = Cz.Dic.validate "991231123" in
  Alcotest.(check string) "test_validate_rc_9_digit" "991231123" result

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Cz.Dic.Invalid_length (fun () ->
      ignore (Cz.Dic.validate "12345"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Cz.Dic.Invalid_format (fun () ->
      ignore (Cz.Dic.validate "2512389A"))

let test_is_valid_true_legal () =
  let result = Cz.Dic.is_valid "25123891" in
  Alcotest.(check bool) "test_is_valid_true_legal" true result

let test_is_valid_true_special () =
  let result = Cz.Dic.is_valid "640903926" in
  Alcotest.(check bool) "test_is_valid_true_special" true result

let test_is_valid_true_rc () =
  let result = Cz.Dic.is_valid "7103192745" in
  Alcotest.(check bool) "test_is_valid_true_rc" true result

let test_is_valid_false () =
  let result = Cz.Dic.is_valid "25123890" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_validate_with_cz_prefix () =
  let result = Cz.Dic.validate "CZ25123891" in
  Alcotest.(check string) "test_validate_with_cz_prefix" "25123891" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit_legal", `Quick, test_calc_check_digit_legal)
  ; ("test_calc_check_digit_special", `Quick, test_calc_check_digit_special)
  ; ("test_validate_legal_entity", `Quick, test_validate_legal_entity)
  ; ( "test_validate_legal_entity_invalid_checksum"
    , `Quick
    , test_validate_legal_entity_invalid_checksum )
  ; ( "test_validate_legal_entity_starts_with_9"
    , `Quick
    , test_validate_legal_entity_starts_with_9 )
  ; ("test_validate_special_case", `Quick, test_validate_special_case)
  ; ( "test_validate_special_case_invalid_checksum"
    , `Quick
    , test_validate_special_case_invalid_checksum )
  ; ("test_validate_rc_10_digit", `Quick, test_validate_rc_10_digit)
  ; ("test_validate_rc_9_digit", `Quick, test_validate_rc_9_digit)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_true_legal", `Quick, test_is_valid_true_legal)
  ; ("test_is_valid_true_special", `Quick, test_is_valid_true_special)
  ; ("test_is_valid_true_rc", `Quick, test_is_valid_true_rc)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_validate_with_cz_prefix", `Quick, test_validate_with_cz_prefix)
  ]

let () = Alcotest.run "Cz.Dic" [ ("suite", suite) ]
