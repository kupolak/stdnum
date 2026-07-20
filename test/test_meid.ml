let test_validate () =
  let test_cases =
    [
      ("AF 01 23 45 0A BC DE C", "AF0123450ABCDE")
    ; ("29360 87365 0070 3710 0", "AF0123450ABCDE")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Meid.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_keep_cd () =
  let result = Stdnum.Meid.validate ~strip_check_digit:false "29360 87365 0070 3710 0" in
  Alcotest.(check string) "test_validate_keep_cd" "AF0123450ABCDEC" result

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Meid.validate "29360 87365 0070 3710 1");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Meid.Invalid_checksum -> ()

let test_format () =
  let test_cases =
    [
      ("af0123450abcDEC", "", true, "AF 01 23 45 0A BC DE C")
    ; ("af0123450abcDEC", "dec", true, "29360 87365 0070 3710 0")
    ]
  in
  List.iter
    (fun (input, fmt, add_check_digit, expected_result) ->
      let result = Stdnum.Meid.format ~fmt ~add_check_digit input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_validate", `Quick, test_validate)
  ; ("test_validate_keep_cd", `Quick, test_validate_keep_cd)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Meid" [ ("suite", suite) ]
