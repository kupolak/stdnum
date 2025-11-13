let test_compact () =
  let test_cases =
    [
      ("A12425GABC1234002M", "A12425GABC1234002M")
    ; ("Grid: A1-2425G-ABC1234002-M", "A12425GABC1234002M")
    ; ("A1-2425G-ABC1234002-M", "A12425GABC1234002M")
    ; ("a1 2425g abc1234002 m", "A12425GABC1234002M")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Grid.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ "A12425GABC1234002M"; "A1-2425G-ABC1234002-M" ] in
  List.iter
    (fun input ->
      try
        let result = Stdnum.Grid.validate input in
        let expected = Stdnum.Grid.compact input in
        Alcotest.(check string) ("test_validate_" ^ input) expected result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_length () =
  (* Too short *)
  try
    ignore (Stdnum.Grid.validate "A12425GABC1234002");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Grid.Invalid_length -> ()

let test_validate_invalid_checksum () =
  (* Wrong check digit *)
  try
    ignore (Stdnum.Grid.validate "A1-2425G-ABC1234002-Q");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Grid.Invalid_checksum -> ()

let test_format () =
  let test_cases = [ ("A12425GABC1234002M", "A1-2425G-ABC1234002-M") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Grid.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("A12425GABC1234002M", true)
    ; ("Grid: A1-2425G-ABC1234002-M", true)
    ; ("A1-2425G-ABC1234002-Q", false) (* Wrong checksum *)
    ; ("A12425GABC1234002", false) (* Too short *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Grid.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_format", `Quick, test_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Grid" [ ("suite", suite) ]
