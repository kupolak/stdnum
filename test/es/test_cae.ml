let test_compact () =
  let test_cases =
    [
      ("ES00008V1488Q", "ES00008V1488Q")
    ; (" ES00008V1488Q ", "ES00008V1488Q")
    ; ("es00008v1488q", "ES00008V1488Q")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Cae.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  (* From Python doctest: validate('ES00008V1488Q') *)
  let result = Es.Cae.validate "ES00008V1488Q" in
  Alcotest.(check string) "test_validate_valid" "ES00008V1488Q" result

let test_validate_valid_different_office () =
  (* Test with Madrid office (28) *)
  let result = Es.Cae.validate "ES00028V1000A" in
  Alcotest.(check string)
    "test_validate_valid_different_office" "ES00028V1000A" result

let test_validate_valid_different_activity () =
  (* Test with different activity code H1 *)
  let result = Es.Cae.validate "ES00008H1488Q" in
  Alcotest.(check string)
    "test_validate_valid_different_activity" "ES00008H1488Q" result

let test_validate_invalid_length () =
  (* From Python doctest: validate('00008V1488') - invalid check length *)
  Alcotest.check_raises "Invalid Length" Es.Cae.Invalid_length (fun () ->
      ignore (Es.Cae.validate "00008V1488"))

let test_validate_invalid_length_too_long () =
  Alcotest.check_raises "Invalid Length" Es.Cae.Invalid_length (fun () ->
      ignore (Es.Cae.validate "ES00008V1488QQ"))

let test_validate_invalid_format_no_es () =
  Alcotest.check_raises "Invalid Format" Es.Cae.Invalid_format (fun () ->
      ignore (Es.Cae.validate "XX00008V1488Q"))

let test_validate_invalid_format_not_000 () =
  Alcotest.check_raises "Invalid Format" Es.Cae.Invalid_format (fun () ->
      ignore (Es.Cae.validate "ES10008V1488Q"))

let test_validate_invalid_format_office () =
  Alcotest.check_raises "Invalid Format" Es.Cae.Invalid_format (fun () ->
      ignore (Es.Cae.validate "ES00099V1488Q"))

let test_validate_invalid_format_activity () =
  Alcotest.check_raises "Invalid Format" Es.Cae.Invalid_format (fun () ->
      ignore (Es.Cae.validate "ES00008Z9488Q"))

let test_validate_invalid_format_digits () =
  Alcotest.check_raises "Invalid Format" Es.Cae.Invalid_format (fun () ->
      ignore (Es.Cae.validate "ES00008V14A8Q"))

let test_validate_invalid_format_last_char () =
  Alcotest.check_raises "Invalid Format" Es.Cae.Invalid_format (fun () ->
      ignore (Es.Cae.validate "ES00008V14881"))

let test_is_valid_true () =
  (* From Python doctest: is_valid('ES00008V1488Q') *)
  let result = Es.Cae.is_valid "ES00008V1488Q" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  (* From Python doctest: is_valid('00008V1488') *)
  let result = Es.Cae.is_valid "00008V1488" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_is_valid_false_format () =
  let result = Es.Cae.is_valid "ES00099V1488Q" in
  Alcotest.(check bool) "test_is_valid_false_format" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ( "test_validate_valid_different_office"
    , `Quick
    , test_validate_valid_different_office )
  ; ( "test_validate_valid_different_activity"
    , `Quick
    , test_validate_valid_different_activity )
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_length_too_long"
    , `Quick
    , test_validate_invalid_length_too_long )
  ; ( "test_validate_invalid_format_no_es"
    , `Quick
    , test_validate_invalid_format_no_es )
  ; ( "test_validate_invalid_format_not_000"
    , `Quick
    , test_validate_invalid_format_not_000 )
  ; ( "test_validate_invalid_format_office"
    , `Quick
    , test_validate_invalid_format_office )
  ; ( "test_validate_invalid_format_activity"
    , `Quick
    , test_validate_invalid_format_activity )
  ; ( "test_validate_invalid_format_digits"
    , `Quick
    , test_validate_invalid_format_digits )
  ; ( "test_validate_invalid_format_last_char"
    , `Quick
    , test_validate_invalid_format_last_char )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_is_valid_false_format", `Quick, test_is_valid_false_format)
  ]

let () = Alcotest.run "Es.Cae" [ ("suite", suite) ]
