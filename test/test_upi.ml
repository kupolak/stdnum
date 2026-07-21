let test_compact () =
  let test_cases = [ (" QZK12RNSP6P6 ", "QZK12RNSP6P6") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Upi.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let result = Stdnum.Upi.calc_check_digit "QZK12RNSP6P" in
  Alcotest.(check string) "test_calc_check_digit" "6" result

let test_validate () =
  let test_cases = [ ("QZK12RNSP6P6", "QZK12RNSP6P6") ] in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Upi.validate input in
        Alcotest.(check string)
          ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Upi.validate "QZK12RNSP6P7");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Upi.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Upi.validate "QZK12RNSP6P");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Upi.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Upi.validate "QZK12RNSP6PA");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Upi.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (Stdnum.Upi.validate "ZZK12RNSP6P6");
    Alcotest.fail "Expected Invalid_component exception"
  with Stdnum.Upi.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [ ("QZK12RNSP6P6", true); ("QZK12RNSP6P7", false); ("QZK12RNSP6P", false) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Upi.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Upi" [ ("suite", suite) ]
