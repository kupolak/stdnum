let test_compact () =
  let test_cases =
    [
      ("IMO 9319466", "9319466")
    ; ("IMO 8814275", "8814275")
    ; ("9319466", "9319466")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imo.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("931946", "6"); ("881427", "5") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imo.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [ ("IMO 9319466", "9319466"); ("IMO 8814275", "8814275") ]
  in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Imo.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Imo.validate "8814274");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Imo.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Imo.validate "881427A");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Imo.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Imo.validate "881427");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Imo.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("IMO 9319466", true)
    ; ("IMO 8814275", true)
    ; ("8814274", false)
    ; ("881427A", false)
    ; ("881427", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imo.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("8814275", "IMO 8814275"); ("IMO 9319466", "IMO 9319466") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imo.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
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

let () = Alcotest.run "Stdnum.Imo" [ ("suite", suite) ]
