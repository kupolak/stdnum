let test_compact () =
  let test_cases = [ ("0032-1478", "00321478") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Issn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("0024-9319", "00249319") ] in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Issn.validate input in
        Alcotest.(check string)
          ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Issn.validate "0032147X");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Issn.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Issn.validate "003214712");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Issn.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [ ("0024-9319", true); ("0032147X", false); ("003214712", false) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Issn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases = [ ("00249319", "0024-9319") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Issn.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let test_to_ean () =
  let test_cases = [ ("0264-3596", "9770264359008") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Issn.to_ean input in
      Alcotest.(check string) ("test_to_ean_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ; ("test_to_ean", `Quick, test_to_ean)
  ]

let () = Alcotest.run "Stdnum.Issn" [ ("suite", suite) ]
