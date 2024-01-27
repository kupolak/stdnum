let test_compact () =
  let test_cases =
    [
      ("6188306736", "6188306736")
    ; ("5960099690", "5960099690")
    ; ("4240117063", "4240117063")
    ; ("3175666603", "3175666603")
    ; ("3389248056", "3389248056")
    ; ("6684906141", "6684906141")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Regon.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [
      ("6188306736", "9")
    ; ("5960099690", "2")
    ; ("4240117063", "2")
    ; ("3175666603", "0")
    ; ("3389248056", "2")
    ; ("6684906141", "3")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Regon.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("570007868", "570007868")
    ; ("362509447", "362509447")
    ; ("271747631", "271747631")
    ; ("190248215", "190248215")
    ; ("101624716", "101624716")
    ; ("021425170", "021425170")
    ; ("3389248056", "false")
    ; ("6684906141", "false")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result =
        try Pl.Regon.validate input
        with
        | Pl.Regon.Invalid_format | Pl.Regon.Invalid_length
        | Pl.Regon.Invalid_checksum
        ->
          "false"
      in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("570007868", true)
    ; ("362509447", true)
    ; ("271747631", true)
    ; ("190248215", true)
    ; ("101624716", true)
    ; ("021425170", true)
    ; ("3389248056", false)
    ; ("6684906141", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Regon.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Pl.Regon" [ ("suite", suite) ]
