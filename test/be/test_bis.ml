let test_compact () =
  let test_cases =
    [
      ("98.47.28-997.65", "98472899765")
    ; ("98 47 28 997 65", "98472899765")
    ; (" 01.49.07-001.85 ", "01490700185")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Be.Bis.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  (* From Python doctest: validate('98 47 28 997 65') *)
  let result = Be.Bis.validate "98 47 28 997 65" in
  Alcotest.(check string) "test_validate_valid" "98472899765" result

let test_validate_valid_month_49 () =
  (* From Python doctest: validate('01 49 07 001 85') *)
  let result = Be.Bis.validate "01 49 07 001 85" in
  Alcotest.(check string) "test_validate_valid_month_49" "01490700185" result

let test_validate_invalid_checksum () =
  (* BIS number with valid month (47) but invalid checksum *)
  Alcotest.check_raises "Invalid Checksum" Be.Bis.Invalid_checksum (fun () ->
      ignore (Be.Bis.validate "98472899766"))

let test_validate_invalid_month_range () =
  (* Month not in 20..32 or 40..52 range - use month 15 with valid checksum *)
  Alcotest.check_raises "Invalid Component"
    (Be.Bis.Invalid_component "Month must be in 20..32 or 40..52 range")
    (fun () -> ignore (Be.Bis.validate "98152899735"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Be.Bis.Invalid_length (fun () ->
      ignore (Be.Bis.validate "984728997"))

let test_format () =
  (* From Python doctest: format('98472899765') *)
  let result = Be.Bis.format "98472899765" in
  Alcotest.(check string) "test_format" "98.47.28-997.65" result

let test_get_birth_date () =
  (* From Python doctest: get_birth_date('98.47.28-997.65') *)
  let result = Be.Bis.get_birth_date "98.47.28-997.65" in
  match result with
  | Some (year, month, day) ->
      Alcotest.(check int) "year" 1998 year;
      Alcotest.(check int) "month" 7 month;
      Alcotest.(check int) "day" 28 day
  | None -> Alcotest.fail "Expected Some date"

let test_get_birth_year () =
  (* From Python doctest: get_birth_year('98.47.28-997.65') *)
  let result = Be.Bis.get_birth_year "98.47.28-997.65" in
  match result with
  | Some year -> Alcotest.(check int) "year" 1998 year
  | None -> Alcotest.fail "Expected Some year"

let test_get_birth_month () =
  (* From Python doctest: get_birth_month('98.47.28-997.65') *)
  let result = Be.Bis.get_birth_month "98.47.28-997.65" in
  match result with
  | Some month -> Alcotest.(check int) "month" 7 month
  | None -> Alcotest.fail "Expected Some month"

let test_get_gender_known () =
  (* From Python doctest: get_gender('98.47.28-997.65') - month 47 >= 40, so gender is known *)
  let result = Be.Bis.get_gender "98.47.28-997.65" in
  match result with
  | Some gender -> Alcotest.(check string) "gender" "M" gender
  | None -> Alcotest.fail "Expected Some gender"

let test_get_gender_unknown () =
  (* Month in 20..32 range, gender unknown *)
  let result = Be.Bis.get_gender "98272899765" in
  match result with
  | None -> () (* Expected *)
  | Some _ -> Alcotest.fail "Expected None for unknown gender"

let test_is_valid_true () =
  let result = Be.Bis.is_valid "98 47 28 997 65" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Be.Bis.is_valid "12345678901" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid_month_49", `Quick, test_validate_valid_month_49)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ( "test_validate_invalid_month_range"
    , `Quick
    , test_validate_invalid_month_range )
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_format", `Quick, test_format)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_birth_year", `Quick, test_get_birth_year)
  ; ("test_get_birth_month", `Quick, test_get_birth_month)
  ; ("test_get_gender_known", `Quick, test_get_gender_known)
  ; ("test_get_gender_unknown", `Quick, test_get_gender_unknown)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Be.Bis" [ ("suite", suite) ]
