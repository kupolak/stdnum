let test_compact () =
  let test_cases =
    [
      ("85.07.30-033.28", "85073003328")
    ; ("17 07 30 033 84", "17073003384")
    ; (" 85073003328 ", "85073003328")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Be.Ssn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Be.Ssn.format "85073003328" in
  Alcotest.(check string) "test_format" "85.07.30-033.28" result

let test_validate_nn () =
  (* Validate a regular national number *)
  let result = Be.Ssn.validate "85.07.30-033.28" in
  Alcotest.(check string) "test_validate_nn" "85073003328" result

let test_validate_nn_2000s () =
  (* Validate a 2000s national number *)
  let result = Be.Ssn.validate "17 07 30 033 84" in
  Alcotest.(check string) "test_validate_nn_2000s" "17073003384" result

let test_validate_bis () =
  (* Validate a BIS number with month in 40+ range *)
  let result = Be.Ssn.validate "98 47 28 997 65" in
  Alcotest.(check string) "test_validate_bis" "98472899765" result

let test_validate_bis_month_40 () =
  (* Validate a BIS number with month >= 40 *)
  let result = Be.Ssn.validate "01 49 07 001 85" in
  Alcotest.(check string) "test_validate_bis_month_40" "01490700185" result

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Be.Ssn.Invalid_length (fun () ->
      ignore (Be.Ssn.validate "1234567"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Be.Ssn.Invalid_format (fun () ->
      ignore (Be.Ssn.validate "8507300332A"))

let test_validate_invalid_checksum () =
  (* Invalid checksum for both NN and BIS *)
  Alcotest.check_raises "Invalid Checksum" Be.Ssn.Invalid_checksum (fun () ->
      ignore (Be.Ssn.validate "85073003329"))

let test_is_valid_nn () =
  let result = Be.Ssn.is_valid "85.07.30-033.28" in
  Alcotest.(check bool) "test_is_valid_nn" true result

let test_is_valid_bis () =
  let result = Be.Ssn.is_valid "98 47 28 997 65" in
  Alcotest.(check bool) "test_is_valid_bis" true result

let test_is_valid_false () =
  let result = Be.Ssn.is_valid "85073003329" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_guess_type_nn () =
  let result = Be.Ssn.guess_type "85.07.30-033.28" in
  match result with
  | Some typ -> Alcotest.(check string) "guess_type_nn" "nn" typ
  | None -> Alcotest.fail "Expected Some type"

let test_guess_type_bis () =
  let result = Be.Ssn.guess_type "98 47 28 997 65" in
  match result with
  | Some typ -> Alcotest.(check string) "guess_type_bis" "bis" typ
  | None -> Alcotest.fail "Expected Some type"

let test_guess_type_invalid () =
  let result = Be.Ssn.guess_type "85073003329" in
  match result with
  | None -> () (* Expected *)
  | Some _ -> Alcotest.fail "Expected None for invalid number"

let test_get_birth_date_nn () =
  let result = Be.Ssn.get_birth_date "85.07.30-033.28" in
  match result with
  | Some date -> Alcotest.(check string) "birth_date_nn" "1985-07-30" date
  | None -> Alcotest.fail "Expected Some date"

let test_get_birth_date_bis () =
  (* BIS number - returns birth date with adjusted month *)
  let result = Be.Ssn.get_birth_date "98 47 28 997 65" in
  match result with
  | Some date -> Alcotest.(check string) "birth_date_bis" "1998-07-28" date
  | None -> Alcotest.fail "Expected Some date"

let test_get_birth_year_nn () =
  let result = Be.Ssn.get_birth_year "85.07.30-033.28" in
  match result with
  | Some year -> Alcotest.(check int) "birth_year_nn" 1985 year
  | None -> Alcotest.fail "Expected Some year"

let test_get_birth_month_nn () =
  let result = Be.Ssn.get_birth_month "85.07.30-033.28" in
  match result with
  | Some month -> Alcotest.(check int) "birth_month_nn" 7 month
  | None -> Alcotest.fail "Expected Some month"

let test_get_gender_nn_male () =
  let result = Be.Ssn.get_gender "85.07.30-033.28" in
  match result with
  | Some gender -> Alcotest.(check string) "gender_nn_male" "M" gender
  | None -> Alcotest.fail "Expected Some gender"

let test_get_gender_nn_female () =
  (* Female NN - counter must be even *)
  let result = Be.Ssn.get_gender "85073003427" in
  match result with
  | Some gender -> Alcotest.(check string) "gender_nn_female" "F" gender
  | None -> Alcotest.fail "Expected Some gender"

let test_get_gender_bis_unknown () =
  (* BIS with month in 20-32 range - gender unknown *)
  let result = Be.Ssn.get_gender "98272899765" in
  match result with
  | None -> () (* Expected *)
  | Some _ -> Alcotest.fail "Expected None for BIS gender (month < 40)"

let test_get_gender_bis_known () =
  (* BIS with month >= 40 - gender is known *)
  let result = Be.Ssn.get_gender "98 47 28 997 65" in
  match result with
  | Some gender -> Alcotest.(check string) "gender_bis_known" "M" gender
  | None -> Alcotest.fail "Expected Some gender for BIS with month >= 40"

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_nn", `Quick, test_validate_nn)
  ; ("test_validate_nn_2000s", `Quick, test_validate_nn_2000s)
  ; ("test_validate_bis", `Quick, test_validate_bis)
  ; ("test_validate_bis_month_40", `Quick, test_validate_bis_month_40)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_nn", `Quick, test_is_valid_nn)
  ; ("test_is_valid_bis", `Quick, test_is_valid_bis)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_guess_type_nn", `Quick, test_guess_type_nn)
  ; ("test_guess_type_bis", `Quick, test_guess_type_bis)
  ; ("test_guess_type_invalid", `Quick, test_guess_type_invalid)
  ; ("test_get_birth_date_nn", `Quick, test_get_birth_date_nn)
  ; ("test_get_birth_date_bis", `Quick, test_get_birth_date_bis)
  ; ("test_get_birth_year_nn", `Quick, test_get_birth_year_nn)
  ; ("test_get_birth_month_nn", `Quick, test_get_birth_month_nn)
  ; ("test_get_gender_nn_male", `Quick, test_get_gender_nn_male)
  ; ("test_get_gender_nn_female", `Quick, test_get_gender_nn_female)
  ; ("test_get_gender_bis_unknown", `Quick, test_get_gender_bis_unknown)
  ; ("test_get_gender_bis_known", `Quick, test_get_gender_bis_known)
  ]

let () = Alcotest.run "Be.Ssn" [ ("suite", suite) ]
