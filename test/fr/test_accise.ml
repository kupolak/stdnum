let test_compact () =
  let result = Fr.Accise.compact " FR023004N9448 " in
  Alcotest.(check string) "test_compact" "FR023004N9448" result

let test_validate () =
  let result = Fr.Accise.validate "FR023004N9448" in
  Alcotest.(check string) "test_validate" "FR023004N9448" result

let test_validate_invalid_format () =
  try
    ignore (Fr.Accise.validate "FR0XX907E0820");
    Alcotest.fail "Expected Invalid_format exception"
  with Fr.Accise.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (Fr.Accise.validate "FR012907A0820");
    Alcotest.fail "Expected Invalid_component exception"
  with Fr.Accise.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("FR023004N9448", true)
    ; ("FR0XX907E0820", false)
    ; ("FR012907A0820", false)
    ; ("FR012907E0820", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Accise.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Fr.Accise" [ ("suite", suite) ]
