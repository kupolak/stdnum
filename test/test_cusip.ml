let test_compact () =
  let test_cases =
    [
      ("DUS0421C5", "DUS0421C5")
    ; ("dus 0421c5", "DUS0421C5")
    ; ("dus0421c5", "DUS0421C5")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Cusip.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("DUS0421C", "5"); ("91324PAE", "2") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Cusip.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ "DUS0421C5"; "91324PAE2" ] in
  List.iter
    (fun input ->
      try
        let result = Stdnum.Cusip.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) input result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_format () =
  (* Test invalid format - contains invalid character *)
  try
    ignore (Stdnum.Cusip.validate "DUS0421?5");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Cusip.Invalid_format -> ()

let test_validate_invalid_length () =
  (* Too short *)
  try
    ignore (Stdnum.Cusip.validate "DUS0421C");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Cusip.Invalid_length -> ()

let test_validate_invalid_checksum () =
  (* Wrong check digit *)
  try
    ignore (Stdnum.Cusip.validate "DUS0421CN");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Cusip.Invalid_checksum -> ()

let test_to_isin () =
  let test_cases = [ ("91324PAE2", "US91324PAE25") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Cusip.to_isin input in
      Alcotest.(check string) ("test_to_isin_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("DUS0421C5", true)
    ; ("91324PAE2", true)
    ; ("DUS0421CN", false) (* Wrong checksum *)
    ; ("DUS0421C", false) (* Too short *)
    ; ("DUS0421?5", false) (* Invalid character *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Cusip.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_to_isin", `Quick, test_to_isin)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Cusip" [ ("suite", suite) ]
