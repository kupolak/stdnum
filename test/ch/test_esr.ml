let test_compact () =
  let test_cases =
    [
      ("21 00000 00003 13947 14300 09017", "210000000003139471430009017")
    ; ("210000000003139471430009017", "210000000003139471430009017")
    ; ("00018 78583", "1878583")
    ; ("18 78583", "1878583")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Esr.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [ ("21000000000313947143000901", "7"); ("000187858", "3") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Esr.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("21 00000 00003 13947 14300 09017", "210000000003139471430009017")
    ; ("18 78583", "1878583")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Esr.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("21 00000 00003 13947 14300 09017", true) (* Valid *)
    ; ("18 78583", true) (* Valid with leading zeros omitted *)
    ; ("210000000003139471430009016", false) (* Invalid checksum *)
    ; ("2100000000031394714300090171", false) (* Too long (28 digits) *)
    ; ("21000000000313947143A009017", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Esr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("18 78583", "00 00000 00000 00000 00018 78583")
    ; ("210000000003139471430009017", "21 00000 00003 13947 14300 09017")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Esr.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Ch.Esr" [ ("suite", suite) ]
