let test_compact () =
  let test_cases =
    [
      ("73513537", "73513537")
    ; ("978-0-471-11709-4", "9780471117094")
    ; ("98412345678908", "98412345678908")
    ; ("978 0 471 11709 4", "9780471117094")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Ean.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [ ("7351353", "7"); ("978047111709", "4"); ("9841234567890", "8") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Ean.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [ "73513537"; "9780471117094"; "98412345678908"; "123601057072" ]
  in
  List.iter
    (fun input ->
      try
        let result = Stdnum.Ean.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) input result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_format () =
  (* Test invalid format - contains letters *)
  try
    ignore (Stdnum.Ean.validate "978047111709A");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Ean.Invalid_format -> ()

let test_validate_invalid_length () =
  (* Invalid length *)
  try
    ignore (Stdnum.Ean.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Ean.Invalid_length -> ()

let test_validate_invalid_checksum () =
  (* Wrong check digit *)
  try
    ignore (Stdnum.Ean.validate "9780471117095");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Ean.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("73513537", true) (* EAN-8 *)
    ; ("9780471117094", true) (* EAN-13 *)
    ; ("98412345678908", true) (* GTIN-14 *)
    ; ("123601057072", true) (* UPC-12 *)
    ; ("9780471117095", false) (* Wrong checksum *)
    ; ("12345", false) (* Too short *)
    ; ("978047111709A", false) (* Contains letter *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Ean.is_valid input in
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
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Ean" [ ("suite", suite) ]
