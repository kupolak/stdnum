let test_compact () =
  let test_cases =
    [
      ("05 KO", "05KO")
    ; ("05KO", "05KO")
    ; ("07NU 00", "07NU00")
    ; ("07-NU-00", "07NU00")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Brin.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("05 KO", "05KO"); ("07NU 00", "07NU00") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Brin.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("05 KO", true) (* Valid 4-character *)
    ; ("07NU 00", true) (* Valid 6-character with location *)
    ; ("05KO", true) (* Valid without spaces *)
    ; ("12KB1", false) (* Invalid length (5) *)
    ; ("30AJ0A", false) (* Location code has letter *)
    ; ("1AKO", false) (* First position not digit *)
    ; ("0AKO", false) (* Second position not digit *)
    ; ("0512", false) (* Third position not letter *)
    ; ("05K2", false) (* Fourth position not letter *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nl.Brin.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Nl.Brin" [ ("suite", suite) ]
