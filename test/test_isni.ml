let test_compact () =
  let test_cases = [ ("0000 0001 2281 955X", "000000012281955X") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isni.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("0000 0001 2281 955X", "000000012281955X") ] in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Isni.validate input in
        Alcotest.(check string)
          ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Isni.validate "0000 0001 1111 955X");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Isni.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Isni.validate "0000 0001 2281");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Isni.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Isni.validate "0000 0001 2281 955A");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Isni.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("0000 0001 2281 955X", true)
    ; ("0000 0001 1111 955X", false)
    ; ("0000 0001 2281", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isni.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases = [ ("000000012281955X", "0000 0001 2281 955X") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isni.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Isni" [ ("suite", suite) ]
