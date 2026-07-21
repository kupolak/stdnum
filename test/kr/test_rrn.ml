let test_compact () =
  let result = Kr.Rrn.compact " 971013 - 9019902 " in
  Alcotest.(check string) "test_compact" "9710139019902" result

let test_validate () =
  let result = Kr.Rrn.validate "971013-9019902" in
  Alcotest.(check string) "test_validate" "9710139019902" result

let test_validate_invalid_length () =
  try
    ignore (Kr.Rrn.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Kr.Rrn.Invalid_length -> ()

let test_validate_invalid_checksum () =
  try
    ignore (Kr.Rrn.validate "971013-9019903");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Kr.Rrn.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("971013-9019902", true)
    ; ("971013-9019903", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Kr.Rrn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Kr.Rrn.format "9710139019902" in
  Alcotest.(check string) "test_format" "971013-9019902" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Kr.Rrn" [ ("suite", suite) ]
