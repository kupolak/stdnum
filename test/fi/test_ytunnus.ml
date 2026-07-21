let test_compact () =
  let result = Fi.Ytunnus.compact " 2077474-0 " in
  Alcotest.(check string) "test_compact" "20774740" result

let test_validate () =
  let result = Fi.Ytunnus.validate "2077474-0" in
  Alcotest.(check string) "test_validate" "20774740" result

let test_validate_invalid_checksum () =
  try
    ignore (Fi.Ytunnus.validate "2077474-1");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fi.Ytunnus.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("2077474-0", true)
    ; ("2077474-1", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fi.Ytunnus.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Fi.Ytunnus.format "2077474-0" in
  Alcotest.(check string) "test_format" "2077474-0" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Fi.Ytunnus" [ ("suite", suite) ]
