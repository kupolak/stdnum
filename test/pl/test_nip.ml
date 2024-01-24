let test_compact () =
  let test_cases =
    [ ("PL123-456-789", "123456789"); ("PL987654321", "987654321") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Nip.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_checksum () =
  let test_cases =
    [
      ("3376615156", 0)
    ; ("1589865114", 0)
    ; ("5253073032", 0)
    ; ("3395528234", 0)
    ; ("1130649857", 0)
    ; ("9651782698", 0)
    ; ("1228649955", 0)
    ; ("1232644555", 1)
    ; ("1234567890", 10) (* Invalid *)
    ; ("0987654321", 6) (* Invalid *)
    ]
  in
  List.iter
    (fun (nip, expected_result) ->
      let result = Pl.Nip.checksum nip in
      Alcotest.(check int) ("test_checksum_" ^ nip) expected_result result)
    test_cases

let test_validate_valid () =
  let result = Pl.Nip.validate "PL8213563435" in
  Alcotest.(check string) "test_validate_valid" "8213563435" result

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Pl.Nip.Invalid_format (fun () ->
      ignore (Pl.Nip.validate "ABC12abc34"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Pl.Nip.Invalid_length (fun () ->
      ignore (Pl.Nip.validate "123"))

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Pl.Nip.Invalid_checksum (fun () ->
      ignore (Pl.Nip.validate "PL1234567890"))

let test_is_valid_true () =
  let result = Pl.Nip.is_valid "PL568-268-8231" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Pl.Nip.is_valid "PL538-268-8231" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format () =
  let result = Pl.Nip.format "PL8567346215" in
  Alcotest.(check string) "test_format" "856-734-62-15" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "test_nip" [ ("suite", suite) ]
