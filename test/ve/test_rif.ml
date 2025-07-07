let test_validate_valid_rif () =
  let input = "V-11470283-4" in
  let expected_result = "V114702834" in
  let result = Ve.Rif.validate input in
  Alcotest.(check string) "test_validate_valid_rif" expected_result result

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Ve.Rif.Invalid_checksum (fun () ->
      ignore (Ve.Rif.validate "V-11470283-3"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Ve.Rif.Invalid_length (fun () ->
      ignore (Ve.Rif.validate "V-1147028"))

let test_validate_invalid_component () =
  Alcotest.check_raises "Invalid Component" Ve.Rif.Invalid_component (fun () ->
      ignore (Ve.Rif.validate "X-11470283-4"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Ve.Rif.Invalid_format (fun () ->
      ignore (Ve.Rif.validate "V-1147028A-4"))

let test_is_valid_true () =
  let input = "V-11470283-4" in
  let expected_result = true in
  let result = Ve.Rif.is_valid input in
  Alcotest.(check bool) "test_is_valid_true" expected_result result

let test_is_valid_false () =
  let input = "V-11470283-3" in
  let expected_result = false in
  let result = Ve.Rif.is_valid input in
  Alcotest.(check bool) "test_is_valid_false" expected_result result

let test_compact () =
  let input = "v-11470283-4" in
  let expected_result = "V114702834" in
  let result = Ve.Rif.compact input in
  Alcotest.(check string) "test_compact" expected_result result

let test_compact_with_spaces () =
  let input = " V 11470283 4 " in
  let expected_result = "V114702834" in
  let result = Ve.Rif.compact input in
  Alcotest.(check string) "test_compact_with_spaces" expected_result result

let test_calc_check_digit () =
  let input = "V11470283" in
  let expected_result = "4" in
  let result = Ve.Rif.calc_check_digit input in
  Alcotest.(check string) "test_calc_check_digit" expected_result result

let test_validate_company_type_e () =
  let input = "E12345678" in
  let check_digit = Ve.Rif.calc_check_digit input in
  let full_number = input ^ check_digit in
  let result = Ve.Rif.validate full_number in
  Alcotest.(check string) "test_validate_company_type_e" full_number result

let test_validate_company_type_j () =
  let input = "J12345678" in
  let check_digit = Ve.Rif.calc_check_digit input in
  let full_number = input ^ check_digit in
  let result = Ve.Rif.validate full_number in
  Alcotest.(check string) "test_validate_company_type_j" full_number result

let test_validate_company_type_p () =
  let input = "P12345678" in
  let check_digit = Ve.Rif.calc_check_digit input in
  let full_number = input ^ check_digit in
  let result = Ve.Rif.validate full_number in
  Alcotest.(check string) "test_validate_company_type_p" full_number result

let test_validate_company_type_g () =
  let input = "G12345678" in
  let check_digit = Ve.Rif.calc_check_digit input in
  let full_number = input ^ check_digit in
  let result = Ve.Rif.validate full_number in
  Alcotest.(check string) "test_validate_company_type_g" full_number result

let suite =
  [
    ("test_validate_valid_rif", `Quick, test_validate_valid_rif)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_compact", `Quick, test_compact)
  ; ("test_compact_with_spaces", `Quick, test_compact_with_spaces)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_company_type_e", `Quick, test_validate_company_type_e)
  ; ("test_validate_company_type_j", `Quick, test_validate_company_type_j)
  ; ("test_validate_company_type_p", `Quick, test_validate_company_type_p)
  ; ("test_validate_company_type_g", `Quick, test_validate_company_type_g)
  ]

let () = Alcotest.run "Ve.Rif" [ ("suite", suite) ]
