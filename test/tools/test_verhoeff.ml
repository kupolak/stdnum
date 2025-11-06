let test_checksum_valid () =
  let result = Tools.Verhoeff.checksum "12340" in
  Alcotest.(check int) "test_checksum_valid" 0 result

let test_checksum_invalid () =
  let result = Tools.Verhoeff.checksum "1234" in
  Alcotest.(check int) "test_checksum_invalid" 1 result

let test_calc_check_digit () =
  let result = Tools.Verhoeff.calc_check_digit "1234" in
  Alcotest.(check string) "test_calc_check_digit" "0" result

let test_validate_valid () =
  let result = Tools.Verhoeff.validate "12340" in
  Alcotest.(check string) "test_validate_valid" "12340" result

let test_validate_invalid () =
  Alcotest.check_raises "Invalid Checksum" Tools.Verhoeff.Invalid_checksum
    (fun () -> ignore (Tools.Verhoeff.validate "1234"))

let test_validate_empty () =
  Alcotest.check_raises "Invalid Format" Tools.Verhoeff.Invalid_format
    (fun () -> ignore (Tools.Verhoeff.validate ""))

let test_is_valid_true () =
  let result = Tools.Verhoeff.is_valid "12340" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Tools.Verhoeff.is_valid "1234" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_checksum_valid", `Quick, test_checksum_valid)
  ; ("test_checksum_invalid", `Quick, test_checksum_invalid)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid", `Quick, test_validate_invalid)
  ; ("test_validate_empty", `Quick, test_validate_empty)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Tools.Verhoeff" [ ("suite", suite) ]
