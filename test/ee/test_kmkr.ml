let test_compact () =
  let result = Ee.Kmkr.compact " EE 100 931 558 " in
  Alcotest.(check string) "test_compact" "100931558" result

let test_validate () =
  let result = Ee.Kmkr.validate "100594102" in
  Alcotest.(check string) "test_validate" "100594102" result

let test_validate_invalid_checksum () =
  try
    ignore (Ee.Kmkr.validate "100594103");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ee.Kmkr.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("EE 100 931 558", true)
    ; ("100594102", true)
    ; ("100594103", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ee.Kmkr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Ee.Kmkr" [ ("suite", suite) ]
