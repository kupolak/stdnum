let test_compact () =
  let test_cases =
    [
      ("00192200M", "00192200M")
    ; ("197401143C", "197401143C")
    ; (" S16FC0121D ", "S16FC0121D")
    ; ("t01fc6132d", "T01FC6132D")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Sg.Uen.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_business_check_digit () =
  let result = Sg.Uen.calc_business_check_digit "00192200M" in
  Alcotest.(check string) "test_calc_business_check_digit" "M" result

let test_calc_local_company_check_digit () =
  let result = Sg.Uen.calc_local_company_check_digit "197401143C" in
  Alcotest.(check string) "test_calc_local_company_check_digit" "C" result

let test_calc_other_check_digit () =
  let result = Sg.Uen.calc_other_check_digit "S16FC0121D" in
  Alcotest.(check string) "test_calc_other_check_digit" "D" result

let test_validate_business () =
  let result = Sg.Uen.validate "00192200M" in
  Alcotest.(check string) "test_validate_business" "00192200M" result

let test_validate_local_company () =
  let result = Sg.Uen.validate "197401143C" in
  Alcotest.(check string) "test_validate_local_company" "197401143C" result

let test_validate_other_s () =
  let result = Sg.Uen.validate "S16FC0121D" in
  Alcotest.(check string) "test_validate_other_s" "S16FC0121D" result

let test_validate_other_t () =
  let result = Sg.Uen.validate "T01FC6132D" in
  Alcotest.(check string) "test_validate_other_t" "T01FC6132D" result

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Sg.Uen.Invalid_length (fun () ->
      ignore (Sg.Uen.validate "123456"))

let test_validate_invalid_checksum_business () =
  Alcotest.check_raises "Invalid Checksum" Sg.Uen.Invalid_checksum (fun () ->
      ignore (Sg.Uen.validate "00192200X"))

let test_validate_invalid_checksum_local () =
  Alcotest.check_raises "Invalid Checksum" Sg.Uen.Invalid_checksum (fun () ->
      ignore (Sg.Uen.validate "197401143X"))

let test_is_valid_true_business () =
  let result = Sg.Uen.is_valid "00192200M" in
  Alcotest.(check bool) "test_is_valid_true_business" true result

let test_is_valid_true_local () =
  let result = Sg.Uen.is_valid "197401143C" in
  Alcotest.(check bool) "test_is_valid_true_local" true result

let test_is_valid_true_other () =
  let result = Sg.Uen.is_valid "S16FC0121D" in
  Alcotest.(check bool) "test_is_valid_true_other" true result

let test_is_valid_false () =
  let result = Sg.Uen.is_valid "123456" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_business_check_digit", `Quick, test_calc_business_check_digit)
  ; ( "test_calc_local_company_check_digit"
    , `Quick
    , test_calc_local_company_check_digit )
  ; ("test_calc_other_check_digit", `Quick, test_calc_other_check_digit)
  ; ("test_validate_business", `Quick, test_validate_business)
  ; ("test_validate_local_company", `Quick, test_validate_local_company)
  ; ("test_validate_other_s", `Quick, test_validate_other_s)
  ; ("test_validate_other_t", `Quick, test_validate_other_t)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_checksum_business"
    , `Quick
    , test_validate_invalid_checksum_business )
  ; ( "test_validate_invalid_checksum_local"
    , `Quick
    , test_validate_invalid_checksum_local )
  ; ("test_is_valid_true_business", `Quick, test_is_valid_true_business)
  ; ("test_is_valid_true_local", `Quick, test_is_valid_true_local)
  ; ("test_is_valid_true_other", `Quick, test_is_valid_true_other)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Sg.Uen" [ ("suite", suite) ]
