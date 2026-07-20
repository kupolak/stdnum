let test_compact () =
  let result = Gb.Sedol.compact " B15KXQ8 " in
  Alcotest.(check string) "test_compact" "B15KXQ8" result

let test_calc_check_digit () =
  let result = Gb.Sedol.calc_check_digit "B15KXQ" in
  Alcotest.(check string) "test_calc_check_digit" "8" result

let test_validate () =
  let result = Gb.Sedol.validate "B15KXQ8" in
  Alcotest.(check string) "test_validate" "B15KXQ8" result

let test_validate_invalid_checksum () =
  try
    ignore (Gb.Sedol.validate "B15KXQ7");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gb.Sedol.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Gb.Sedol.validate "B15KXQ");
    Alcotest.fail "Expected Invalid_length exception"
  with Gb.Sedol.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Gb.Sedol.validate "B15KXA8");
    Alcotest.fail "Expected Invalid_format exception"
  with Gb.Sedol.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("B15KXQ8", true)
    ; ("B15KXQ7", false)
    ; ("B15KXQ", false)
    ; ("B15KXA8", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gb.Sedol.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_to_isin () =
  let result = Gb.Sedol.to_isin "B15KXQ8" in
  Alcotest.(check string) "test_to_isin" "GB00B15KXQ89" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_to_isin", `Quick, test_to_isin)
  ]

let () = Alcotest.run "Stdnum.Gb.Sedol" [ ("suite", suite) ]
