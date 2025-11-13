let test_compact () =
  let test_cases =
    [
      ("36 574 261 809", "36574261809")
    ; ("36574261809", "36574261809")
    ; ("36-574-261-809", "36574261809")
    ; ("36.574.261.809", "36574261809")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De_stdnum.Idnr.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [ ("36 574 261 809", "36574261809"); ("36574261809", "36574261809") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De_stdnum.Idnr.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("36 574 261 809", true) (* Valid *)
    ; ("36574261809", true) (* Valid *)
    ; ("36574261890", false) (* Invalid checksum *)
    ; ("36554266806", false) (* More than one digit repeated more than once *)
    ; ("06574261809", false) (* Starts with 0 *)
    ; ("3657426180", false) (* Too short *)
    ; ("365742618090", false) (* Too long *)
    ; ("3657426180A", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De_stdnum.Idnr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("36574261809", "36 574 261 809"); ("36 574 261 809", "36 574 261 809") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De_stdnum.Idnr.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "De_stdnum.Idnr" [ ("suite", suite) ]
