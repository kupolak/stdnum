let test_compact () =
  let test_cases = [ ("  979-0-3452-4680-5", "9790345246805") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Ismn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("979-0-3452-4680-5", "9790345246805")
    ; ("9790060115615", "9790060115615")
    ; (" M-2306-7118-7", "M230671187")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Ismn.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Ismn.validate "9790060115614");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Ismn.Invalid_checksum -> ()

let test_ismn_type () =
  let test_cases =
    [
      (" M-2306-7118-7", Some "ISMN10")
    ; ("9790060115615", Some "ISMN13")
    ; ("9790060115614", None)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Ismn.ismn_type input in
      Alcotest.(check (option string))
        ("test_ismn_type_" ^ input)
        expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("9790060115615", "979-0-060-11561-5")
    ; ("M230671187", "979-0-2306-7118-7")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Ismn.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let test_to_ismn13 () =
  let test_cases = [ ("M230671187", "9790230671187") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Ismn.to_ismn13 input in
      Alcotest.(check string) ("test_to_ismn13_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_ismn_type", `Quick, test_ismn_type)
  ; ("test_format", `Quick, test_format)
  ; ("test_to_ismn13", `Quick, test_to_ismn13)
  ]

let () = Alcotest.run "Stdnum.Ismn" [ ("suite", suite) ]
