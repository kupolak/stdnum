let test_compact () =
  let result = Ar.Dni.compact " 20.123.456 " in
  Alcotest.(check string) "test_compact" "20123456" result

let test_validate () =
  let result = Ar.Dni.validate "20.123.456" in
  Alcotest.(check string) "test_validate" "20123456" result

let test_validate_invalid_length () =
  try
    ignore (Ar.Dni.validate "2012345699");
    Alcotest.fail "Expected Invalid_length exception"
  with Ar.Dni.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Ar.Dni.validate "2012345A");
    Alcotest.fail "Expected Invalid_format exception"
  with Ar.Dni.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("20.123.456", true)
    ; ("2012345699", false)
    ; ("2012345A", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ar.Dni.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Ar.Dni.format "20123456" in
  Alcotest.(check string) "test_format" "20.123.456" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Ar.Dni" [ ("suite", suite) ]
