let test_compact () =
  let test_cases =
    [
      ("A0MNRK", "A0MNRK")
    ; ("a0mnrk", "A0MNRK")
    ; ("A0 MNRK", "A0MNRK")
    ; ("SKWM02", "SKWM02")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De_stdnum.Wkn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [ ("A0MNRK", "A0MNRK"); ("SKWM02", "SKWM02"); ("840400", "840400") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De_stdnum.Wkn.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("A0MNRK", true) (* Valid *)
    ; ("SKWM02", true) (* Valid *)
    ; ("840400", true) (* Valid *)
    ; ("AOMNRK", false) (* Capital O not allowed *)
    ; ("A0MNRI", false) (* Capital I not allowed *)
    ; ("A0MNR", false) (* Too short *)
    ; ("A0MNRK1", false) (* Too long *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De_stdnum.Wkn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_to_isin () =
  let test_cases = [ ("SKWM02", "DE000SKWM021") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = De_stdnum.Wkn.to_isin input in
      Alcotest.(check string) ("test_to_isin_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_to_isin", `Quick, test_to_isin)
  ]

let () = Alcotest.run "De_stdnum.Wkn" [ ("suite", suite) ]
