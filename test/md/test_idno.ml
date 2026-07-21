let test_compact () =
  let result = Md.Idno.compact " 1008600038413 " in
  Alcotest.(check string) "test_compact" "1008600038413" result

let test_validate () =
  let result = Md.Idno.validate "1008600038413" in
  Alcotest.(check string) "test_validate" "1008600038413" result

let test_validate_invalid_checksum () =
  try
    ignore (Md.Idno.validate "1008600038412");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Md.Idno.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases = [ ("1008600038413", true); ("1008600038412", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Md.Idno.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Md.Idno" [ ("suite", suite) ]
