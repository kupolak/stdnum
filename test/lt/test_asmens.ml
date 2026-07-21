let test_compact () =
  let result = Lt.Asmens.compact " 33309240064 " in
  Alcotest.(check string) "test_compact" "33309240064" result

let test_validate () =
  let result = Lt.Asmens.validate "33309240064" in
  Alcotest.(check string) "test_validate" "33309240064" result

let test_validate_invalid_checksum () =
  try
    ignore (Lt.Asmens.validate "33309240164");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Lt.Asmens.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("33309240064", true)
    ; ("33309240164", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Lt.Asmens.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Lt.Asmens" [ ("suite", suite) ]
