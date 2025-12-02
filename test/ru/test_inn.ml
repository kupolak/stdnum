let test_compact () =
  let test_cases =
    [
      ("123456789047", "123456789047")
    ; ("1234567894", "1234567894")
    ; ("123 456 789 047", "123456789047")
    ; ("123 456 7894", "1234567894")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ru.Inn.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_company_check_digit () =
  let test_cases =
    [ ("123456789", "4"); ("010800367", "0"); ("027307455", "5") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ru.Inn.calc_company_check_digit input in
      Alcotest.(check string)
        "test_calc_company_check_digit" expected_result result)
    test_cases

let test_calc_personal_check_digits () =
  let test_cases = [ ("1234567890", "47"); ("0058261071", "87") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Ru.Inn.calc_personal_check_digits input in
      Alcotest.(check string)
        "test_calc_personal_check_digits" expected_result result)
    test_cases

let test_validate_company () =
  let test_cases =
    [
      ("0108003670", "0108003670")
    ; ("0273074555", "0273074555")
    ; ("0279111370", "0279111370")
    ; ("0716007984", "0716007984")
    ; ("5190187770", "5190187770")
    ; ("6223002330", "6223002330")
    ; ("6440019934", "6440019934")
    ; ("6672238301", "6672238301")
    ; ("6903022126", "6903022126")
    ; ("6908012650", "6908012650")
    ; ("6911001698", "6911001698")
    ; ("7609000881", "7609000881")
    ; ("7709442668", "7709442668")
    ; ("7716450028", "7716450028")
    ; ("7724051595", "7724051595")
    ; ("7726485118", "7726485118")
    ; ("7727705694", "7727705694")
    ; ("7728127936", "7728127936")
    ; ("7813045547", "7813045547")
    ; ("7825498171", "7825498171")
    ; ("8614008550", "8614008550")
    ; ("8906008726", "8906008726")
    ; ("8906008740", "8906008740")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ru.Inn.validate input in
      Alcotest.(check string) "test_validate_company" expected_result result)
    test_cases

let test_validate_personal () =
  let test_cases =
    [ ("123456789047", "123456789047"); ("005826107187", "005826107187") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ru.Inn.validate input in
      Alcotest.(check string) "test_validate_personal" expected_result result)
    test_cases

let test_validate_invalid_checksum_company () =
  try
    ignore (Ru.Inn.validate "1234567895");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ru.Inn.Invalid_checksum -> ()

let test_validate_invalid_checksum_personal () =
  try
    ignore (Ru.Inn.validate "123456789037");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ru.Inn.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Ru.Inn.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Ru.Inn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Ru.Inn.validate "123456789A");
    Alcotest.fail "Expected Invalid_format exception"
  with Ru.Inn.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      (* Valid 10-digit company INNs *)
      ("0108003670", true)
    ; ("0273074555", true)
    ; ("5190187770", true)
    ; ("7709442668", true)
    ; (* Valid 12-digit personal INNs *)
      ("123456789047", true)
    ; ("005826107187", true)
    ; (* Invalid checksums *)
      ("1234567895", false)
    ; ("123456789037", false)
    ; (* Invalid length *)
      ("12345", false)
    ; ("12345678901", false) (* 11 digits - invalid length *)
    ; ("1234567890123", false) (* 13 digits - invalid length *)
    ; (* Invalid format *)
      ("123456789A", false)
    ; ("12345678AB", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ru.Inn.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_company_check_digit", `Quick, test_calc_company_check_digit)
  ; ("test_calc_personal_check_digits", `Quick, test_calc_personal_check_digits)
  ; ("test_validate_company", `Quick, test_validate_company)
  ; ("test_validate_personal", `Quick, test_validate_personal)
  ; ( "test_validate_invalid_checksum_company"
    , `Quick
    , test_validate_invalid_checksum_company )
  ; ( "test_validate_invalid_checksum_personal"
    , `Quick
    , test_validate_invalid_checksum_personal )
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Ru.Inn" [ ("suite", suite) ]
