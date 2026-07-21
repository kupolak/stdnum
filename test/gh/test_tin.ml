let test_compact () =
  let result = Gh.Tin.compact " C0000803561 " in
  Alcotest.(check string) "test_compact" "C0000803561" result

let test_validate () =
  let result = Gh.Tin.validate "C0000803561" in
  Alcotest.(check string) "test_validate" "C0000803561" result

let test_validate_invalid_checksum () =
  try
    ignore (Gh.Tin.validate "C0000803562");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gh.Tin.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("C0000803561", true)
    ; ("C0000803562", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gh.Tin.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Gh.Tin" [ ("suite", suite) ]
