let test_compact () =
  let test_cases =
    [
      ("Aachen HRA 11223", "Aachen HRA 11223")
    ; ("HRA 11223, Aachen", "Aachen HRA 11223")
    ; ("Frankfurt/Oder GnR 11223", "Frankfurt/Oder GnR 11223")
    ; ("München HRB 123456", "München HRB 123456")
    ; ("HRB 123456 A München", "München HRB 123456 A")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Handelsregisternummer.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("Aachen HRA 11223", "Aachen HRA 11223")
    ; ("HRA 11223, Aachen", "Aachen HRA 11223")
    ; ("Frankfurt/Oder GnR 11223", "Frankfurt/Oder GnR 11223")
    ; ("Berlin HRB 123", "Berlin (Charlottenburg) HRB 123")
    ; ("Charlottenburg HRB 456", "Berlin (Charlottenburg) HRB 456")
    ; ("Kempten HRA 789", "Kempten (Allgäu) HRA 789")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Handelsregisternummer.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_with_company_form () =
  (* Valid: GmbH should have HRB *)
  let result1 =
    De.Handelsregisternummer.validate ~company_form:"GmbH" "Aachen HRB 11223"
  in
  Alcotest.(check string) "test_validate_gmbh_hrb" "Aachen HRB 11223" result1;

  (* Valid: e.G. should have GnR *)
  let result2 =
    De.Handelsregisternummer.validate ~company_form:"e.G."
      "Frankfurt/Oder GnR 11223"
  in
  Alcotest.(check string)
    "test_validate_eg_gnr" "Frankfurt/Oder GnR 11223" result2;

  (* Invalid: GmbH should NOT have HRA *)
  let invalid =
    try
      ignore
        (De.Handelsregisternummer.validate ~company_form:"GmbH"
           "Aachen HRA 11223");
      false
    with De.Handelsregisternummer.Invalid_component -> true
  in
  Alcotest.(check bool) "test_validate_gmbh_hra_invalid" true invalid

let test_is_valid () =
  let test_cases =
    [
      ("Aachen HRA 11223", true) (* Valid *)
    ; ("Frankfurt/Oder GnR 11223", true) (* Valid *)
    ; ("Aachen HRC 44123", false) (* Invalid registry type *)
    ; ("InvalidCourt HRA 11223", false) (* Invalid court *)
    ; ("Aachen HRA 0", false) (* Number must start with 1-9 *)
    ; ("Aachen HRA", false) (* Missing number *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Handelsregisternummer.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_with_company_form", `Quick, test_validate_with_company_form)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "De.Handelsregisternummer" [ ("suite", suite) ]
