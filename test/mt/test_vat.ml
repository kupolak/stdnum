let test_compact () =
  let result = Mt.Vat.compact " MT 1167-9112 " in
  Alcotest.(check string) "test_compact" "11679112" result

let test_validate () =
  let result = Mt.Vat.validate "MT 1167-9112" in
  Alcotest.(check string) "test_validate" "11679112" result

let test_validate_invalid_checksum () =
  try
    ignore (Mt.Vat.validate "1167-9113");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Mt.Vat.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("MT 1167-9112", true)
    ; ("1167-9113", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Mt.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Mt.Vat" [ ("suite", suite) ]
