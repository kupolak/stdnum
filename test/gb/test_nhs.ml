let test_compact () =
  let result = Gb.Nhs.compact " 943-476-5870 " in
  Alcotest.(check string) "test_compact" "9434765870" result

let test_validate () =
  let result = Gb.Nhs.validate "943-476-5870" in
  Alcotest.(check string) "test_validate" "9434765870" result

let test_validate_invalid_checksum () =
  try
    ignore (Gb.Nhs.validate "9434765871");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gb.Nhs.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Gb.Nhs.validate "943476587");
    Alcotest.fail "Expected Invalid_length exception"
  with Gb.Nhs.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Gb.Nhs.validate "943476587A");
    Alcotest.fail "Expected Invalid_format exception"
  with Gb.Nhs.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("9434765870", true)
    ; ("9434765871", false)
    ; ("943476587", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gb.Nhs.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Gb.Nhs.format "9434765870" in
  Alcotest.(check string) "test_format" "943 476 5870" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Gb.Nhs" [ ("suite", suite) ]
