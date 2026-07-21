let test_compact () =
  let result = Pt.Cc.compact " 00000000 0 ZZ4 " in
  Alcotest.(check string) "test_compact" "000000000ZZ4" result

let test_validate () =
  let result = Pt.Cc.validate "00000000 0 ZZ4" in
  Alcotest.(check string) "test_validate" "000000000ZZ4" result

let test_format () =
  let result = Pt.Cc.format "000000000ZZ4" in
  Alcotest.(check string) "test_format" "00000000 0 ZZ4" result

let test_validate_invalid_format () =
  try
    ignore (Pt.Cc.validate "00000000 A ZZ4");
    Alcotest.fail "Expected Invalid_format exception"
  with Pt.Cc.Invalid_format -> ()

let test_validate_invalid_checksum () =
  try
    ignore (Pt.Cc.validate "00000000 0 ZZ3");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Pt.Cc.Invalid_checksum -> ()

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ]

let () = Alcotest.run "Stdnum.Pt.Cc" [ ("suite", suite) ]
