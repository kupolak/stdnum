let test_compact () =
  let result = Eu.Excise.compact " LU 987ABC " in
  Alcotest.(check string) "test_compact" "LU00000987ABC" result

let test_validate () =
  let result = Eu.Excise.validate "LU 987ABC" in
  Alcotest.(check string) "test_validate" "LU00000987ABC" result

let test_validate_invalid_length () =
  try
    ignore (Eu.Excise.validate "LU12345678901234");
    Alcotest.fail "Expected Invalid_length exception"
  with Eu.Excise.Invalid_length -> ()

let test_validate_invalid_component () =
  try
    ignore (Eu.Excise.validate "US00000987ABC");
    Alcotest.fail "Expected Invalid_component exception"
  with Eu.Excise.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("LU 987ABC", true)
    ; ("LU987ABC", true)
    ; ("LU12345678901234", false)
    ; ("US00000987ABC", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Eu.Excise.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Eu.Excise" [ ("suite", suite) ]
