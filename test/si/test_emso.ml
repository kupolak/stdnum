let test_compact () =
  let test_cases =
    [ ("0101006-300007", "0101006300007"); ("0101006300007", "0101006300007") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Emso.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [
      ("010100630000", "7")
    ; ("211299945500", "0")
    ; ("010101330600", "2")
    ; ("211299845007", "1")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Emso.calc_check_digit input in
      Alcotest.(check string) "test_calc_check_digit" expected_result result)
    test_cases

let test_get_birth_date () =
  let test_cases =
    [
      ("0101006300007", (2006, 1, 1))
    ; ("2112999455000", (1999, 12, 21))
    ; ("0101013306002", (2013, 1, 1))
    ; ("2112998450071", (1998, 12, 21))
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Emso.get_birth_date input in
      Alcotest.(check (Alcotest.triple Alcotest.int Alcotest.int Alcotest.int))
        "test_get_birth_date" expected_result result)
    test_cases

let test_get_gender () =
  let test_cases =
    [
      ("0101006300007", "M")
    ; ("2112999455000", "F")
    ; ("0101013306002", "F")
    ; ("2112998450071", "M")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Emso.get_gender input in
      Alcotest.(check string) "test_get_gender" expected_result result)
    test_cases

let test_get_region () =
  let test_cases =
    [
      ("0101006300007", "Koper")
    ; ("2112999455000", "Murska Sobota")
    ; ("0101013306002", "Koper")
    ; ("2112998450071", "Murska Sobota")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Emso.get_region input in
      Alcotest.(check string) "test_get_region" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("0101006300007", "0101006300007")
    ; ("2112999455000", "2112999455000")
    ; ("0101013306002", "0101013306002")
    ; ("2112998450071", "2112998450071")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Emso.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Si.Emso.validate "0101006300008");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Si.Emso.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Si.Emso.validate "010100630000");
    Alcotest.fail "Expected Invalid_length exception"
  with Si.Emso.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Si.Emso.validate "010100630000A");
    Alcotest.fail "Expected Invalid_format exception"
  with Si.Emso.Invalid_format -> ()

let test_validate_invalid_date () =
  try
    ignore (Si.Emso.validate "3213006300003");
    Alcotest.fail "Expected Invalid_component exception"
  with Si.Emso.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("0101006300007", true)
    ; ("2112999455000", true)
    ; ("0101013306002", true)
    ; ("2112998450071", true)
    ; ("0101006300008", false) (* bad checksum *)
    ; ("010100630000", false) (* wrong length *)
    ; ("010100630000A", false) (* invalid format *)
    ; ("3213006300003", false) (* invalid date *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Emso.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [ ("0101006300007", "0101006300007"); ("2112999455000", "2112999455000") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Emso.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_get_region", `Quick, test_get_region)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_date", `Quick, test_validate_invalid_date)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Si.Emso" [ ("suite", suite) ]
