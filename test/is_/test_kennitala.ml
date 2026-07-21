let test_compact () =
  let result = Is_.Kennitala.compact " 450401-3150 " in
  Alcotest.(check string) "test_compact" "4504013150" result

let test_validate_org () =
  let result = Is_.Kennitala.validate "450401-3150" in
  Alcotest.(check string) "test_validate_org" "4504013150" result

let test_validate_ind () =
  let result = Is_.Kennitala.validate "120174-3399" in
  Alcotest.(check string) "test_validate_ind" "1201743399" result

let test_validate_invalid_checksum () =
  try
    ignore (Is_.Kennitala.validate "530575-0299");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Is_.Kennitala.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Is_.Kennitala.validate "320174-3399");
    Alcotest.fail "Expected Invalid_component exception"
  with Is_.Kennitala.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("450401-3150", true)
    ; ("120174-3399", true)
    ; ("530575-0299", false)
    ; ("320174-3399", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Is_.Kennitala.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Is_.Kennitala.format "1201743399" in
  Alcotest.(check string) "test_format" "120174-3399" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_org", `Quick, test_validate_org)
  ; ("test_validate_ind", `Quick, test_validate_ind)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Is_.Kennitala" [ ("suite", suite) ]
