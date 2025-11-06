let test_compact () =
  let test_cases =
    [
      ("SE 123456789701", "123456789701")
    ; ("SE123456789701", "123456789701")
    ; (" 123456789701 ", "123456789701")
    ; ("se 123456789701", "123456789701")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Se.Vat.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  let result = Se.Vat.validate "SE 123456789701" in
  Alcotest.(check string) "test_validate_valid" "123456789701" result

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Se.Orgnr.Invalid_checksum (fun () ->
      ignore (Se.Vat.validate "123456789101"))

let test_validate_invalid_format_not_01 () =
  Alcotest.check_raises "Invalid Format" Se.Vat.Invalid_format (fun () ->
      ignore (Se.Vat.validate "123456789702"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Se.Orgnr.Invalid_length (fun () ->
      ignore (Se.Vat.validate "12345"))

let test_is_valid_true () =
  let result = Se.Vat.is_valid "SE 123456789701" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false_checksum () =
  let result = Se.Vat.is_valid "123456789101" in
  Alcotest.(check bool) "test_is_valid_false_checksum" false result

let test_is_valid_false_format () =
  let result = Se.Vat.is_valid "123456789702" in
  Alcotest.(check bool) "test_is_valid_false_format" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ( "test_validate_invalid_format_not_01"
    , `Quick
    , test_validate_invalid_format_not_01 )
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false_checksum", `Quick, test_is_valid_false_checksum)
  ; ("test_is_valid_false_format", `Quick, test_is_valid_false_format)
  ]

let () = Alcotest.run "Se.Vat" [ ("suite", suite) ]
