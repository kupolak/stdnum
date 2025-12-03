let test_compact () =
  let test_cases =
    [
      ("76086428-5", "760864285")
    ; ("CL 12531909-2", "125319092")
    ; ("12.531.909-2", "125319092")
    ; (" 76.086.428-5 ", "760864285")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cl.Rut.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [
      ("76086428", "5")
    ; ("12531909", "2")
    ; ("12345678", "5")
    ; ("11111111", "1")
    ; ("10000013", "K") (* Test K check digit *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cl.Rut.calc_check_digit input in
      Alcotest.(check string) "test_calc_check_digit" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("76086428-5", "760864285")
    ; ("CL 12531909-2", "125319092")
    ; ("12.531.909-2", "125319092")
    ; ("10.000.013-K", "10000013K") (* Test with K check digit *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cl.Rut.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Cl.Rut.validate "12531909-3");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Cl.Rut.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Cl.Rut.validate "76086A28-5");
    Alcotest.fail "Expected Invalid_format exception"
  with Cl.Rut.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (Cl.Rut.validate "123-4");
    Alcotest.fail "Expected Invalid_length exception"
  with Cl.Rut.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("76086428-5", true)
    ; ("CL 12531909-2", true)
    ; ("12.531.909-2", true)
    ; ("10.000.013-K", true) (* Test with K check digit *)
    ; (* Invalid checksum *)
      ("12531909-3", false)
    ; (* Invalid format *)
      ("76086A28-5", false)
    ; (* Invalid length *)
      ("123-4", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cl.Rut.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("125319092", "12.531.909-2")
    ; ("760864285", "76.086.428-5")
    ; ("12345678-5", "12.345.678-5")
    ; ("10000013K", "10.000.013-K") (* Test with K check digit *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cl.Rut.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Cl.Rut" [ ("suite", suite) ]
