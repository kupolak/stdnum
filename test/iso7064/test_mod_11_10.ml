let test_checksum_valid () =
  let result = Iso7064.Mod_11_10.checksum "794623" in
  Alcotest.(check int) "test_checksum_valid" 1 result

let test_checksum_valid2 () =
  let result = Iso7064.Mod_11_10.checksum "002006673085" in
  Alcotest.(check int) "test_checksum_valid2" 1 result

let test_calc_check_digit () =
  let result = Iso7064.Mod_11_10.calc_check_digit "79462" in
  Alcotest.(check string) "test_calc_check_digit" "3" result

let test_calc_check_digit2 () =
  let result = Iso7064.Mod_11_10.calc_check_digit "00200667308" in
  Alcotest.(check string) "test_calc_check_digit2" "5" result

let test_validate_valid () =
  let result = Iso7064.Mod_11_10.validate "794623" in
  Alcotest.(check string) "test_validate_valid" "794623" result

let test_validate_valid2 () =
  let result = Iso7064.Mod_11_10.validate "002006673085" in
  Alcotest.(check string) "test_validate_valid2" "002006673085" result

let test_validate_invalid () =
  Alcotest.check_raises "Invalid Checksum" Iso7064.Mod_11_10.Invalid_checksum
    (fun () -> ignore (Iso7064.Mod_11_10.validate "794624"))

let test_is_valid_true () =
  let result = Iso7064.Mod_11_10.is_valid "794623" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Iso7064.Mod_11_10.is_valid "794624" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_checksum_valid", `Quick, test_checksum_valid)
  ; ("test_checksum_valid2", `Quick, test_checksum_valid2)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_calc_check_digit2", `Quick, test_calc_check_digit2)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid2", `Quick, test_validate_valid2)
  ; ("test_validate_invalid", `Quick, test_validate_invalid)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Iso7064.Mod_11_10" [ ("suite", suite) ]
