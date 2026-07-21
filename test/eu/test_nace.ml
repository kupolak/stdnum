let test_compact () =
  let result = Eu.Nace.compact " 62.01 " in
  Alcotest.(check string) "test_compact" "6201" result

let test_validate () =
  let result1 = Eu.Nace.validate "A" in
  Alcotest.(check string) "test_validate_1" "A" result1;
  let result2 = Eu.Nace.validate "62.01" in
  Alcotest.(check string) "test_validate_2" "6201" result2

let test_validate_invalid_length () =
  try
    ignore (Eu.Nace.validate "62059");
    Alcotest.fail "Expected Invalid_length exception"
  with Eu.Nace.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("A", true)
    ; ("62.01", true)
    ; ("62059", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Eu.Nace.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Eu.Nace.format "6201" in
  Alcotest.(check string) "test_format" "62.01" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Eu.Nace" [ ("suite", suite) ]
