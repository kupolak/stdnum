let test_compact () =
  let test_cases =
    [
      ("RCCMNL83S18D969H", "RCCMNL83S18D969H")
    ; ("rccmnl83s18d969h", "RCCMNL83S18D969H")
    ; ("RCC MNL 83S18 D969H", "RCCMNL83S18D969H")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Codicefiscale.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("RCCMNL83S18D969", "H"); ("CNTCHR83T41D969", "D") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Codicefiscale.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_get_birth_date () =
  let test_cases =
    [
      ("RCCMNL83S18D969H", (1983, 11, 18))
    ; ("CNTCHR83T41D969D", (1983, 12, 1))
      (* Female, day = 41, so actual day = 1 *)
    ]
  in
  List.iter
    (fun (input, (exp_year, exp_month, exp_day)) ->
      let _time, tm = It_stdnum.Codicefiscale.get_birth_date input in
      Alcotest.(check int)
        ("test_birth_year_" ^ input)
        exp_year (tm.Unix.tm_year + 1900);
      Alcotest.(check int)
        ("test_birth_month_" ^ input)
        exp_month (tm.Unix.tm_mon + 1);
      Alcotest.(check int) ("test_birth_day_" ^ input) exp_day tm.Unix.tm_mday)
    test_cases

let test_get_gender () =
  let test_cases = [ ("RCCMNL83S18D969H", "M"); ("CNTCHR83T41D969D", "F") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Codicefiscale.get_gender input in
      Alcotest.(check string)
        ("test_get_gender_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("RCCMNL83S18D969H", "RCCMNL83S18D969H") (* Personal number *)
    ; ("CNTCHR83T41D969D", "CNTCHR83T41D969D") (* Personal number, female *)
    ; ("00743110157", "00743110157") (* Company number (IVA) *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Codicefiscale.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("RCCMNL83S18D969H", true) (* Valid personal number *)
    ; ("CNTCHR83T41D969D", true) (* Valid personal number, female *)
    ; ("00743110157", true) (* Valid company number *)
    ; ("RCCMNL83S18D969", false) (* Too short *)
    ; ("RCCMNL83S18D969G", false) (* Invalid check digit *)
    ; ("00743110158", false) (* Invalid company checksum *)
    ; ("RCCMNL83S99D969H", false) (* Invalid date *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Codicefiscale.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "It_stdnum.Codicefiscale" [ ("suite", suite) ]
