let test_compact () =
  let result = Fo.Vn.compact " FO 623.857 " in
  Alcotest.(check string) "test_compact" "623857" result

let test_validate () =
  let result = Fo.Vn.validate "623857" in
  Alcotest.(check string) "test_validate" "623857" result

let test_validate_invalid_length () =
  try
    ignore (Fo.Vn.validate "1234");
    Alcotest.fail "Expected Invalid_length exception"
  with Fo.Vn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Fo.Vn.validate "12345X");
    Alcotest.fail "Expected Invalid_format exception"
  with Fo.Vn.Invalid_format -> ()

let test_is_valid () =
  let test_cases = [ ("623857", true); ("1234", false); ("12345X", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Fo.Vn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Fo.Vn.format "602 590" in
  Alcotest.(check string) "test_format" "602590" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Fo.Vn" [ ("suite", suite) ]
