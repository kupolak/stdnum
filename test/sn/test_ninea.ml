let test_compact () =
  let result = Sn.Ninea.compact " 306 7221 " in
  Alcotest.(check string) "test_compact" "3067221" result

let test_validate () =
  let result = Sn.Ninea.validate "306 7221" in
  Alcotest.(check string) "test_validate" "3067221" result

let test_validate_cofi_1 () =
  let result = Sn.Ninea.validate "30672212G2" in
  Alcotest.(check string) "test_validate_cofi_1" "30672212G2" result

let test_validate_cofi_2 () =
  let result = Sn.Ninea.validate "3067221 2G2" in
  Alcotest.(check string) "test_validate_cofi_2" "30672212G2" result

let test_validate_invalid_checksum () =
  try
    ignore (Sn.Ninea.validate "3067222");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Sn.Ninea.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Sn.Ninea.validate "1234567 0AZ");
    Alcotest.fail "Expected Invalid_component exception"
  with Sn.Ninea.Invalid_component -> ()

let test_format () =
  let result = Sn.Ninea.format "30672212G2" in
  Alcotest.(check string) "test_format" "3067221 2G2" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_cofi_1", `Quick, test_validate_cofi_1)
  ; ("test_validate_cofi_2", `Quick, test_validate_cofi_2)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Sn.Ninea" [ ("suite", suite) ]
