let test_compact () =
  let test_cases = [ ("US-SKG-19-12345", "USSKG1912345") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isrc.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("US-SKG-19-12345", "USSKG1912345") ] in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Isrc.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_component () =
  try
    ignore (Stdnum.Isrc.validate "XX-SKG-19-12345");
    Alcotest.fail "Expected Invalid_component exception"
  with Stdnum.Isrc.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Isrc.validate "US-SKG-19-1234");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Isrc.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Isrc.validate "U1-SKG-19-12345");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Isrc.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("US-SKG-19-12345", true)
    ; ("XX-SKG-19-12345", false)
    ; ("US-SKG-19-1234", false)
    ; ("U1-SKG-19-12345", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isrc.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases = [ ("USSKG1912345", "US-SKG-19-12345") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isrc.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Isrc" [ ("suite", suite) ]
