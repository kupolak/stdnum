let test_compact () =
  let result = Ua.Edrpou.compact " 3285 5961 " in
  Alcotest.(check string) "test_compact" "32855961" result

let test_calc_check_digit () =
  let result = Ua.Edrpou.calc_check_digit "3285596" in
  Alcotest.(check string) "test_calc_check_digit" "1" result

let test_validate_valid () =
  let result = Ua.Edrpou.validate "32855961" in
  Alcotest.(check string) "test_validate_valid" "32855961" result

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Ua.Edrpou.Invalid_checksum (fun () ->
      ignore (Ua.Edrpou.validate "32855968"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Ua.Edrpou.Invalid_length (fun () ->
      ignore (Ua.Edrpou.validate "12345"))

let test_is_valid_true () =
  let result = Ua.Edrpou.is_valid "32855961" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Ua.Edrpou.is_valid "32855968" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format () =
  let result = Ua.Edrpou.format " 32855961 " in
  Alcotest.(check string) "test_format" "32855961" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Ua.Edrpou" [ ("suite", suite) ]
