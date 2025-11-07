let test_compact () =
  let test_cases =
    [
      ("1234567/M/A/E/001", "1234567MAE001")
    ; ("1282182 W", "1282182W")
    ; ("121J", "0000121J")
    ; (" 1496298 T P N 000 ", "1496298TPN000")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Tn.Mf.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  let test_cases =
    [
      ("1234567/M/A/E/001", "1234567MAE001")
    ; ("1282182 W", "1282182W")
    ; ("121J", "0000121J")
    ; ("1496298 T P N 000", "1496298TPN000")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Tn.Mf.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_invalid_control_key () =
  Alcotest.check_raises "Invalid Format (control key U)" Tn.Mf.Invalid_format
    (fun () -> ignore (Tn.Mf.validate "1219773U"))

let test_validate_invalid_category_code () =
  Alcotest.check_raises "Invalid Format (category code X)" Tn.Mf.Invalid_format
    (fun () -> ignore (Tn.Mf.validate "1234567/M/A/X/000"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Tn.Mf.Invalid_length (fun () ->
      ignore (Tn.Mf.validate "123"))

let test_is_valid_true () =
  let result = Tn.Mf.is_valid "1234567/M/A/E/001" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Tn.Mf.is_valid "1219773U" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format_short () =
  let result = Tn.Mf.format "121J" in
  Alcotest.(check string) "test_format_short" "0000121/J" result

let test_format_long () =
  let result = Tn.Mf.format "1496298 T P N 000" in
  Alcotest.(check string) "test_format_long" "1496298/T/P/N/000" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ( "test_validate_invalid_control_key"
    , `Quick
    , test_validate_invalid_control_key )
  ; ( "test_validate_invalid_category_code"
    , `Quick
    , test_validate_invalid_category_code )
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format_short", `Quick, test_format_short)
  ; ("test_format_long", `Quick, test_format_long)
  ]

let () = Alcotest.run "Tn.Mf" [ ("suite", suite) ]
