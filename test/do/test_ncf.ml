let test_compact () =
  let test_cases =
    [
      ("E310000000005", "E310000000005") (* e-CF format since 2019-04-08 *)
    ; ("B0100000005", "B0100000005") (* format since 2018-05-01 *)
    ; ("A020010210100000005", "A020010210100000005")
      (* format before 2018-05-01 *)
    ; ("E31 0000000005", "E310000000005")
    ; ("a020010210100000005", "A020010210100000005")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do_stdnum.Ncf.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("E310000000005", "E310000000005") (* e-CF valid *)
    ; ("B0100000005", "B0100000005") (* B format valid *)
    ; ("A020010210100000005", "A020010210100000005") (* A format valid *)
    ; ("P020010210100000005", "P020010210100000005") (* P format valid *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do_stdnum.Ncf.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("E310000000005", true) (* Valid e-CF *)
    ; ("B0100000005", true) (* Valid B format *)
    ; ("A020010210100000005", true) (* Valid A format *)
    ; ("Z0100000005", false) (* Invalid starting letter *)
    ; ("E990000000005", false) (* Invalid document type for e-CF *)
    ; ("B9900000005", false) (* Invalid document type for B format *)
    ; ("12345", false) (* Invalid length *)
    ; ("E31000000000A", false) (* Invalid format (letter in digits) *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do_stdnum.Ncf.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Do_stdnum.Ncf" [ ("suite", suite) ]
