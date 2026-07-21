let test_compact () =
  let test_cases =
    [ ("0000-0000-D07A-0090-Q-0000-0000-X", "00000000D07A009000000000") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isan.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("000000018947000000000000", "000000018947000000000000")
    ; ("0000-0001-8CFA-0000-I-0000-0000-K", "000000018CFA0000I00000000K")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      try
        let result = Stdnum.Isan.validate input in
        Alcotest.(check string)
          ("test_validate_" ^ input) expected_result result
      with e ->
        Alcotest.fail
          (Printf.sprintf "validate failed for %s: %s" input
             (Printexc.to_string e)))
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Stdnum.Isan.validate "0000-0001-8CFA-0000-A-0000-0000-K");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Isan.Invalid_checksum -> ()

let test_format () =
  let test_cases =
    [ ("000000018947000000000000", "0000-0001-8947-0000-8-0000-0000-D") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isan.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let test_to_urn () =
  let test_cases =
    [
      ("00000000D07A009000000000", "URN:ISAN:0000-0000-D07A-0090-Q-0000-0000-X")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isan.to_urn input in
      Alcotest.(check string) ("test_to_urn_" ^ input) expected_result result)
    test_cases

let test_to_xml () =
  let test_cases =
    [
      ( "1881-66C7-3420-6541-Y-9F3A-0245-O"
      , "<ISAN root=\"1881-66C7-3420\" episode=\"6541\" version=\"9F3A-0245\" \
         />" )
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Isan.to_xml input in
      Alcotest.(check string) ("test_to_xml_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_format", `Quick, test_format)
  ; ("test_to_urn", `Quick, test_to_urn)
  ; ("test_to_xml", `Quick, test_to_xml)
  ]

let () = Alcotest.run "Stdnum.Isan" [ ("suite", suite) ]
