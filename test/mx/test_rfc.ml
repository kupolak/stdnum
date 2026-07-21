let test_compact () =
  let result = Mx.Rfc.compact " GODE 561231 GR8 " in
  Alcotest.(check string) "test_compact" "GODE561231GR8" result

let test_validate () =
  let result1 = Mx.Rfc.validate "GODE 561231 GR8" in
  Alcotest.(check string) "test_validate_personal" "GODE561231GR8" result1;
  let result2 = Mx.Rfc.validate "MAB-930714-8T4" in
  Alcotest.(check string) "test_validate_company" "MAB9307148T4" result2;
  let result3 = Mx.Rfc.validate "COMG-600703" in
  Alcotest.(check string)
    "test_validate_personal_no_serial" "COMG600703" result3;
  let result4 = Mx.Rfc.validate "VACE-460910-SX6" in
  Alcotest.(check string)
    "test_validate_invalid_checksum_allowed" "VACE460910SX6" result4

let test_validate_invalid_checksum () =
  try
    ignore (Mx.Rfc.validate ~validate_check_digits:true "VACE-460910-SX6");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Mx.Rfc.Invalid_checksum -> ()

let test_format () =
  let result = Mx.Rfc.format "GODE561231GR8" in
  Alcotest.(check string) "test_format" "GODE 561231 GR8" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Mx.Rfc" [ ("suite", suite) ]
