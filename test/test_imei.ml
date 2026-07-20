let test_compact () =
  let test_cases =
    [
      ("35686800-004141-20", "3568680000414120")
    ; ("35-209900-176148-1", "352099001761481")
    ; ("354178036859789", "354178036859789")
    ; ("49-015420-323751", "49015420323751")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imei.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("49-015420-323751", "49015420323751")
    ; ("35-209900-176148-1", "352099001761481")
    ; ("35-209900-176148-23", "3520990017614823")
    ; ("350077-52-323751-3", "350077523237513")
    ; ("354178036859789", "354178036859789")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Imei.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Imei.validate "35-417803-685978-1");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Imei.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Imei.validate "3568680000ABCDEF");
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Imei.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Imei.validate "3568680");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Imei.Invalid_length -> ()

let test_imei_type () =
  let test_cases =
    [
      ("35686800-004141-20", Some "IMEISV")
    ; ("35-417803-685978-9", Some "IMEI")
    ; ("3568680000414120", Some "IMEISV")
    ; ("49-015420-323751", Some "IMEI")
    ; ("35-417803-685978-2", None) (* invalid check digit *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imei.imei_type input in
      Alcotest.(check (option string))
        ("test_imei_type_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("35686800-004141-20", true)
    ; ("354178036859789", true)
    ; ("49-015420-323751", true)
    ; ("35-417803-685978-1", false)
    ; ("3568680000ABCDEF", false)
    ; ("3568680", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imei.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_split () =
  let test_cases =
    [ ("35686800-004141", ("35686800", "004141", ""))
    ; ("354178036859789", ("35417803", "685978", "9"))
    ; ("3568680000414120", ("35686800", "004141", "20"))
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imei.split input in
      Alcotest.(check (triple string string string))
        ("test_split_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("354178036859789", "35-417803-685978-9")
    ; ("35417803685978", "35-417803-685978")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imei.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let test_format_add_check_digit () =
  let test_cases =
    [
      ("35417803685978", "35-417803-685978-9")
    ; ("35686800-004141", "35-686800-004141-8")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imei.format ~add_check_digit:true input in
      Alcotest.(check string)
        ("test_format_add_check_digit_" ^ input)
        expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_imei_type", `Quick, test_imei_type)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_split", `Quick, test_split)
  ; ("test_format", `Quick, test_format)
  ; ("test_format_add_check_digit", `Quick, test_format_add_check_digit)
  ]

let () = Alcotest.run "Stdnum.Imei" [ ("suite", suite) ]
