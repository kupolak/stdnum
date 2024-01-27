let test_to_base10 () =
  let result = Iso7064.Mod_97_10.to_base10 "16122348495643231" in
  Alcotest.(check string) "to_base10" "16122348495643231" result

let test_checksum () =
  let result = Iso7064.Mod_97_10.checksum "16122348495643231" in
  Alcotest.(check int) "checksum" 31 result

let test_calc_check_digits () =
  let result = Iso7064.Mod_97_10.calc_check_digits "4354111611551114" in
  Alcotest.(check string) "calc_check_digits" "31" result

let test_validate () =
  let result = Iso7064.Mod_97_10.validate "71616009861" in
  Alcotest.(check string) "validate" "71616009861" result

let test_is_valid () =
  let result = Iso7064.Mod_97_10.is_valid "030633417226" in
  Alcotest.(check bool) "is_valid" true result;
  let result = Iso7064.Mod_97_10.is_valid "G123489654321Z" in
  Alcotest.(check bool) "is_valid" false result

let suite =
  [
    ("test_to_base10", `Quick, test_to_base10)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Iso7064.Mod_37_2" [ ("suite", suite) ]
