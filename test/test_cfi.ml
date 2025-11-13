let test_compact () =
  let test_cases =
    [ ("ELNUFR", "ELNUFR"); ("eln ufr", "ELNUFR"); ("ELN-UFR", "ELNUFR") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Cfi.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ "ELNUFR"; "ESNTPB"; "DBXXXX" ] in
  List.iter
    (fun input ->
      try
        let result = Stdnum.Cfi.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) input result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_format () =
  (* Test invalid format - contains digits *)
  try
    ignore (Stdnum.Cfi.validate "ELN123");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Cfi.Invalid_format -> ()

let test_validate_invalid_length () =
  (* Too short *)
  try
    ignore (Stdnum.Cfi.validate "ELNUF");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Cfi.Invalid_length -> ()

let test_validate_invalid_length_long () =
  (* Too long *)
  try
    ignore (Stdnum.Cfi.validate "ELNUFRX");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Cfi.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("ELNUFR", true)
    ; ("ESNTPB", true)
    ; ("DBXXXX", true)
    ; ("ELN123", false) (* Contains digits *)
    ; ("ELNUF", false) (* Too short *)
    ; ("ELNUFRX", false) (* Too long *)
    ; ("elnufr", true) (* Lowercase - will be normalized *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Cfi.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_length_long"
    , `Quick
    , test_validate_invalid_length_long )
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Cfi" [ ("suite", suite) ]
