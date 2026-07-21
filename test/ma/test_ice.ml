let test_compact () =
  let result = Ma.Ice.compact "00 21 36 09 30 00 040" in
  Alcotest.(check string) "test_compact" "002136093000040" result

let test_validate () =
  let result1 = Ma.Ice.validate "001561191000066" in
  Alcotest.(check string) "test_validate_1" "001561191000066" result1;
  let result2 = Ma.Ice.validate "00 21 36 09 30 00 040" in
  Alcotest.(check string) "test_validate_2" "002136093000040" result2

let test_validate_invalid_length () =
  try
    ignore (Ma.Ice.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Ma.Ice.Invalid_length -> ()

let test_validate_invalid_checksum () =
  try
    ignore (Ma.Ice.validate "001561191000065");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ma.Ice.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("001561191000066", true)
    ; ("00 21 36 09 30 00 040", true)
    ; ("12345", false)
    ; ("001561191000065", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ma.Ice.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Ma.Ice.format "00 21 36 09 30 00 040" in
  Alcotest.(check string) "test_format" "002136093000040" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Ma.Ice" [ ("suite", suite) ]
