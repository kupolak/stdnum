let test_validate () =
  let result = Me.Iban.validate "ME 2551 0000 0000 0623 4133" in
  Alcotest.(check string) "test_validate" "ME25510000000006234133" result

let test_validate_invalid_checksum () =
  try
    ignore (Me.Iban.validate "ME52510000000006234132");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Me.Iban.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Me.Iban.validate "GR1601101050000010547023795");
    Alcotest.fail "Expected Invalid_component exception"
  with Me.Iban.Invalid_component -> ()

let suite =
  [
    ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ]

let () = Alcotest.run "Stdnum.Me.Iban" [ ("suite", suite) ]
