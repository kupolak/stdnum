let test_compact () =
  let result = Mc.Tva.compact " 53 0000 04605 " in
  Alcotest.(check string) "test_compact" "FR53000004605" result

let test_validate () =
  let result = Mc.Tva.validate "53 0000 04605" in
  Alcotest.(check string) "test_validate" "FR53000004605" result

let test_validate_invalid_component () =
  try
    ignore (Mc.Tva.validate "FR 61 954 506 077");
    Alcotest.fail "Expected Invalid_component exception"
  with Mc.Tva.Invalid_component -> ()

let test_is_valid () =
  let test_cases = [ ("53 0000 04605", true); ("FR 61 954 506 077", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Mc.Tva.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Mc.Tva" [ ("suite", suite) ]
