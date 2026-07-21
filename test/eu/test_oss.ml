let test_compact () =
  let result = Eu.Oss.compact " EU 372022452 " in
  Alcotest.(check string) "test_compact" "EU372022452" result

let test_validate () =
  let result = Eu.Oss.validate "EU 372022452" in
  Alcotest.(check string) "test_validate" "EU372022452" result

let test_validate_invalid_length () =
  try
    ignore (Eu.Oss.validate "EU37202245");
    Alcotest.fail "Expected Invalid_length exception"
  with Eu.Oss.Invalid_length -> ()

let test_validate_invalid_component () =
  try
    ignore (Eu.Oss.validate "US372022452");
    Alcotest.fail "Expected Invalid_component exception"
  with Eu.Oss.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("EU 372022452", true)
    ; ("EU37202245", false)
    ; ("US372022452", false)
    ; ("IM3720224520", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Eu.Oss.is_valid input in
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

let () = Alcotest.run "Stdnum.Eu.Oss" [ ("suite", suite) ]
