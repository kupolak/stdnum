let test_compact () =
  let test_cases =
    [
      ("2 95 10 99 126 111 93", "295109912611193")
    ; ("295109912611193", "295109912611193")
    ; ("253072b07300470", "253072B07300470")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nir.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_check_digits () =
  let test_cases =
    [
      ("2951099126111", "93"); ("253072B073004", "70"); ("253072A073004", "43")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nir.calc_check_digits input in
      Alcotest.(check string) "test_calc_check_digits" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("2 95 10 99 126 111 93", "295109912611193")
    ; ("295109912611193", "295109912611193")
    ; ("253072B07300470", "253072B07300470")
    ; ("253072A07300443", "253072A07300443")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nir.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Fr.Nir.validate "295109912611199");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fr.Nir.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Fr.Nir.validate "6546546546546703");
    Alcotest.fail "Expected Invalid_length exception"
  with Fr.Nir.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Fr.Nir.validate "253072C07300443");
    Alcotest.fail "Expected Invalid_format exception"
  with Fr.Nir.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("295109912611193", true)
    ; ("2 95 10 99 126 111 93", true)
    ; ("253072B07300470", true)
    ; ("253072A07300443", true)
    ; ("295109912611199", false) (* bad checksum *)
    ; ("6546546546546703", false) (* wrong length *)
    ; ("253072C07300443", false) (* invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nir.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("295109912611193", "2 95 10 99 126 111 93")
    ; ("253072B07300470", "2 53 07 2B 073 004 70")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Nir.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Fr.Nir" [ ("suite", suite) ]
