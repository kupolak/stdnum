let test_checksum_valid () =
  let result = Tools.Luhn.checksum "78949" in
  Alcotest.(check int) "test_checksum_valid" 0 result

let test_checksum_invalid () =
  let result = Tools.Luhn.checksum "7894" in
  Alcotest.(check int) "test_checksum_invalid" 6 result

let test_calc_check_digit () =
  let result = Tools.Luhn.calc_check_digit "7894" in
  Alcotest.(check string) "test_calc_check_digit" "9" result

let test_validate_valid () =
  let result = Tools.Luhn.validate "78949" in
  Alcotest.(check string) "test_validate_valid" "78949" result

let test_validate_invalid () =
  Alcotest.check_raises "Invalid Checksum" Tools.Luhn.Invalid_checksum
    (fun () -> ignore (Tools.Luhn.validate "7894"))

let test_validate_empty () =
  Alcotest.check_raises "Invalid Format" Tools.Luhn.Invalid_format (fun () ->
      ignore (Tools.Luhn.validate ""))

let test_is_valid_true () =
  let result = Tools.Luhn.is_valid "78949" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Tools.Luhn.is_valid "7894" in
  Alcotest.(check bool) "test_is_valid_false" false result

(* Test with custom alphabet (hex) *)
let test_checksum_hex () =
  let result = Tools.Luhn.checksum ~alphabet:"0123456789abcdef" "1234" in
  Alcotest.(check int) "test_checksum_hex" 14 result

let test_validate_hex_invalid () =
  Alcotest.check_raises "Invalid Checksum" Tools.Luhn.Invalid_checksum
    (fun () -> ignore (Tools.Luhn.validate ~alphabet:"0123456789abcdef" "1234"))

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
  ; ("test_checksum_hex", `Quick, test_checksum_hex)
  ; ("test_validate_hex_invalid", `Quick, test_validate_hex_invalid)
  ]

let () = Alcotest.run "Tools.Luhn" [ ("suite", suite) ]
