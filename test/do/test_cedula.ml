let test_compact () =
  let test_cases =
    [
      ("402-0210298-0", "40202102980")
    ; ("40202102980", "40202102980")
    ; ("402 0210298 0", "40202102980")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Cedula.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("402-0210298-0", "40202102980")
    ; ("00100255349", "00100255349") (* whitelisted number *)
    ; ("22321581834", "22321581834") (* whitelisted number *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Cedula.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("402-0210298-0", true) (* Valid *)
    ; ("40202102980", true) (* Valid *)
    ; ("00100255349", true) (* Whitelisted *)
    ; ("22321581834", true) (* Whitelisted *)
    ; ("4020210298A", false) (* Invalid format *)
    ; ("40202102985", false) (* Invalid checksum *)
    ; ("1234567890", false) (* Invalid length *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Cedula.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("40202102980", "402-0210298-0"); ("402-0210298-0", "402-0210298-0") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Do.Cedula.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Do.Cedula" [ ("suite", suite) ]
