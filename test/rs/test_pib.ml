let test_compact () =
  let result = Rs.Pib.compact " 101134702 " in
  Alcotest.(check string) "test_compact" "101134702" result

let test_validate () =
  let result = Rs.Pib.validate "101134702" in
  Alcotest.(check string) "test_validate" "101134702" result

let test_validate_invalid_checksum () =
  try
    ignore (Rs.Pib.validate "101134703");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Rs.Pib.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Rs.Pib.validate "10113470");
    Alcotest.fail "Expected Invalid_length exception"
  with Rs.Pib.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Rs.Pib.validate "10113470A");
    Alcotest.fail "Expected Invalid_format exception"
  with Rs.Pib.Invalid_format -> ()

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ]

let () = Alcotest.run "Stdnum.Rs.Pib" [ ("suite", suite) ]
