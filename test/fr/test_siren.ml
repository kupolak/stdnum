let test_compact () =
  let test_cases =
    [ ("552 008 443", "552008443"); ("404833048", "404833048") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siren.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [ ("404833048", "404833048"); ("552 008 443", "552008443") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siren.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Fr.Siren.validate "404833047");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fr.Siren.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Fr.Siren.validate "40483304");
    Alcotest.fail "Expected Invalid_length exception"
  with Fr.Siren.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Fr.Siren.validate "40483304A");
    Alcotest.fail "Expected Invalid_format exception"
  with Fr.Siren.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("404833048", true)
    ; ("552 008 443", true)
    ; ("404833047", false) (* bad checksum *)
    ; ("40483304", false) (* wrong length *)
    ; ("40483304A", false) (* invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siren.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_to_tva () =
  let test_cases =
    [ ("443 121 975", "46 443 121 975"); ("404833048", "83404833048") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siren.to_tva input in
      Alcotest.(check string) "test_to_tva" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("404833048", "404 833 048"); ("552008443", "552 008 443") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siren.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_to_tva", `Quick, test_to_tva)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Fr.Siren" [ ("suite", suite) ]
