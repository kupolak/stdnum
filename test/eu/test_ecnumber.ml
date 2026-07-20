let test_compact () =
  let result = Eu.Ecnumber.compact " 2000018 " in
  Alcotest.(check string) "test_compact_1" "200-001-8" result;
  let result2 = Eu.Ecnumber.compact " 200-001-8 " in
  Alcotest.(check string) "test_compact_2" "200-001-8" result2

let test_validate () =
  let result = Eu.Ecnumber.validate "200-001-8" in
  Alcotest.(check string) "test_validate" "200-001-8" result

let test_validate_invalid_checksum () =
  try
    ignore (Eu.Ecnumber.validate "200-001-9");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Eu.Ecnumber.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Eu.Ecnumber.validate "20-0001-8");
    Alcotest.fail "Expected Invalid_format exception"
  with Eu.Ecnumber.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("200-001-8", true)
    ; ("200-001-9", false)
    ; ("20-0001-8", false)
    ; ("2000018", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Eu.Ecnumber.is_valid input in
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

let () = Alcotest.run "Stdnum.Eu.Ecnumber" [ ("suite", suite) ]
