let test_compact () =
  let result = At.Postleitzahl.compact " 5090 " in
  Alcotest.(check string) "test_compact" "5090" result

let test_validate () =
  let result = At.Postleitzahl.validate "5090" in
  Alcotest.(check string) "test_validate" "5090" result

let test_validate_invalid_format () =
  try
    ignore (At.Postleitzahl.validate "ABCD");
    Alcotest.fail "Expected Invalid_format exception"
  with At.Postleitzahl.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (At.Postleitzahl.validate "509");
    Alcotest.fail "Expected Invalid_length exception"
  with At.Postleitzahl.Invalid_length -> ()

let test_validate_invalid_component () =
  try
    ignore (At.Postleitzahl.validate "4231");
    Alcotest.fail "Expected Invalid_component exception"
  with At.Postleitzahl.Invalid_component -> ()

let test_is_valid () =
  Alcotest.(check bool) "test_is_valid_true" true (At.Postleitzahl.is_valid "5090");
  Alcotest.(check bool) "test_is_valid_false" false (At.Postleitzahl.is_valid "4231")

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.At.Postleitzahl" [ ("suite", suite) ]
