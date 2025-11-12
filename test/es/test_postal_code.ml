let test_compact () =
  let test_cases =
    [ ("01000", "01000"); (" 52000 ", "52000"); ("28001", "28001") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Postal_code.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid_01 () =
  (* From Python doctest: validate('01000') *)
  let result = Es.Postal_code.validate "01000" in
  Alcotest.(check string) "test_validate_valid_01" "01000" result

let test_validate_valid_52 () =
  (* From Python doctest: validate('52000') *)
  let result = Es.Postal_code.validate "52000" in
  Alcotest.(check string) "test_validate_valid_52" "52000" result

let test_validate_valid_middle () =
  let result = Es.Postal_code.validate "28001" in
  Alcotest.(check string) "test_validate_valid_middle" "28001" result

let test_validate_invalid_component_00 () =
  (* From Python doctest: validate('00000') *)
  Alcotest.check_raises "Invalid Component" Es.Postal_code.Invalid_component
    (fun () -> ignore (Es.Postal_code.validate "00000"))

let test_validate_invalid_component_53 () =
  (* From Python doctest: validate('53000') *)
  Alcotest.check_raises "Invalid Component" Es.Postal_code.Invalid_component
    (fun () -> ignore (Es.Postal_code.validate "53000"))

let test_validate_invalid_component_99 () =
  (* From Python doctest: validate('99999') *)
  Alcotest.check_raises "Invalid Component" Es.Postal_code.Invalid_component
    (fun () -> ignore (Es.Postal_code.validate "99999"))

let test_validate_invalid_length_short () =
  (* From Python doctest: validate('5200') *)
  Alcotest.check_raises "Invalid Length" Es.Postal_code.Invalid_length
    (fun () -> ignore (Es.Postal_code.validate "5200"))

let test_validate_invalid_length_long () =
  (* From Python doctest: validate('520000') *)
  Alcotest.check_raises "Invalid Length" Es.Postal_code.Invalid_length
    (fun () -> ignore (Es.Postal_code.validate "520000"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Es.Postal_code.Invalid_format
    (fun () -> ignore (Es.Postal_code.validate "0100A"))

let test_is_valid_true () =
  let result = Es.Postal_code.is_valid "01000" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false_component () =
  let result = Es.Postal_code.is_valid "00000" in
  Alcotest.(check bool) "test_is_valid_false_component" false result

let test_is_valid_false_length () =
  let result = Es.Postal_code.is_valid "5200" in
  Alcotest.(check bool) "test_is_valid_false_length" false result

let test_is_valid_false_format () =
  let result = Es.Postal_code.is_valid "0100A" in
  Alcotest.(check bool) "test_is_valid_false_format" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid_01", `Quick, test_validate_valid_01)
  ; ("test_validate_valid_52", `Quick, test_validate_valid_52)
  ; ("test_validate_valid_middle", `Quick, test_validate_valid_middle)
  ; ( "test_validate_invalid_component_00"
    , `Quick
    , test_validate_invalid_component_00 )
  ; ( "test_validate_invalid_component_53"
    , `Quick
    , test_validate_invalid_component_53 )
  ; ( "test_validate_invalid_component_99"
    , `Quick
    , test_validate_invalid_component_99 )
  ; ( "test_validate_invalid_length_short"
    , `Quick
    , test_validate_invalid_length_short )
  ; ( "test_validate_invalid_length_long"
    , `Quick
    , test_validate_invalid_length_long )
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false_component", `Quick, test_is_valid_false_component)
  ; ("test_is_valid_false_length", `Quick, test_is_valid_false_length)
  ; ("test_is_valid_false_format", `Quick, test_is_valid_false_format)
  ]

let () = Alcotest.run "Es.Postal_code" [ ("suite", suite) ]
