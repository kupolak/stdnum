let test_checksum () =
  let result = Stdnum.Verhoeff.checksum "1234" in
  Alcotest.(check int) "test_checksum" 1 result

let test_calc_check_digit () =
  let result = Stdnum.Verhoeff.calc_check_digit "1234" in
  Alcotest.(check string) "test_calc_check_digit" "0" result

let test_validate () =
  let result = Stdnum.Verhoeff.validate "12340" in
  Alcotest.(check string) "test_validate" "12340" result

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Verhoeff.validate "1234");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Verhoeff.Invalid_checksum -> ()

let suite =
  [
    ("test_checksum", `Quick, test_checksum)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ]

let () = Alcotest.run "Stdnum.Verhoeff" [ ("suite", suite) ]
