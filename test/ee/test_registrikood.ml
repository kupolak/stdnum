let test_compact () =
  let result = Ee.Registrikood.compact " 12345678 " in
  Alcotest.(check string) "test_compact" "12345678" result

let test_validate () =
  let result = Ee.Registrikood.validate "12345678" in
  Alcotest.(check string) "test_validate" "12345678" result

let test_validate_invalid_checksum () =
  try
    ignore (Ee.Registrikood.validate "12345679");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ee.Registrikood.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Ee.Registrikood.validate "32345674");
    Alcotest.fail "Expected Invalid_component exception"
  with Ee.Registrikood.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [ ("12345678", true); ("12345679", false); ("32345674", false) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ee.Registrikood.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Ee.Registrikood" [ ("suite", suite) ]
