let test_compact () =
  let test_cases =
    [
      ("ES 1234-123456789012-JY", "ES1234123456789012JY")
    ; (" ES 1234 123456789012 JY ", "ES1234123456789012JY")
    ; ("ES1234123456789012JY1F", "ES1234123456789012JY1F")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Cups.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_format_20_chars () =
  let result = Es.Cups.format "ES1234123456789012JY" in
  Alcotest.(check string)
    "test_format_20_chars" "ES 1234 1234 5678 9012 JY" result

let test_format_22_chars () =
  let result = Es.Cups.format "ES1234123456789012JY1F" in
  Alcotest.(check string)
    "test_format_22_chars" "ES 1234 1234 5678 9012 JY 1F" result

let test_calc_check_digits () =
  let result = Es.Cups.calc_check_digits "ES1234123456789012" in
  Alcotest.(check string) "test_calc_check_digits" "JY" result

let test_validate_valid_20 () =
  (* From Python doctest: validate('ES 1234-123456789012-JY') *)
  let result = Es.Cups.validate "ES 1234-123456789012-JY" in
  Alcotest.(check string) "test_validate_valid_20" "ES1234123456789012JY" result

let test_validate_valid_22 () =
  let result = Es.Cups.validate "ES1234123456789012JY1F" in
  Alcotest.(check string)
    "test_validate_valid_22" "ES1234123456789012JY1F" result

let test_validate_invalid_format_wrong_border () =
  (* From Python doctest: validate('ES 1234-123456789012-JY 1T') *)
  (* T is not a valid border point type *)
  Alcotest.check_raises "Invalid Format" Es.Cups.Invalid_format (fun () ->
      ignore (Es.Cups.validate "ES 1234-123456789012-JY 1T"))

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('ES 1234-123456789012-XY 1F') *)
  Alcotest.check_raises "Invalid Checksum" Es.Cups.Invalid_checksum (fun () ->
      ignore (Es.Cups.validate "ES 1234-123456789012-XY 1F"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Es.Cups.Invalid_length (fun () ->
      ignore (Es.Cups.validate "ES1234123456789012"))

let test_validate_invalid_component () =
  (* Country code must be ES *)
  Alcotest.check_raises "Invalid Component" Es.Cups.Invalid_component (fun () ->
      ignore (Es.Cups.validate "FR1234123456789012JY"))

let test_is_valid_true () =
  let result = Es.Cups.is_valid "ES 1234-123456789012-JY" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Es.Cups.is_valid "ES 1234-123456789012-XY 1F" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format_20_chars", `Quick, test_format_20_chars)
  ; ("test_format_22_chars", `Quick, test_format_22_chars)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate_valid_20", `Quick, test_validate_valid_20)
  ; ("test_validate_valid_22", `Quick, test_validate_valid_22)
  ; ( "test_validate_invalid_format_wrong_border"
    , `Quick
    , test_validate_invalid_format_wrong_border )
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Es.Cups" [ ("suite", suite) ]
