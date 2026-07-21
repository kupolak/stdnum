let test_compact () =
  let result = Ie.Pps.compact " 6433435F " in
  Alcotest.(check string) "test_compact" "6433435F" result

let test_validate () =
  let test_cases =
    [
      ("6433435F", "6433435F") (* pre-2013 *)
    ; ("6433435FT", "6433435FT") (* pre-2013 with special final 'T' *)
    ; ("6433435FW", "6433435FW") (* pre-2013 format for married women *)
    ; ("6433435OA", "6433435OA") (* 2013 format (personal) *)
    ; ("6433435IH", "6433435IH") (* 2013 format (non-personal) *)
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Ie.Pps.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected result)
    test_cases

let test_validate_invalid_checksum () =
  let test_cases =
    [
      "6433435E" (* incorrect check digit *)
    ; "6433435VH" (* 2013 format (incorrect check) *)
    ]
  in
  List.iter
    (fun input ->
      try
        ignore (Ie.Pps.validate input);
        Alcotest.fail ("Expected Invalid_checksum exception for " ^ input)
      with Ie.Pps.Invalid_checksum -> ())
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("6433435F", true)
    ; ("6433435FT", true)
    ; ("6433435FW", true)
    ; ("6433435OA", true)
    ; ("6433435IH", true)
    ; ("6433435E", false)
    ; ("6433435VH", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ie.Pps.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Ie.Pps" [ ("suite", suite) ]
