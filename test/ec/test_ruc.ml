let test_compact () =
  let result = Ec.Ruc.compact " 1792060346-001 " in
  Alcotest.(check string) "test_compact" "1792060346001" result

let test_validate () =
  let result = Ec.Ruc.validate "1792060346-001" in
  Alcotest.(check string) "test_validate" "1792060346001" result

let test_validate_invalid_checksum () =
  try
    ignore (Ec.Ruc.validate "1763154690001");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ec.Ruc.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Ec.Ruc.validate "179206034601");
    Alcotest.fail "Expected Invalid_length exception"
  with Ec.Ruc.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("1792060346-001", true); ("1763154690001", false); ("179206034601", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ec.Ruc.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Ec.Ruc" [ ("suite", suite) ]
