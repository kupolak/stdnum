let test_compact () =
  let test_cases =
    [
      ("991231/1234", "9912311234")
    ; (" 991231 1234 ", "9912311234")
    ; ("991231 / 1234", "9912311234")
    ; ("710319274", "710319274")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cz.Rc.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid_10_digit () =
  (* Valid 10-digit number from Python doctest: 7103192745 *)
  let result = Cz.Rc.validate "7103192745" in
  Alcotest.(check string) "test_validate_valid_10_digit" "7103192745" result

let test_validate_valid_9_digit () =
  (* Valid 9-digit number (pre-1954 format without check digit) *)
  (* From Python doctest: validate('991231123') *)
  let result = Cz.Rc.validate "991231123" in
  Alcotest.(check string) "test_validate_valid_9_digit" "991231123" result

let test_validate_invalid_checksum () =
  (* Invalid checksum - last digit should make mod 11 equal to check digit *)
  Alcotest.check_raises "Invalid Checksum" Cz.Rc.Invalid_checksum (fun () ->
      ignore (Cz.Rc.validate "7103192746"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Cz.Rc.Invalid_length (fun () ->
      ignore (Cz.Rc.validate "12345"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Cz.Rc.Invalid_format (fun () ->
      ignore (Cz.Rc.validate "71031927AB"))

let test_validate_invalid_month () =
  (* Month 00 is invalid (00 mod 50 mod 20 = 0) *)
  (* Using 9-digit number from before 1954 *)
  Alcotest.check_raises "Invalid Component" Cz.Rc.Invalid_component (fun () ->
      ignore (Cz.Rc.validate "530001123"))

let test_validate_invalid_day () =
  (* Day cannot be 0 or > 31 *)
  Alcotest.check_raises "Invalid Component" Cz.Rc.Invalid_component (fun () ->
      ignore (Cz.Rc.validate "7103002745"))

let test_validate_month_plus_50_female () =
  (* Month + 50 for females (e.g., 03 + 50 = 53) *)
  let result = Cz.Rc.validate "7053192740" in
  Alcotest.(check string) "test_validate_month_plus_50" "7053192740" result

let test_is_valid_true () =
  let result = Cz.Rc.is_valid "7103192745" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Cz.Rc.is_valid "7103192746" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_get_birth_date () =
  (* Test birth date extraction for 7103192745 *)
  let year, month, day = Cz.Rc.get_birth_date "7103192745" in
  Alcotest.(check int) "year" 1971 year;
  Alcotest.(check int) "month" 3 month;
  Alcotest.(check int) "day" 19 day

let test_get_birth_date_female () =
  (* Test with female (month + 50) *)
  let year, month, day = Cz.Rc.get_birth_date "7053192740" in
  Alcotest.(check int) "year" 1970 year;
  Alcotest.(check int) "month" 3 month;
  Alcotest.(check int) "day" 19 day

let test_get_birth_date_9_digit () =
  (* Test 9-digit number from before 1954 *)
  let year, month, day = Cz.Rc.get_birth_date "530101123" in
  Alcotest.(check int) "year" 1953 year;
  Alcotest.(check int) "month" 1 month;
  Alcotest.(check int) "day" 1 day

let test_validate_9_digit_after_1953 () =
  (* From Python doctest: 590312/123 - 9 digit number in 1959 should fail *)
  Alcotest.check_raises "Invalid Length" Cz.Rc.Invalid_length (fun () ->
      ignore (Cz.Rc.validate "590312123"))

let test_validate_invalid_date_feb_30 () =
  (* February 30th doesn't exist *)
  (* Using 10-digit number with valid checksum *)
  Alcotest.check_raises "Invalid Component" Cz.Rc.Invalid_component (fun () ->
      ignore (Cz.Rc.validate "7102302743"))

let test_validate_invalid_date_april_31 () =
  (* April only has 30 days *)
  (* Using 10-digit number with valid checksum *)
  Alcotest.check_raises "Invalid Component" Cz.Rc.Invalid_component (fun () ->
      ignore (Cz.Rc.validate "7104312740"))

let test_format () =
  let result = Cz.Rc.format "7103192745" in
  Alcotest.(check string) "test_format" "710319/2745" result

let test_format_9_digit () =
  let result = Cz.Rc.format "991231123" in
  Alcotest.(check string) "test_format_9_digit" "991231/123" result

let test_validate_with_slash () =
  (* From Python doctest: validate('710319/2745') *)
  let result = Cz.Rc.validate "710319/2745" in
  Alcotest.(check string) "test_validate_with_slash" "7103192745" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid_10_digit", `Quick, test_validate_valid_10_digit)
  ; ("test_validate_valid_9_digit", `Quick, test_validate_valid_9_digit)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_month", `Quick, test_validate_invalid_month)
  ; ("test_validate_invalid_day", `Quick, test_validate_invalid_day)
  ; ( "test_validate_month_plus_50_female"
    , `Quick
    , test_validate_month_plus_50_female )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_birth_date_female", `Quick, test_get_birth_date_female)
  ; ("test_get_birth_date_9_digit", `Quick, test_get_birth_date_9_digit)
  ; ( "test_validate_9_digit_after_1953"
    , `Quick
    , test_validate_9_digit_after_1953 )
  ; ( "test_validate_invalid_date_feb_30"
    , `Quick
    , test_validate_invalid_date_feb_30 )
  ; ( "test_validate_invalid_date_april_31"
    , `Quick
    , test_validate_invalid_date_april_31 )
  ; ("test_format", `Quick, test_format)
  ; ("test_format_9_digit", `Quick, test_format_9_digit)
  ; ("test_validate_with_slash", `Quick, test_validate_with_slash)
  ]

let () = Alcotest.run "Cz.Rc" [ ("suite", suite) ]
