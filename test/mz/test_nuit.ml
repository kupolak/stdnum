let test_compact () =
  let result = Mz.Nuit.compact " 400 339 910 " in
  Alcotest.(check string) "test_compact" "400339910" result

let test_validate () =
  let result1 = Mz.Nuit.validate "400339910" in
  Alcotest.(check string) "test_validate_1" "400339910" result1;
  let result2 = Mz.Nuit.validate "400 005 834" in
  Alcotest.(check string) "test_validate_2" "400005834" result2

let test_validate_invalid_length () =
  try
    ignore (Mz.Nuit.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Mz.Nuit.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("400339910", true)
    ; ("400 005 834", true)
    ; ("12345", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Mz.Nuit.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Mz.Nuit.format "400339910" in
  Alcotest.(check string) "test_format" "400 339 910" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Mz.Nuit" [ ("suite", suite) ]
