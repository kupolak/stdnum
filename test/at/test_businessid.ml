let test_compact () =
  let result = At.Businessid.compact " FN 122119m " in
  Alcotest.(check string) "test_compact" "122119m" result

let test_validate () =
  let result = At.Businessid.validate "FN 122119m" in
  Alcotest.(check string) "test_validate" "122119m" result

let test_validate_no_prefix () =
  let result = At.Businessid.validate "122119m" in
  Alcotest.(check string) "test_validate_no_prefix" "122119m" result

let test_validate_invalid_format_starts_with_letter () =
  try
    ignore (At.Businessid.validate "m123123");
    Alcotest.fail "Expected Invalid_format exception"
  with At.Businessid.Invalid_format -> ()

let test_validate_invalid_format_all_letters () =
  try
    ignore (At.Businessid.validate "abc");
    Alcotest.fail "Expected Invalid_format exception"
  with At.Businessid.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("FN 122119m", true)
    ; ("122119m", true)
    ; ("m123123", false)
    ; ("abc", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = At.Businessid.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_no_prefix", `Quick, test_validate_no_prefix)
  ; ("test_validate_invalid_format_starts_with_letter", `Quick, test_validate_invalid_format_starts_with_letter)
  ; ("test_validate_invalid_format_all_letters", `Quick, test_validate_invalid_format_all_letters)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.At.Businessid" [ ("suite", suite) ]
