let test_compact () =
  let result = Gb.Vat.compact " GB 980 7806 84 " in
  Alcotest.(check string) "test_compact" "980780684" result

let test_validate () =
  let result = Gb.Vat.validate "GB 980 7806 84" in
  Alcotest.(check string) "test_validate" "980780684" result

let test_validate_invalid_checksum () =
  try
    ignore (Gb.Vat.validate "802311781");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gb.Vat.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Gb.Vat.validate "FR 40 303");
    Alcotest.fail "Expected Invalid_length exception"
  with Gb.Vat.Invalid_length -> ()

let test_validate_invalid_component () =
  try
    ignore (Gb.Vat.validate "XX123");
    Alcotest.fail "Expected Invalid_component exception"
  with Gb.Vat.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("GB 980 7806 84", true)
    ; ("802311781", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gb.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Gb.Vat.format "980780684" in
  Alcotest.(check string) "test_format" "980 7806 84" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Gb.Vat" [ ("suite", suite) ]
