let test_compact () =
  let result = Gt.Nit.compact " 0576937-K " in
  Alcotest.(check string) "test_compact" "576937K" result

let test_validate () =
  let result = Gt.Nit.validate "576937-K" in
  Alcotest.(check string) "test_validate" "576937K" result

let test_validate_invalid_checksum () =
  try
    ignore (Gt.Nit.validate "8977112-0");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gt.Nit.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Gt.Nit.validate "1234567890123");
    Alcotest.fail "Expected Invalid_length exception"
  with Gt.Nit.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("576937-K", true)
    ; ("7108-0", true)
    ; ("8977112-0", false)
    ; ("1234567890123", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gt.Nit.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Gt.Nit.format "39525503" in
  Alcotest.(check string) "test_format" "3952550-3" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Gt.Nit" [ ("suite", suite) ]
