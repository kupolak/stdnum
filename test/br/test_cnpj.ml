let test_compact () =
  let result = Br.Cnpj.compact " 16.727.230/0001-97 " in
  Alcotest.(check string) "test_compact" "16727230000197" result

let test_calc_check_digits () =
  let result = Br.Cnpj.calc_check_digits "16727230000197" in
  Alcotest.(check string) "test_calc_check_digits" "97" result

let test_validate () =
  let result = Br.Cnpj.validate "16.727.230/0001-97" in
  Alcotest.(check string) "test_validate" "16727230000197" result

let test_validate_new_format () =
  let result = Br.Cnpj.validate "12. ABC.345 /01DE-35" in
  Alcotest.(check string) "test_validate_new_format" "12ABC34501DE35" result

let test_validate_invalid_checksum () =
  try
    ignore (Br.Cnpj.validate "16.727.230.0001-98");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Br.Cnpj.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Br.Cnpj.validate "1672723000019");
    Alcotest.fail "Expected Invalid_length exception"
  with Br.Cnpj.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Br.Cnpj.validate "16.727.230/0001=97");
    Alcotest.fail "Expected Invalid_format exception"
  with Br.Cnpj.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("16.727.230/0001-97", true)
    ; ("12. ABC.345 /01DE-35", true)
    ; ("16.727.230.0001-98", false)
    ; ("16.727.230/0001=97", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Br.Cnpj.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Br.Cnpj.format "16727230000197" in
  Alcotest.(check string) "test_format" "16.727.230/0001-97" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_new_format", `Quick, test_validate_new_format)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Br.Cnpj" [ ("suite", suite) ]
