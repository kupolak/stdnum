let test_checksum_valid () =
  let result = Tools.Damm.checksum "5724" in
  Alcotest.(check int) "test_checksum_valid" 0 result

let test_checksum_invalid () =
  let result = Tools.Damm.checksum "572" in
  Alcotest.(check bool) "test_checksum_invalid_not_zero" true (result <> 0)

let test_calc_check_digit () =
  let result = Tools.Damm.calc_check_digit "572" in
  Alcotest.(check string) "test_calc_check_digit" "4" result

let test_validate_valid () =
  let result = Tools.Damm.validate "5724" in
  Alcotest.(check string) "test_validate_valid" "5724" result

let test_validate_invalid () =
  Alcotest.check_raises "Invalid Checksum" Tools.Damm.Invalid_checksum
    (fun () -> ignore (Tools.Damm.validate "572"))

let test_validate_empty () =
  Alcotest.check_raises "Invalid Format" Tools.Damm.Invalid_format (fun () ->
      ignore (Tools.Damm.validate ""))

let test_is_valid_true () =
  let result = Tools.Damm.is_valid "5724" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Tools.Damm.is_valid "572" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_custom_table () =
  let custom_table =
    [|
       [| 0; 2; 3; 4; 5; 6; 7; 8; 9; 1 |]
     ; [| 2; 0; 4; 1; 7; 9; 5; 3; 8; 6 |]
     ; [| 3; 7; 0; 5; 2; 8; 1; 6; 4; 9 |]
     ; [| 4; 1; 8; 0; 6; 3; 9; 2; 7; 5 |]
     ; [| 5; 6; 2; 9; 0; 7; 4; 1; 3; 8 |]
     ; [| 6; 9; 7; 3; 1; 0; 8; 5; 2; 4 |]
     ; [| 7; 5; 1; 8; 4; 2; 0; 9; 6; 3 |]
     ; [| 8; 4; 6; 2; 9; 5; 3; 0; 1; 7 |]
     ; [| 9; 8; 5; 7; 3; 1; 6; 4; 0; 2 |]
     ; [| 1; 3; 9; 6; 8; 4; 2; 7; 5; 0 |]
    |]
  in
  let result = Tools.Damm.checksum ~table:custom_table "816" in
  Alcotest.(check int) "test_custom_table" 9 result

let suite =
  [
    ("test_checksum_valid", `Quick, test_checksum_valid)
  ; ("test_checksum_invalid", `Quick, test_checksum_invalid)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid", `Quick, test_validate_invalid)
  ; ("test_validate_empty", `Quick, test_validate_empty)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_custom_table", `Quick, test_custom_table)
  ]

let () = Alcotest.run "Tools.Damm" [ ("suite", suite) ]
