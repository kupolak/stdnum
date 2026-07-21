let test_compact () =
  let result = Cr.Dimex.compact " 155812994816 " in
  Alcotest.(check string) "test_compact" "155812994816" result

let test_validate () =
  let result = Cr.Dimex.validate "155812994816" in
  Alcotest.(check string) "test_validate" "155812994816" result

let test_validate_invalid_component () =
  try
    ignore (Cr.Dimex.validate "30123456789");
    Alcotest.fail "Expected Invalid_component exception"
  with Cr.Dimex.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (Cr.Dimex.validate "12345678");
    Alcotest.fail "Expected Invalid_length exception"
  with Cr.Dimex.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Cr.Dimex.validate "15581299481A");
    Alcotest.fail "Expected Invalid_format exception"
  with Cr.Dimex.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [ ("155812994816", true); ("30123456789", false); ("12345678", false) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cr.Dimex.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Cr.Dimex.format "122200569906" in
  Alcotest.(check string) "test_format" "122200569906" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Cr.Dimex" [ ("suite", suite) ]
