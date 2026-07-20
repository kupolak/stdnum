let test_compact () =
  let result = At.Uid.compact " AT U13585627 " in
  Alcotest.(check string) "test_compact" "U13585627" result

let test_calc_check_digit () =
  let result = At.Uid.calc_check_digit "U1358562" in
  Alcotest.(check string) "test_calc_check_digit" "7" result

let test_validate () =
  let result = At.Uid.validate "AT U13585627" in
  Alcotest.(check string) "test_validate" "U13585627" result

let test_validate_invalid_checksum () =
  try
    ignore (At.Uid.validate "U13585626");
    Alcotest.fail "Expected Invalid_checksum exception"
  with At.Uid.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (At.Uid.validate "U1358562");
    Alcotest.fail "Expected Invalid_length exception"
  with At.Uid.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (At.Uid.validate "X13585627");
    Alcotest.fail "Expected Invalid_format exception"
  with At.Uid.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("AT U13585627", true)
    ; ("U13585626", false)
    ; ("X13585627", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = At.Uid.is_valid input in
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

let () = Alcotest.run "Stdnum.At.Uid" [ ("suite", suite) ]
