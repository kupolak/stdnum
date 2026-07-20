let test_compact () =
  let test_cases = [ ("213800KUD8LAJWSQ9D15", "213800KUD8LAJWSQ9D15") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Lei.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("213800KUD8LAJWSQ9D15", "213800KUD8LAJWSQ9D15") ] in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Lei.validate input in
        Alcotest.(check string) ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Lei.validate "213800KUD8LXJWSQ9D15");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Lei.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("213800KUD8LAJWSQ9D15", true)
    ; ("213800KUD8LXJWSQ9D15", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Lei.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Lei" [ ("suite", suite) ]
