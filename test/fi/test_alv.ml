let test_compact () =
  let result = Fi.Alv.compact " FI 20774740 " in
  Alcotest.(check string) "test_compact" "20774740" result

let test_validate () =
  let result = Fi.Alv.validate "FI 20774740" in
  Alcotest.(check string) "test_validate" "20774740" result

let test_validate_invalid_checksum () =
  try
    ignore (Fi.Alv.validate "FI 20774741");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fi.Alv.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases = [ ("FI 20774740", true); ("FI 20774741", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Fi.Alv.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Fi.Alv" [ ("suite", suite) ]
