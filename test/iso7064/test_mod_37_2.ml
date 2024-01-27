let test_checksum () =
  let result = Iso7064.Mod_37_2.checksum "G123489654321Y" in
  Alcotest.(check int) "checksum" 1 result;
  let result = Iso7064.Mod_37_2.checksum ~alphabet:"0123456789X" "079X" in
  Alcotest.(check int) "checksum with custom alphabet" 1 result

let test_calc_check_digit () =
  let result = Iso7064.Mod_37_2.calc_check_digit "G123489654321" in
  Alcotest.(check char) "check digit" 'Y' result;
  let result =
    Iso7064.Mod_37_2.calc_check_digit ~alphabet:"0123456789X" "079"
  in
  Alcotest.(check char) "check digit with custom alphabet" 'X' result

let test_valid_number () =
  let result = Iso7064.Mod_37_2.validate "G123489654321Y" in
  Alcotest.(check string) "valid number" "G123489654321Y" result

let test_invalid_number () =
  Alcotest.check_raises "raises Invalid_checksum"
    Iso7064.Mod_37_2.Invalid_checksum (fun () ->
      ignore (Iso7064.Mod_37_2.validate "ABCDE"));
  Alcotest.check_raises "raises Invalid_checksum 2"
    Iso7064.Mod_37_2.Invalid_checksum (fun () ->
      ignore (Iso7064.Mod_37_2.validate "1234567890"));
  Alcotest.check_raises "raises Invalid_checksum 3"
    Iso7064.Mod_37_2.Invalid_checksum (fun () ->
      ignore (Iso7064.Mod_37_2.validate "A1234567890"))

let suite =
  [
    ("test_checksum", `Quick, test_checksum)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_valid_number", `Quick, test_valid_number)
  ; ("test_invalid_number", `Quick, test_invalid_number)
  ]

let () = Alcotest.run "Iso7064.Mod_37_2" [ ("suite", suite) ]
