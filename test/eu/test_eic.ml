let test_compact () =
  let result = Eu.Eic.compact " 22XWATTPLUS----G " in
  Alcotest.(check string) "test_compact" "22XWATTPLUS----G" result

let test_validate () =
  let result = Eu.Eic.validate "22XWATTPLUS----G" in
  Alcotest.(check string) "test_validate" "22XWATTPLUS----G" result

let test_validate_invalid_checksum () =
  try
    ignore (Eu.Eic.validate "22XWATTPLUS----X");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Eu.Eic.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Eu.Eic.validate "23X--130302DLGW-");
    Alcotest.fail "Expected Invalid_format exception"
  with Eu.Eic.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("22XWATTPLUS----G", true)
    ; ("22XWATTPLUS----X", false)
    ; ("23X--130302DLGW-", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Eu.Eic.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Eu.Eic" [ ("suite", suite) ]
