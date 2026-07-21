let test_compact () =
  let result = Au.Tfn.compact " 123 456 782 " in
  Alcotest.(check string) "test_compact" "123456782" result

let test_checksum () =
  let result = Au.Tfn.checksum "123456782" in
  Alcotest.(check int) "test_checksum" 0 result

let test_validate () =
  let result = Au.Tfn.validate "123 456 782" in
  Alcotest.(check string) "test_validate" "123456782" result

let test_validate_invalid_checksum () =
  try
    ignore (Au.Tfn.validate "999 999 999");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Au.Tfn.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Au.Tfn.validate "123 456 7");
    Alcotest.fail "Expected Invalid_length exception"
  with Au.Tfn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Au.Tfn.validate "123 456 78A");
    Alcotest.fail "Expected Invalid_format exception"
  with Au.Tfn.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [ ("123 456 782", true); ("999 999 999", false); ("123456782", true) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Au.Tfn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Au.Tfn.format "123456782" in
  Alcotest.(check string) "test_format" "123 456 782" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Au.Tfn" [ ("suite", suite) ]
