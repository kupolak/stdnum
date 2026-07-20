let test_compact () =
  let result = Eg.Tn.compact " ٣٣١-١٠٥-٢٦٨ " in
  Alcotest.(check string) "test_compact" "331105268" result

let test_validate () =
  let result = Eg.Tn.validate "100-531-385" in
  Alcotest.(check string) "test_validate_1" "100531385" result;
  let result2 = Eg.Tn.validate "٣٣١-١٠٥-٢٦٨" in
  Alcotest.(check string) "test_validate_2" "331105268" result2

let test_validate_invalid_length () =
  try
    ignore (Eg.Tn.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Eg.Tn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Eg.Tn.validate "VV3456789");
    Alcotest.fail "Expected Invalid_format exception"
  with Eg.Tn.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("100-531-385", true)
    ; ("٣٣١-١٠٥-٢٦٨", true)
    ; ("12345", false)
    ; ("VV3456789", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Eg.Tn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Eg.Tn.format "100531385" in
  Alcotest.(check string) "test_format" "100-531-385" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Eg.Tn" [ ("suite", suite) ]
