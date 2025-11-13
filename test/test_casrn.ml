let test_compact () =
  let test_cases =
    [ ("8786  5", "87-86-5"); ("87865", "87-86-5"); ("87-86-5", "87-86-5") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Casrn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("87-86", "5"); ("1333-86", "4") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Casrn.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ "87-86-5"; "1333-86-4" ] in
  List.iter
    (fun input ->
      try
        let result = Stdnum.Casrn.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) input result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_format () =
  (* Test invalid format *)
  try
    ignore (Stdnum.Casrn.validate "0-87-86-5");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Casrn.Invalid_format -> ()

let test_validate_invalid_length () =
  (* Too short *)
  try
    ignore (Stdnum.Casrn.validate "8-7-5");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Casrn.Invalid_length -> ()

let test_validate_invalid_checksum () =
  (* Wrong check digit *)
  try
    ignore (Stdnum.Casrn.validate "87-86-6");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Casrn.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("87-86-5", true)
    ; ("1333-86-4", true)
    ; ("87865", true)
    ; ("87-86-6", false) (* Wrong checksum *)
    ; ("0-87-86-5", false) (* Starts with 0 *)
    ; ("8-7-5", false) (* Too short *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Casrn.is_valid input in
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

let () = Alcotest.run "Stdnum.Casrn" [ ("suite", suite) ]
