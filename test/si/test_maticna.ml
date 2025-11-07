let test_compact () =
  let test_cases =
    [
      ("9331310000", "9331310")
    ; ("9331310", "9331310")
    ; ("9331310001", "9331310001")
    ; ("9.331.310", "9331310")
    ; (" 9331310 ", "9331310")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Maticna.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let result = Si.Maticna.calc_check_digit "9331310" in
  Alcotest.(check string) "test_calc_check_digit" "0" result

let test_validate_valid () =
  let test_cases =
    [
      ("9331310000", "9331310")
    ; ("9331310", "9331310")
    ; ("9331310001", "9331310001")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Si.Maticna.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Si.Maticna.Invalid_checksum
    (fun () -> ignore (Si.Maticna.validate "9331320000"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Si.Maticna.Invalid_length (fun () ->
      ignore (Si.Maticna.validate "12345"))

let test_validate_invalid_format_first_six () =
  Alcotest.check_raises "Invalid Format" Si.Maticna.Invalid_format (fun () ->
      ignore (Si.Maticna.validate "93313A0000"))

let test_validate_invalid_format_business_unit () =
  Alcotest.check_raises "Invalid Format" Si.Maticna.Invalid_format (fun () ->
      ignore (Si.Maticna.validate "933131000A"))

let test_is_valid_true () =
  let result = Si.Maticna.is_valid "9331310000" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Si.Maticna.is_valid "9331320000" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_validate_with_letter_in_business_unit () =
  (* Test business unit with letter (for companies with >1000 units) *)
  let result = Si.Maticna.is_valid "9331310A01" in
  Alcotest.(check bool) "test_validate_with_letter" true result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_format_first_six"
    , `Quick
    , test_validate_invalid_format_first_six )
  ; ( "test_validate_invalid_format_business_unit"
    , `Quick
    , test_validate_invalid_format_business_unit )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ( "test_validate_with_letter_in_business_unit"
    , `Quick
    , test_validate_with_letter_in_business_unit )
  ]

let () = Alcotest.run "Si.Maticna" [ ("suite", suite) ]
