let test_compact () =
  let test_cases = [ ("US 037833 10 05", "US0378331005") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Isin_core.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("US0378331005", "US0378331005") ] in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Isin_core.validate input in
        Alcotest.(check string)
          ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Isin_core.validate "US0378331003");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Isin_core.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Isin_core.validate "US037833100");
    Alcotest.fail "Expected Invalid_length exception"
  with Isin_core.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Isin_core.validate "US037833100-");
    Alcotest.fail "Expected Invalid_format exception"
  with Isin_core.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (Isin_core.validate "ZZ0378331004");
    Alcotest.fail "Expected Invalid_component exception"
  with Isin_core.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("US0378331005", true)
    ; ("US0378331003", false)
    ; ("US037833100", false)
    ; ("US037833100-", false)
    ; ("ZZ0378331004", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Isin_core.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_from_natid () =
  let test_cases = [ (("gb", "BYXJL75"), "GB00BYXJL758") ] in
  List.iter
    (fun ((country, natid), expected_result) ->
      let result = Isin_core.from_natid country natid in
      Alcotest.(check string)
        ("test_from_natid_" ^ country ^ "_" ^ natid)
        expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_from_natid", `Quick, test_from_natid)
  ]

let () = Alcotest.run "Isin_core" [ ("suite", suite) ]
