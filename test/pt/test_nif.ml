let test_compact () =
  let result = Pt.Nif.compact " PT 501 964 843 " in
  Alcotest.(check string) "test_compact" "501964843" result

let test_calc_check_digit () =
  let result = Pt.Nif.calc_check_digit "50196484" in
  Alcotest.(check string) "test_calc_check_digit" "3" result

let test_validate () =
  let result = Pt.Nif.validate "PT 501 964 843" in
  Alcotest.(check string) "test_validate" "501964843" result

let test_validate_invalid_checksum () =
  try
    ignore (Pt.Nif.validate "PT 501 964 842");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Pt.Nif.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Pt.Nif.validate "0501964843");
    Alcotest.fail "Expected Invalid_format exception"
  with Pt.Nif.Invalid_format -> ()

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ]

let () = Alcotest.run "Stdnum.Pt.Nif" [ ("suite", suite) ]
