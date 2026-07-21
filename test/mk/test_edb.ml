let test_compact () =
  let result = Mk.Edb.compact " 4030000375897 " in
  Alcotest.(check string) "test_compact" "4030000375897" result

let test_validate () =
  let result1 = Mk.Edb.validate "4030000375897" in
  Alcotest.(check string) "test_validate_1" "4030000375897" result1;
  let result2 = Mk.Edb.validate "МК 4020990116747" in
  Alcotest.(check string) "test_validate_cyrillic" "4020990116747" result2;
  let result3 = Mk.Edb.validate "MK4057009501106" in
  Alcotest.(check string) "test_validate_ascii" "4057009501106" result3

let test_validate_invalid_checksum () =
  try
    ignore (Mk.Edb.validate "4030000375890");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Mk.Edb.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("4030000375897", true)
    ; ("МК 4020990116747", true)
    ; ("MK4057009501106", true)
    ; ("4030000375890", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Mk.Edb.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result1 = Mk.Edb.format "МК 4020990116747" in
  Alcotest.(check string) "test_format_cyrillic" "4020990116747" result1;
  let result2 = Mk.Edb.format "MK4057009501106" in
  Alcotest.(check string) "test_format_ascii" "4057009501106" result2

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Mk.Edb" [ ("suite", suite) ]
