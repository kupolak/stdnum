let test_compact () =
  let result = Bg.Pnf.compact " 7111 042 925 " in
  Alcotest.(check string) "test_compact" "7111042925" result

let test_calc_check_digit () =
  let result = Bg.Pnf.calc_check_digit "711104292" in
  Alcotest.(check string) "test_calc_check_digit" "5" result

let test_validate () =
  let result = Bg.Pnf.validate "7111 042 925" in
  Alcotest.(check string) "test_validate" "7111042925" result

let test_validate_invalid_checksum () =
  try
    ignore (Bg.Pnf.validate "7111042922");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Bg.Pnf.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Bg.Pnf.validate "711104292");
    Alcotest.fail "Expected Invalid_length exception"
  with Bg.Pnf.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Bg.Pnf.validate "71110A2922");
    Alcotest.fail "Expected Invalid_format exception"
  with Bg.Pnf.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [ ("7111 042 925", true); ("7111042922", false); ("71110A2922", false) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Bg.Pnf.is_valid input in
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

let () = Alcotest.run "Stdnum.Bg.Pnf" [ ("suite", suite) ]
