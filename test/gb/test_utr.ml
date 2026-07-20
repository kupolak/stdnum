let test_compact () =
  let result = Gb.Utr.compact " K 1955839661 " in
  Alcotest.(check string) "test_compact" "1955839661" result

let test_calc_check_digit () =
  let result = Gb.Utr.calc_check_digit "955839661" in
  Alcotest.(check string) "test_calc_check_digit" "1" result

let test_validate () =
  let result = Gb.Utr.validate "1955839661" in
  Alcotest.(check string) "test_validate" "1955839661" result

let test_validate_invalid_checksum () =
  try
    ignore (Gb.Utr.validate "2955839661");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gb.Utr.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Gb.Utr.validate "195583966");
    Alcotest.fail "Expected Invalid_length exception"
  with Gb.Utr.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Gb.Utr.validate "A955839661");
    Alcotest.fail "Expected Invalid_format exception"
  with Gb.Utr.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("1955839661", true)
    ; ("2955839661", false)
    ; ("195583966", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gb.Utr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Gb.Utr" [ ("suite", suite) ]
