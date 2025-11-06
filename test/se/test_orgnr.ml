let test_compact () =
  let test_cases =
    [
      ("123456-7897", "1234567897")
    ; (" 1234567897 ", "1234567897")
    ; ("123 456 789 7", "1234567897")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Se.Orgnr.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_luhn_checksum () =
  (* Valid number should have checksum 0 *)
  let result = Se.Orgnr.luhn_checksum "1234567897" in
  Alcotest.(check int) "test_luhn_checksum_valid" 0 result

let test_validate_valid () =
  let result = Se.Orgnr.validate "1234567897" in
  Alcotest.(check string) "test_validate_valid" "1234567897" result

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Se.Orgnr.Invalid_checksum (fun () ->
      ignore (Se.Orgnr.validate "1234567891"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Se.Orgnr.Invalid_length (fun () ->
      ignore (Se.Orgnr.validate "12345"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Se.Orgnr.Invalid_format (fun () ->
      ignore (Se.Orgnr.validate "12345678AB"))

let test_is_valid_true () =
  let result = Se.Orgnr.is_valid "1234567897" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Se.Orgnr.is_valid "1234567891" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format () =
  let result = Se.Orgnr.format "1234567897" in
  Alcotest.(check string) "test_format" "123456-7897" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_luhn_checksum", `Quick, test_luhn_checksum)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Se.Orgnr" [ ("suite", suite) ]
