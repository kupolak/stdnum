let test_compact () =
  let test_cases =
    [
      ("85.07.30-033 28", "85073003328")
    ; ("85 07 30 033 28", "85073003328")
    ; (" 17.07.30-033.84 ", "17073003384")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Be.Nn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  (* From Python doctest: validate('85 07 30 033 28') *)
  let result = Be.Nn.validate "85 07 30 033 28" in
  Alcotest.(check string) "test_validate_valid" "85073003328" result

let test_validate_valid_2000s () =
  (* From Python doctest: validate('17 07 30 033 84') *)
  let result = Be.Nn.validate "17 07 30 033 84" in
  Alcotest.(check string) "test_validate_valid_2000s" "17073003384" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('12345678901') *)
  Alcotest.check_raises "Invalid Checksum" Be.Nn.Invalid_checksum (fun () ->
      ignore (Be.Nn.validate "12345678901"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Be.Nn.Invalid_length (fun () ->
      ignore (Be.Nn.validate "850730033"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Be.Nn.Invalid_format (fun () ->
      ignore (Be.Nn.validate "8507300332A"))

let test_format () =
  (* From Python doctest: format('85073003328') *)
  let result = Be.Nn.format "85073003328" in
  Alcotest.(check string) "test_format" "85.07.30-033.28" result

let test_get_birth_date () =
  (* From Python doctest: get_birth_date('85.07.30-033 28') *)
  let result = Be.Nn.get_birth_date "85.07.30-033 28" in
  match result with
  | Some (year, month, day) ->
      Alcotest.(check int) "year" 1985 year;
      Alcotest.(check int) "month" 7 month;
      Alcotest.(check int) "day" 30 day
  | None -> Alcotest.fail "Expected Some date"

let test_get_birth_year () =
  (* From Python doctest: get_birth_year('85.07.30-033 28') *)
  let result = Be.Nn.get_birth_year "85.07.30-033 28" in
  match result with
  | Some year -> Alcotest.(check int) "year" 1985 year
  | None -> Alcotest.fail "Expected Some year"

let test_get_birth_month () =
  (* From Python doctest: get_birth_month('85.07.30-033 28') *)
  let result = Be.Nn.get_birth_month "85.07.30-033 28" in
  match result with
  | Some month -> Alcotest.(check int) "month" 7 month
  | None -> Alcotest.fail "Expected Some month"

let test_get_gender_male () =
  (* From Python doctest: get_gender('85.07.30-033 28') *)
  let result = Be.Nn.get_gender "85.07.30-033 28" in
  Alcotest.(check string) "test_get_gender_male" "M" result

let test_get_gender_female () =
  let result = Be.Nn.get_gender "85073003428" in
  Alcotest.(check string) "test_get_gender_female" "F" result

let test_is_valid_true () =
  let result = Be.Nn.is_valid "85 07 30 033 28" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Be.Nn.is_valid "12345678901" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid_2000s", `Quick, test_validate_valid_2000s)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_format", `Quick, test_format)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_birth_year", `Quick, test_get_birth_year)
  ; ("test_get_birth_month", `Quick, test_get_birth_month)
  ; ("test_get_gender_male", `Quick, test_get_gender_male)
  ; ("test_get_gender_female", `Quick, test_get_gender_female)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Be.Nn" [ ("suite", suite) ]
