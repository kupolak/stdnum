let test_compact () =
  let test_cases =
    [
      ("756.9217.0769.85", "7569217076985")
    ; ("7569217076985", "7569217076985")
    ; ("756 9217 0769 85", "7569217076985")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Ssn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("7569217076985", "7569217076985"); ("756.9217.0769.85", "7569217076985")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Ssn.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("7569217076985", true) (* Valid *)
    ; ("756.9217.0769.85", true) (* Valid with dots *)
    ; ("756.9217.0769.84", false) (* Invalid checksum *)
    ; ("123.4567.8910.19", false)
      (* Invalid component - doesn't start with 756 *)
    ; ("75692170769", false) (* Too short *)
    ; ("75692170769851", false) (* Too long *)
    ; ("756921707698A", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Ssn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("7569217076985", "756.9217.0769.85")
    ; ("756.9217.0769.85", "756.9217.0769.85")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Ssn.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Ch.Ssn" [ ("suite", suite) ]
