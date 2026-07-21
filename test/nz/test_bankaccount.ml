let test_compact () =
  let result = Nz.Bankaccount.compact " 01-0242-0100194-00 " in
  Alcotest.(check string) "test_compact" "0102420100194000" result

let test_validate () =
  let result = Nz.Bankaccount.validate "01-0242-0100194-00" in
  Alcotest.(check string) "test_validate" "0102420100194000" result

let test_validate_invalid_checksum () =
  try
    ignore (Nz.Bankaccount.validate "01-0242-0100195-00");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Nz.Bankaccount.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [ ("01-0242-0100194-00", true); ("01-0242-0100195-00", false) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nz.Bankaccount.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Nz.Bankaccount.format "0102420100194000" in
  Alcotest.(check string) "test_format" "01-0242-0100194-000" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Nz.Bankaccount" [ ("suite", suite) ]
