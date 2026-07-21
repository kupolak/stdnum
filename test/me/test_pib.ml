let test_compact () =
  let result = Me.Pib.compact " 02655284 " in
  Alcotest.(check string) "test_compact" "02655284" result

let test_validate () =
  let result = Me.Pib.validate "02655284" in
  Alcotest.(check string) "test_validate" "02655284" result

let test_validate_invalid_checksum () =
  try
    ignore (Me.Pib.validate "02655283");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Me.Pib.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("02655284", true)
    ; ("02655283", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Me.Pib.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Me.Pib.format "02655284" in
  Alcotest.(check string) "test_format" "02655284" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Me.Pib" [ ("suite", suite) ]
