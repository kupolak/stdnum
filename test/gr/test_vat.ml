let test_compact () =
  let result = Gr.Vat.compact " GR 23456783 " in
  Alcotest.(check string) "test_compact" "023456783" result

let test_validate () =
  let result = Gr.Vat.validate "EL 094259216 " in
  Alcotest.(check string) "test_validate" "094259216" result

let test_validate_invalid_checksum () =
  try
    ignore (Gr.Vat.validate "EL 123456781");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Gr.Vat.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("EL 094259216 ", true)
    ; ("EL 123456781", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Gr.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Gr.Vat" [ ("suite", suite) ]
