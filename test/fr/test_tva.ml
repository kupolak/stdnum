let test_compact () =
  let test_cases =
    [
      ("Fr 40 303 265 045", "40303265045")
    ; ("FR 23 334 175 221", "23334175221")
    ; ("23334175221", "23334175221")
    ; ("K7399859412", "K7399859412")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Tva.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("Fr 40 303 265 045", "40303265045")
    ; ("23 334 175 221", "23334175221")
    ; ("23334175221", "23334175221")
    ; ("K7399859412", "K7399859412") (* new-style number *)
    ; ("4Z123456782", "4Z123456782") (* new-style starting with digit *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Tva.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  (* Old style with bad checksum *)
  (try
     ignore (Fr.Tva.validate "84 323 140 391");
     Alcotest.fail "Expected Invalid_checksum exception"
   with Fr.Tva.Invalid_checksum -> ());

  (* Test another invalid checksum *)
  try
    ignore (Fr.Tva.validate "12334175221");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fr.Tva.Invalid_checksum -> ()

let test_validate_invalid_format () =
  (* I and O are not valid letters *)
  (try
     ignore (Fr.Tva.validate "IO334175221");
     Alcotest.fail "Expected Invalid_format exception"
   with Fr.Tva.Invalid_format -> ());

  (* Test with I *)
  (try
     ignore (Fr.Tva.validate "I7334175221");
     Alcotest.fail "Expected Invalid_format exception"
   with Fr.Tva.Invalid_format -> ());

  (* Test with O *)
  try
    ignore (Fr.Tva.validate "O7334175221");
    Alcotest.fail "Expected Invalid_format exception"
  with Fr.Tva.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (Fr.Tva.validate "2333417522");
    Alcotest.fail "Expected Invalid_length exception"
  with Fr.Tva.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("Fr 40 303 265 045", true)
    ; ("23 334 175 221", true)
    ; ("K7399859412", true) (* new-style *)
    ; ("4Z123456782", true) (* new-style starting with digit *)
    ; ("84 323 140 391", false) (* bad checksum *)
    ; ("IO334175221", false) (* invalid format - I and O not allowed *)
    ; ("2333417522", false) (* wrong length *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Tva.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_to_siren () =
  let test_cases =
    [
      ("Fr 40 303 265 045", "303265045")
    ; ("23 334 175 221", "334175221")
    ; ("K7399859412", "399859412")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Tva.to_siren input in
      Alcotest.(check string) "test_to_siren" expected_result result)
    test_cases

let test_to_siren_monaco () =
  (* Monaco VAT code cannot be converted to SIREN *)
  try
    ignore (Fr.Tva.to_siren "FR 53 0000 04605");
    Alcotest.fail "Expected Invalid_component exception"
  with Fr.Tva.Invalid_component -> ()

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_to_siren", `Quick, test_to_siren)
  ; ("test_to_siren_monaco", `Quick, test_to_siren_monaco)
  ]

let () = Alcotest.run "Fr.Tva" [ ("suite", suite) ]
