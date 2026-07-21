let test_compact () =
  let result = Hr.Oib.compact " HR 33392005961 " in
  Alcotest.(check string) "test_compact" "33392005961" result

let test_validate () =
  let result = Hr.Oib.validate "HR 33392005961" in
  Alcotest.(check string) "test_validate" "33392005961" result

let test_validate_invalid_checksum () =
  try
    ignore (Hr.Oib.validate "33392005962");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Hr.Oib.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("HR 33392005961", true)
    ; ("33392005962", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Hr.Oib.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Hr.Oib" [ ("suite", suite) ]
