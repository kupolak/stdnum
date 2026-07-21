let test_compact () =
  let result = Ie.Vat.compact " IE 6433435F " in
  Alcotest.(check string) "test_compact" "6433435F" result

let test_validate () =
  let result = Ie.Vat.validate "IE 6433435OA" in
  Alcotest.(check string) "test_validate" "6433435OA" result

let test_validate_invalid_checksum () =
  try
    ignore (Ie.Vat.validate "6433435E");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ie.Vat.Invalid_checksum -> ()

let test_validate_old_style () =
  let result = Ie.Vat.validate "8D79739I" in
  Alcotest.(check string) "test_validate_old_style" "8D79739I" result

let test_validate_incorrect_old_style () =
  try
    ignore (Ie.Vat.validate "8?79739J");
    Alcotest.fail "Expected Invalid_format exception"
  with Ie.Vat.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("IE 6433435F", true)
    ; ("IE 6433435OA", true)
    ; ("6433435E", false)
    ; ("8D79739I", true)
    ; ("8?79739J", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ie.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_convert () =
  let result = Ie.Vat.convert "1F23456T" in
  Alcotest.(check string) "test_convert" "0234561T" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_old_style", `Quick, test_validate_old_style)
  ; ("test_validate_incorrect_old_style", `Quick, test_validate_incorrect_old_style)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_convert", `Quick, test_convert)
  ]

let () = Alcotest.run "Stdnum.Ie.Vat" [ ("suite", suite) ]
