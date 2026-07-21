let test_compact () =
  let result = Lu.Tva.compact " LU 150 274 42 " in
  Alcotest.(check string) "test_compact" "15027442" result

let test_validate () =
  let result = Lu.Tva.validate "LU 150 274 42" in
  Alcotest.(check string) "test_validate" "15027442" result

let test_validate_invalid_checksum () =
  try
    ignore (Lu.Tva.validate "150 274 43");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Lu.Tva.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases = [ ("LU 150 274 42", true); ("150 274 43", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Lu.Tva.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Lu.Tva" [ ("suite", suite) ]
