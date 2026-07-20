let test_compact () =
  let result = Gb.Upn.compact " B801200005001 " in
  Alcotest.(check string) "test_compact" "B801200005001" result

let test_calc_check_digit () =
  let result = Gb.Upn.calc_check_digit "801200005001" in
  Alcotest.(check string) "test_calc_check_digit" "B" result

let test_validate () =
  let result = Gb.Upn.validate "B801200005001" in
  Alcotest.(check string) "test_validate" "B801200005001" result

let test_validate_invalid_checksum () =
  try
    ignore (Gb.Upn.validate "A801200005001");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gb.Upn.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Gb.Upn.validate "B80120000500");
    Alcotest.fail "Expected Invalid_length exception"
  with Gb.Upn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Gb.Upn.validate "X80120000A001");
    Alcotest.fail "Expected Invalid_format exception"
  with Gb.Upn.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (Gb.Upn.validate "E000200005001");
    Alcotest.fail "Expected Invalid_component exception"
  with Gb.Upn.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("B801200005001", true)
    ; ("A801200005001", false)
    ; ("X80120000A001", false)
    ; ("E000200005001", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gb.Upn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Gb.Upn" [ ("suite", suite) ]
