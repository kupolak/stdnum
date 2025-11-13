let test_compact () =
  let test_cases =
    [
      ("DE 136,695 976", "136695976")
    ; ("DE136695976", "136695976")
    ; ("136695976", "136695976")
    ; ("DE 136 695 976", "136695976")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Vat.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [ ("DE136695976", "136695976"); ("136695976", "136695976") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Vat.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("DE 136,695 976", true) (* Valid *)
    ; ("DE136695976", true) (* Valid *)
    ; ("136695976", true) (* Valid without prefix *)
    ; ("136695978", false) (* Invalid checksum *)
    ; ("036695976", false) (* Starts with 0 *)
    ; ("13669597", false) (* Too short *)
    ; ("1366959760", false) (* Too long *)
    ; ("13669597A", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "De.Vat" [ ("suite", suite) ]
