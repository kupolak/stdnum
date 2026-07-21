let test_compact () =
  let result = Pe.Cui.compact " 10117410-2 " in
  Alcotest.(check string) "test_compact" "101174102" result

let test_validate () =
  let result1 = Pe.Cui.validate "10117410" in
  Alcotest.(check string) "test_validate_1" "10117410" result1;
  let result2 = Pe.Cui.validate "10117410-2" in
  Alcotest.(check string) "test_validate_2" "101174102" result2

let test_validate_invalid_checksum () =
  try
    ignore (Pe.Cui.validate "10117410-3");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Pe.Cui.Invalid_checksum -> ()

let test_to_ruc () =
  let result = Pe.Cui.to_ruc "10117410-2" in
  Alcotest.(check string) "test_to_ruc" "10101174102" result

let test_is_valid () =
  let test_cases =
    [
      ("10117410", true)
    ; ("10117410-2", true)
    ; ("10117410-3", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pe.Cui.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_to_ruc", `Quick, test_to_ruc)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Pe.Cui" [ ("suite", suite) ]
