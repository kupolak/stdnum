let test_compact () =
  let result = Fi.Veronumero.compact " 123456789123 " in
  Alcotest.(check string) "test_compact" "123456789123" result

let test_validate () =
  let result = Fi.Veronumero.validate "123456789123" in
  Alcotest.(check string) "test_validate" "123456789123" result

let test_validate_invalid_length () =
  try
    ignore (Fi.Veronumero.validate "123456789");
    Alcotest.fail "Expected Invalid_length exception"
  with Fi.Veronumero.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Fi.Veronumero.validate "12345678912A");
    Alcotest.fail "Expected Invalid_format exception"
  with Fi.Veronumero.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("123456789123", true)
    ; ("123456789", false)
    ; ("12345678912A", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fi.Veronumero.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Fi.Veronumero" [ ("suite", suite) ]
