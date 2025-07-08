let test_compact () =
  let test_cases =
    [
      ("4540536920", "4540536920")
    ; ("4540536921", "4540536921")
    ; ("454053692", "454053692")
    ; ("  4540536920  ", "4540536920")
    ; ("4540-536-920", "4540536920")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Tr.Vkn.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [ ("454053692", "0"); ("454053693", "8"); ("123456789", "0") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Tr.Vkn.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("4540536920", "4540536920")
    ; ("4540536921", "false")
    ; ("454053692", "false")
    ; ("123456789a", "false")
    ; ("12345678901", "false")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result =
        try Tr.Vkn.validate input
        with
        | Tr.Vkn.Invalid_format | Tr.Vkn.Invalid_length
        | Tr.Vkn.Invalid_checksum
        ->
          "false"
      in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("4540536920", true)
    ; ("4540536921", false)
    ; ("454053692", false)
    ; ("123456789a", false)
    ; ("12345678901", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Tr.Vkn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Tr.Vkn" [ ("suite", suite) ]
