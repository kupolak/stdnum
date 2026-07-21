let test_compact () =
  let result = Fi.Associationid.compact " 123.123 " in
  Alcotest.(check string) "test_compact" "123123" result

let test_validate () =
  let result1 = Fi.Associationid.validate "123.123" in
  Alcotest.(check string) "test_validate_1" "123123" result1;
  let result2 = Fi.Associationid.validate "1123" in
  Alcotest.(check string) "test_validate_2" "1123" result2

let test_validate_invalid_length () =
  try
    ignore (Fi.Associationid.validate "123123123");
    Alcotest.fail "Expected Invalid_length exception"
  with Fi.Associationid.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Fi.Associationid.validate "12df");
    Alcotest.fail "Expected Invalid_format exception"
  with Fi.Associationid.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("123.123", true)
    ; ("1123", true)
    ; ("123123123", false)
    ; ("12df", false)
    ; ("1", true)
    ; ("2", false) (* not in low_numbers *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fi.Associationid.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result1 = Fi.Associationid.format "123" in
  Alcotest.(check string) "test_format_1" "123" result1;
  let result2 = Fi.Associationid.format "1234" in
  Alcotest.(check string) "test_format_2" "1.234" result2

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Fi.Associationid" [ ("suite", suite) ]
