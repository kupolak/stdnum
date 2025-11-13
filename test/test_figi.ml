let test_compact () =
  let test_cases =
    [
      ("BBG000BLNQ16", "BBG000BLNQ16")
    ; ("bbg 000 blnq16", "BBG000BLNQ16")
    ; ("bbg000blnq16", "BBG000BLNQ16")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Figi.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("BBG000BLNQ1", "6") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Figi.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ "BBG000BLNQ16" ] in
  List.iter
    (fun input ->
      try
        let result = Stdnum.Figi.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) input result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_format () =
  (* Test invalid format - contains vowel *)
  try
    ignore (Stdnum.Figi.validate "BBG000BLNQ1A");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Figi.Invalid_format -> ()

let test_validate_invalid_length () =
  (* Too short *)
  try
    ignore (Stdnum.Figi.validate "BBG000BLNQ1");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Figi.Invalid_length -> ()

let test_validate_invalid_checksum () =
  (* Wrong check digit *)
  try
    ignore (Stdnum.Figi.validate "BBG000BLNQ14");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Figi.Invalid_checksum -> ()

let test_validate_first_char_digit () =
  (* First character is digit *)
  try
    ignore (Stdnum.Figi.validate "1BG000BLNQ16");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Figi.Invalid_format -> ()

let test_validate_reserved_prefix () =
  (* Reserved country code *)
  try
    ignore (Stdnum.Figi.validate "BSG000BLNQ16");
    Alcotest.fail "Expected Invalid_component exception"
  with Stdnum.Figi.Invalid_component -> ()

let test_validate_third_not_g () =
  (* Third character is not 'G' *)
  try
    ignore (Stdnum.Figi.validate "BBH000BLNQ16");
    Alcotest.fail "Expected Invalid_component exception"
  with Stdnum.Figi.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("BBG000BLNQ16", true)
    ; ("BBG000BLNQ14", false) (* Wrong checksum *)
    ; ("BBG000BLNQ1", false) (* Too short *)
    ; ("1BG000BLNQ16", false) (* First char is digit *)
    ; ("BSG000BLNQ16", false) (* Reserved prefix *)
    ; ("BBH000BLNQ16", false) (* Third char not 'G' *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Figi.is_valid input in
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
  ; ("test_validate_first_char_digit", `Quick, test_validate_first_char_digit)
  ; ("test_validate_reserved_prefix", `Quick, test_validate_reserved_prefix)
  ; ("test_validate_third_not_g", `Quick, test_validate_third_not_g)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Figi" [ ("suite", suite) ]
