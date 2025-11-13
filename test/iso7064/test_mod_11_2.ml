let test_calc_check_digit () =
  let result = Iso7064.Mod_11_2.calc_check_digit "0794" in
  Alcotest.(check string) "test_calc_check_digit" "0" result

let test_calc_check_digit_x () =
  let result = Iso7064.Mod_11_2.calc_check_digit "079" in
  Alcotest.(check string) "test_calc_check_digit_x" "X" result

let test_validate_valid () =
  let result = Iso7064.Mod_11_2.validate "07940" in
  Alcotest.(check string) "test_validate_valid" "07940" result

let test_validate_valid_x () =
  let result = Iso7064.Mod_11_2.validate "079X" in
  Alcotest.(check string) "test_validate_valid_x" "079X" result

let test_validate_valid_lowercase_x () =
  let result = Iso7064.Mod_11_2.validate "079x" in
  Alcotest.(check string) "test_validate_valid_lowercase_x" "079x" result

let test_checksum () =
  let result = Iso7064.Mod_11_2.checksum "079X" in
  Alcotest.(check int) "test_checksum" 1 result

let test_validate_invalid () =
  Alcotest.check_raises "Invalid Checksum" Iso7064.Mod_11_2.Invalid_checksum
    (fun () -> ignore (Iso7064.Mod_11_2.validate "07941"))

let test_is_valid_true () =
  let result = Iso7064.Mod_11_2.is_valid "07940" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_true_x () =
  let result = Iso7064.Mod_11_2.is_valid "079X" in
  Alcotest.(check bool) "test_is_valid_true_x" true result

let test_is_valid_false () =
  let result = Iso7064.Mod_11_2.is_valid "07941" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_calc_check_digit_x", `Quick, test_calc_check_digit_x)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid_x", `Quick, test_validate_valid_x)
  ; ("test_validate_valid_lowercase_x", `Quick, test_validate_valid_lowercase_x)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate_invalid", `Quick, test_validate_invalid)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_true_x", `Quick, test_is_valid_true_x)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Iso7064.Mod_11_2" [ ("suite", suite) ]
