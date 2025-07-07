let test_validate_valid_10_digit () =
  let input = "0100233488" in
  let expected_result = "0100233488" in
  let result = Vn.Mst.validate input in
  Alcotest.(check string) "test_validate_valid_10_digit" expected_result result

let test_validate_valid_13_digit () =
  let input = "0314409058-002" in
  let expected_result = "0314409058002" in
  let result = Vn.Mst.validate input in
  Alcotest.(check string) "test_validate_valid_13_digit" expected_result result

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Vn.Mst.Invalid_length (fun () ->
      ignore (Vn.Mst.validate "12345"))

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Vn.Mst.Invalid_checksum (fun () ->
      ignore (Vn.Mst.validate "0100233480"))

let test_is_valid_true () =
  let input = "0100233488" in
  let expected_result = true in
  let result = Vn.Mst.is_valid input in
  Alcotest.(check bool) "test_is_valid_true" expected_result result

let test_is_valid_false () =
  let input = "12345" in
  let expected_result = false in
  let result = Vn.Mst.is_valid input in
  Alcotest.(check bool) "test_is_valid_false" expected_result result

let test_format_10_digit () =
  let input = "01.00.112.437" in
  let expected_result = "0100112437" in
  let result = Vn.Mst.format input in
  Alcotest.(check string) "test_format_10_digit" expected_result result

let test_format_13_digit () =
  let input = "0312 68 78 78 - 001" in
  let expected_result = "0312687878-001" in
  let result = Vn.Mst.format input in
  Alcotest.(check string) "test_format_13_digit" expected_result result

let test_compact () =
  let input = "01.00.112.437" in
  let expected_result = "0100112437" in
  let result = Vn.Mst.compact input in
  Alcotest.(check string) "test_compact" expected_result result

let test_compact_with_spaces () =
  let input = " 0312 68 78 78 - 001 " in
  let expected_result = "0312687878001" in
  let result = Vn.Mst.compact input in
  Alcotest.(check string) "test_compact_with_spaces" expected_result result

let test_calc_check_digit () =
  let input = "010023348" in
  let expected_result = "8" in
  let result = Vn.Mst.calc_check_digit input in
  Alcotest.(check string) "test_calc_check_digit" expected_result result

let test_validate_invalid_component_middle_zeros () =
  Alcotest.check_raises "Invalid Component (middle zeros)"
    Vn.Mst.Invalid_component (fun () -> ignore (Vn.Mst.validate "0100000009"))

let test_validate_invalid_component_branch_zeros () =
  Alcotest.check_raises "Invalid Component (branch zeros)"
    Vn.Mst.Invalid_component (fun () ->
      ignore (Vn.Mst.validate "0100233488000"))

let test_validate_invalid_format_non_digits () =
  Alcotest.check_raises "Invalid Format (non-digits)" Vn.Mst.Invalid_format
    (fun () -> ignore (Vn.Mst.validate "010023348A"))

let suite =
  [
    ("test_validate_valid_10_digit", `Quick, test_validate_valid_10_digit)
  ; ("test_validate_valid_13_digit", `Quick, test_validate_valid_13_digit)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format_10_digit", `Quick, test_format_10_digit)
  ; ("test_format_13_digit", `Quick, test_format_13_digit)
  ; ("test_compact", `Quick, test_compact)
  ; ("test_compact_with_spaces", `Quick, test_compact_with_spaces)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ( "test_validate_invalid_component_middle_zeros"
    , `Quick
    , test_validate_invalid_component_middle_zeros )
  ; ( "test_validate_invalid_component_branch_zeros"
    , `Quick
    , test_validate_invalid_component_branch_zeros )
  ; ( "test_validate_invalid_format_non_digits"
    , `Quick
    , test_validate_invalid_format_non_digits )
  ]

let () = Alcotest.run "Vn.Mst" [ ("suite", suite) ]
