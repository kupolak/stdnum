let test_compact () =
  let result = Gn.Nifp.compact " 693-770-885 " in
  Alcotest.(check string) "test_compact" "693770885" result

let test_validate () =
  let result = Gn.Nifp.validate "693770885" in
  Alcotest.(check string) "test_validate" "693770885" result

let test_validate_invalid_length () =
  try
    ignore (Gn.Nifp.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Gn.Nifp.Invalid_length -> ()

let test_validate_invalid_checksum () =
  try
    ignore (Gn.Nifp.validate "693770880");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gn.Nifp.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("693770885", true)
    ; ("693-770-885", true)
    ; ("12345", false)
    ; ("693770880", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gn.Nifp.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Gn.Nifp.format "693770885" in
  Alcotest.(check string) "test_format" "693-770-885" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Gn.Nifp" [ ("suite", suite) ]
