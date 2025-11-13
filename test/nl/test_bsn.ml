let test_compact () =
  let test_cases =
    [
      ("1112.22.333", "111222333")
    ; ("111222333", "111222333")
    ; ("111 222 333", "111222333")
    ; ("11122233", "011122233") (* Pad with leading zero *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Bsn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_checksum () =
  let test_cases = [ ("111222333", 0); ("111252333", 4) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Bsn.checksum input in
      Alcotest.(check int) ("test_checksum_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("1112.22.333", "111222333") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Bsn.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("1112.22.333", true) (* Valid *)
    ; ("111222333", true) (* Valid without formatting *)
    ; ("1112.52.333", false) (* Invalid checksum *)
    ; ("1112223334", false) (* Invalid length (10 digits) *)
    ; ("111222A33", false) (* Invalid format *)
    ; ("000000000", false) (* Zero is invalid *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Bsn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("111222333", "1112.22.333"); ("1112.22.333", "1112.22.333") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl_stdnum.Bsn.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Nl_stdnum.Bsn" [ ("suite", suite) ]
