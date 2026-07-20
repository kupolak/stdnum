let test_compact () =
  let result = Bg.Vat.compact " BG 175 074 752 " in
  Alcotest.(check string) "test_compact" "175074752" result

let test_validate () =
  let result = Bg.Vat.validate "175074752" in
  Alcotest.(check string) "test_validate" "175074752" result

let test_validate_10_digits_egn () =
  (* test with valid EGN *)
  let result = Bg.Vat.validate "8032056031" in
  Alcotest.(check string) "test_validate_10_digits_egn" "8032056031" result

let test_validate_10_digits_pnf () =
  (* test with valid PNF *)
  let result = Bg.Vat.validate "7111042925" in
  Alcotest.(check string) "test_validate_10_digits_pnf" "7111042925" result

let test_validate_invalid_checksum () =
  try
    ignore (Bg.Vat.validate "175074751");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Bg.Vat.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Bg.Vat.validate "17507475");
    Alcotest.fail "Expected Invalid_length exception"
  with Bg.Vat.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Bg.Vat.validate "17507475A");
    Alcotest.fail "Expected Invalid_format exception"
  with Bg.Vat.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("175074752", true)
    ; ("175074751", false)
    ; ("BG 175 074 752", true)
    ; ("8032056031", true) (* Valid EGN *)
    ; ("7111042925", true) (* Valid PNF *)
    ; ("8032056032", false) (* Invalid 10-digit number *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Bg.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_10_digits_egn", `Quick, test_validate_10_digits_egn)
  ; ("test_validate_10_digits_pnf", `Quick, test_validate_10_digits_pnf)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Bg.Vat" [ ("suite", suite) ]
