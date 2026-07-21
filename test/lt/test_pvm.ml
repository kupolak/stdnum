let test_compact () =
  let result = Lt.Pvm.compact " LT 100001919017 " in
  Alcotest.(check string) "test_compact" "100001919017" result

let test_validate () =
  let result1 = Lt.Pvm.validate "119511515" in
  Alcotest.(check string) "test_validate_org" "119511515" result1;
  let result2 = Lt.Pvm.validate "LT 100001919017" in
  Alcotest.(check string) "test_validate_temp" "100001919017" result2;
  let result3 = Lt.Pvm.validate "100004801610" in
  Alcotest.(check string) "test_validate_second_step" "100004801610" result3

let test_validate_invalid_length () =
  try
    ignore (Lt.Pvm.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Lt.Pvm.Invalid_length -> ()

let test_validate_invalid_checksum () =
  try
    ignore (Lt.Pvm.validate "100001919018");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Lt.Pvm.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("119511515", true)
    ; ("LT 100001919017", true)
    ; ("100004801610", true)
    ; ("100001919018", false)
    ; ("12345", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Lt.Pvm.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Lt.Pvm" [ ("suite", suite) ]
