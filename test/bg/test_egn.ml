let test_compact () =
  let result = Bg.Egn.compact " 752316 926 3 " in
  Alcotest.(check string) "test_compact" "7523169263" result

let test_calc_check_digit () =
  let result = Bg.Egn.calc_check_digit "752316926" in
  Alcotest.(check string) "test_calc_check_digit" "3" result

let test_get_birth_date () =
  let y, m, d = Bg.Egn.get_birth_date "7542011030" in
  Alcotest.(check int) "year" 2075 y;
  Alcotest.(check int) "month" 2 m;
  Alcotest.(check int) "day" 1 d

let test_validate () =
  let result = Bg.Egn.validate "8032056031" in
  Alcotest.(check string) "test_validate" "8032056031" result

let test_validate_invalid_checksum () =
  try
    ignore (Bg.Egn.validate "8032056032");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Bg.Egn.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Bg.Egn.validate "803205603");
    Alcotest.fail "Expected Invalid_length exception"
  with Bg.Egn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Bg.Egn.validate "7552A10004");
    Alcotest.fail "Expected Invalid_format exception"
  with Bg.Egn.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (Bg.Egn.validate "8019010008");
    Alcotest.fail "Expected Invalid_component exception"
  with Bg.Egn.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("8032056031", true)
    ; ("8032056032", false)
    ; ("7552A10004", false)
    ; ("8019010008", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Bg.Egn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Bg.Egn" [ ("suite", suite) ]
