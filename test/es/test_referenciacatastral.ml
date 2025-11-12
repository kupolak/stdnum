let test_compact () =
  let test_cases =
    [
      ("7837301-VG8173B-0001 TT", "7837301VG8173B0001TT")
    ; ("4A08169P03PRAT0001LR", "4A08169P03PRAT0001LR")
    ; ("7837301 VG8173B 0001 TT", "7837301VG8173B0001TT")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Referenciacatastral.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_format () =
  (* From Python doctest: format('4A08169P03PRAT0001LR') - BCN Airport *)
  let result = Es.Referenciacatastral.format "4A08169P03PRAT0001LR" in
  Alcotest.(check string) "test_format" "4A08169 P03PRAT 0001 LR" result

let test_calc_check_digits () =
  let test_cases =
    [ ("7837301VG8173B0001", "TT"); ("4A08169P03PRAT0001", "LR") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Referenciacatastral.calc_check_digits input in
      Alcotest.(check string)
        ("test_calc_check_digits_" ^ input)
        expected_result result)
    test_cases

let test_validate_valid () =
  (* From Python doctest: validate('7837301-VG8173B-0001 TT') - Lanteira town hall *)
  let result = Es.Referenciacatastral.validate "7837301-VG8173B-0001 TT" in
  Alcotest.(check string) "test_validate_valid" "7837301VG8173B0001TT" result

let test_validate_valid_airport () =
  let result = Es.Referenciacatastral.validate "4A08169P03PRAT0001LR" in
  Alcotest.(check string)
    "test_validate_valid_airport" "4A08169P03PRAT0001LR" result

let test_validate_invalid_length () =
  (* From Python doctest: validate('783301 VG8173B 0001 TT') - missing digit *)
  Alcotest.check_raises "Invalid Length" Es.Referenciacatastral.Invalid_length
    (fun () ->
      ignore (Es.Referenciacatastral.validate "783301 VG8173B 0001 TT"))

let test_validate_invalid_format () =
  (* From Python doctest: validate('7837301/VG8173B 0001 TT') - not alphanumeric *)
  Alcotest.check_raises "Invalid Format" Es.Referenciacatastral.Invalid_format
    (fun () ->
      ignore (Es.Referenciacatastral.validate "7837301/VG8173B 0001 TT"))

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('7837301 VG8173B 0001 NN') - bad check digits *)
  Alcotest.check_raises "Invalid Checksum"
    Es.Referenciacatastral.Invalid_checksum (fun () ->
      ignore (Es.Referenciacatastral.validate "7837301 VG8173B 0001 NN"))

let test_is_valid_true () =
  let result = Es.Referenciacatastral.is_valid "7837301-VG8173B-0001 TT" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false_length () =
  let result = Es.Referenciacatastral.is_valid "783301 VG8173B 0001 TT" in
  Alcotest.(check bool) "test_is_valid_false_length" false result

let test_is_valid_false_format () =
  let result = Es.Referenciacatastral.is_valid "7837301/VG8173B 0001 TT" in
  Alcotest.(check bool) "test_is_valid_false_format" false result

let test_is_valid_false_checksum () =
  let result = Es.Referenciacatastral.is_valid "7837301 VG8173B 0001 NN" in
  Alcotest.(check bool) "test_is_valid_false_checksum" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid_airport", `Quick, test_validate_valid_airport)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false_length", `Quick, test_is_valid_false_length)
  ; ("test_is_valid_false_format", `Quick, test_is_valid_false_format)
  ; ("test_is_valid_false_checksum", `Quick, test_is_valid_false_checksum)
  ]

let () = Alcotest.run "Es.Referenciacatastral" [ ("suite", suite) ]
