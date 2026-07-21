let test_compact () =
  let result = My.Nric.compact " 770305-02-1234 " in
  Alcotest.(check string) "test_compact" "770305021234" result

let test_validate () =
  let result = My.Nric.validate "770305-02-1234" in
  Alcotest.(check string) "test_validate" "770305021234" result

let test_validate_invalid_date () =
  try
    ignore (My.Nric.validate "771305-02-1234");
    Alcotest.fail "Expected Invalid_component exception"
  with My.Nric.Invalid_component -> ()

let test_validate_invalid_place () =
  try
    ignore (My.Nric.validate "770305-17-1234");
    Alcotest.fail "Expected Invalid_component exception"
  with My.Nric.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("770305-02-1234", true)
    ; ("771305-02-1234", false)
    ; ("770305-17-1234", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = My.Nric.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = My.Nric.format "770305021234" in
  Alcotest.(check string) "test_format" "770305-02-1234" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_date", `Quick, test_validate_invalid_date)
  ; ("test_validate_invalid_place", `Quick, test_validate_invalid_place)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.My.Nric" [ ("suite", suite) ]
