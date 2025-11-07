let test_compact () =
  let test_cases =
    [
      ("SK 202 274 96 19", "2022749619")
    ; ("SK202-274-96-19", "2022749619")
    ; (" 2022749619 ", "2022749619")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Sk.Dph.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_checksum () =
  let result = Sk.Dph.checksum "2022749619" in
  Alcotest.(check int) "test_checksum" 0 result

let test_validate_valid () =
  let test_cases =
    [ ("SK 202 274 96 19", "2022749619"); ("2022749619", "2022749619") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Sk.Dph.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Sk.Dph.Invalid_checksum (fun () ->
      ignore (Sk.Dph.validate "SK 202 274 96 18"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Sk.Dph.Invalid_length (fun () ->
      ignore (Sk.Dph.validate "12345"))

let test_validate_invalid_format_starts_with_zero () =
  Alcotest.check_raises "Invalid Format" Sk.Dph.Invalid_format (fun () ->
      ignore (Sk.Dph.validate "0222749619"))

let test_validate_invalid_format_third_digit () =
  Alcotest.check_raises "Invalid Format" Sk.Dph.Invalid_format (fun () ->
      ignore (Sk.Dph.validate "2012749619"))

let test_is_valid_true () =
  let result = Sk.Dph.is_valid "SK 202 274 96 19" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Sk.Dph.is_valid "SK 202 274 96 18" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_format_starts_with_zero"
    , `Quick
    , test_validate_invalid_format_starts_with_zero )
  ; ( "test_validate_invalid_format_third_digit"
    , `Quick
    , test_validate_invalid_format_third_digit )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Sk.Dph" [ ("suite", suite) ]
