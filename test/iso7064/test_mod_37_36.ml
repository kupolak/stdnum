let test_checksum () =
  let result = Iso7064.Mod_37_36.checksum "A12425GABC1234002M" in
  Alcotest.(check int) "test_checksum" 1 result

let test_calc_check_digit () =
  let result = Iso7064.Mod_37_36.calc_check_digit "A12425GABC1234002" in
  Alcotest.(check char) "test_calc_check_digit" 'M' result

let test_validate_valid () =
  let result = Iso7064.Mod_37_36.validate "A12425GABC1234002M" in
  Alcotest.(check string) "test_validate_valid" "A12425GABC1234002M" result

let test_validate_invalid () =
  Alcotest.check_raises "Invalid Checksum" Iso7064.Mod_37_36.Invalid_checksum
    (fun () -> ignore (Iso7064.Mod_37_36.validate "A12425GABC1234002X"))

let test_is_valid_true () =
  let result = Iso7064.Mod_37_36.is_valid "A12425GABC1234002M" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Iso7064.Mod_37_36.is_valid "A12425GABC1234002X" in
  Alcotest.(check bool) "test_is_valid_false" false result

(* Test with custom alphabet (Mod 11, 10) *)
let test_custom_alphabet_calc () =
  let result =
    Iso7064.Mod_37_36.calc_check_digit ~alphabet:"0123456789" "00200667308"
  in
  Alcotest.(check char) "test_custom_alphabet_calc" '5' result

let test_custom_alphabet_validate () =
  let result =
    Iso7064.Mod_37_36.validate ~alphabet:"0123456789" "002006673085"
  in
  Alcotest.(check string) "test_custom_alphabet_validate" "002006673085" result

let test_custom_alphabet_is_valid () =
  let result =
    Iso7064.Mod_37_36.is_valid ~alphabet:"0123456789" "002006673085"
  in
  Alcotest.(check bool) "test_custom_alphabet_is_valid" true result

let suite =
  [
    ("test_checksum", `Quick, test_checksum)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid", `Quick, test_validate_invalid)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_custom_alphabet_calc", `Quick, test_custom_alphabet_calc)
  ; ("test_custom_alphabet_validate", `Quick, test_custom_alphabet_validate)
  ; ("test_custom_alphabet_is_valid", `Quick, test_custom_alphabet_is_valid)
  ]

let () = Alcotest.run "Iso7064.Mod_37_36" [ ("suite", suite) ]
