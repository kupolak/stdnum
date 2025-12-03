let test_compact () =
  let test_cases =
    [
      ("12302 6635", "123026635")
    ; ("12302 6635 RC 0001", "123026635RC0001")
    ; (" 123-026-635 ", "123026635")
    ; ("123026635", "123026635")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ca.Bn.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("12302 6635", "123026635") (* 9-digit BN *)
    ; ("12302 6635 RC 0001", "123026635RC0001") (* 15-digit BN15 *)
    ; ("123025645RC0001", "123025645RC0001")
    ; ("123026635RC0001", "123026635RC0001")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ca.Bn.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Ca.Bn.validate "123456783");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ca.Bn.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Ca.Bn.validate "12345678Z");
    Alcotest.fail "Expected Invalid_format exception"
  with Ca.Bn.Invalid_format -> ()

let test_validate_invalid_format_ref_num () =
  (* Reference number must be digits *)
  try
    ignore (Ca.Bn.validate "12302 6635 RC OOO1");
    Alcotest.fail "Expected Invalid_format exception"
  with Ca.Bn.Invalid_format -> ()

let test_validate_invalid_component () =
  (* Only RC, RM, RP, RT are valid program identifiers *)
  try
    ignore (Ca.Bn.validate "12302 6635 AA 0001");
    Alcotest.fail "Expected Invalid_component exception"
  with Ca.Bn.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (Ca.Bn.validate "12345678");
    Alcotest.fail "Expected Invalid_length exception"
  with Ca.Bn.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("12302 6635", true)
    ; ("12302 6635 RC 0001", true)
    ; ("123025645RC0001", true)
    ; ("123026635RC0001", true)
    ; (* Invalid checksum *)
      ("123456783", false)
    ; (* Invalid format *)
      ("12345678Z", false)
    ; (* Invalid format in ref num *)
      ("12302 6635 RC OOO1", false)
    ; (* Invalid component *)
      ("12302 6635 AA 0001", false)
    ; (* Invalid length *)
      ("12345678", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ca.Bn.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

(* Test all valid numbers from doctest *)
let test_valid_numbers_from_doctest () =
  let numbers =
    [
      "000089987RC1818"
    ; "100007780RC0001"
    ; "100026723RC0001"
    ; "100044833RC0001"
    ; "100060474RC0001"
    ; "100074699RC0001"
    ; "100078294RC0002"
    ; "100080571RC0001"
    ; "100287119RC0001"
    ; "100457266RC0001"
    ; "101007961RC0001"
    ; "101060390RC0001"
    ; "123025645RC0001"
    ; "123026635RC0001"
    ; "123222911RC0001"
    ; "123828493RC0001"
    ; "700706898RC0001"
    ; "700783491RC0001"
    ; "700784499RC0001"
    ; "700803299RC0001"
    ; "700859895RC0001"
    ; "702520891RC0001"
    ; "702521097RC0001"
    ; "702529496RC0001"
    ; "702667122RC0001"
    ; "751055724RC0001"
    ; "751119520RC0001"
    ; "751207697RC0001"
    ; "751369729RC0001"
    ; "751446725RC0001"
    ; "751542895RC0001"
    ; "751551490RC0001"
    ; "751756529RC0001"
    ; "752573725RC0001"
    ; "752574525RC0001"
    ; "752628297RC0001"
    ; "752767327RC0001"
    ; "752768127RC0001"
    ; "752805291RC0001"
    ; "752828293RC0001"
    ; "752860320RC0001"
    ; "752944892RC0001"
    ; "753000298RC0001"
    ; "753371897RC0001"
    ; "753372291RC0001"
    ; "753447127RC0001"
    ; "753461292RC0001"
    ; "753946698RC0001"
    ; "789422128RC0001"
    ; "789482494RC0001"
    ; "789538923RC0001"
    ; "789634326RC0001"
    ; "795578699RC0001"
    ; "795606490RC0001"
    ; "795676121RC0001"
    ; "795710920RC0001"
    ; "795848126RC0001"
    ; "795855527RC0001"
    ; "795930726RC0001"
    ; "800500001RC0001"
    ; "800810657RC0001"
    ; "800812885RC0001"
    ; "800826489RC0001"
    ; "800958118RC0001"
    ; "800973406RC0001"
    ; "852093749RC0001"
    ; "852470673RC0001"
    ; "852581149RC0001"
    ; "852615772RC0001"
    ; "852646900RC0001"
    ; "852694231RC0001"
    ; "852750546RC0001"
    ; "852988633RC0001"
    ; "855065504RC0001"
    ; "855102976RC0001"
    ; "855582995RC0001"
    ; "855643086RC0001"
    ; "855696373RC0001"
    ; "855789004RC0001"
    ; "855957882RC0001"
    ; "859043580RC0001"
    ; "859098337RC0001"
    ; "859144438RC0001"
    ; "859363848RC0001"
    ; "859395162RC0001"
    ; "859457681RC0001"
    ; "859620973RC0001"
    ; "892190364RC0001"
    ; "892220393RC0002"
    ; "892462672RC0001"
    ; "892476565RC0001"
    ; "892552035RC0001"
    ; "892737149RC0001"
    ; "892738741RC0001"
    ; "892807983RC0001"
    ; "899099733RC0001"
    ; "899429443RC0001"
    ; "899549042RC0001"
    ; "899558340RC0001"
    ; "899927438RC0001"
    ]
  in
  List.iter
    (fun number ->
      if not (Ca.Bn.is_valid number) then
        Alcotest.fail (Printf.sprintf "Number should be valid: %s" number))
    numbers

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ( "test_validate_invalid_format_ref_num"
    , `Quick
    , test_validate_invalid_format_ref_num )
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_valid_numbers_from_doctest", `Quick, test_valid_numbers_from_doctest)
  ]

let () = Alcotest.run "Ca.Bn" [ ("suite", suite) ]
