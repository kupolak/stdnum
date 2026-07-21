let test_compact () =
  let result = Eu.Vat.compact " ATU 57194903 " in
  Alcotest.(check string) "test_compact" "ATU57194903" result

let test_validate () =
  let result1 = Eu.Vat.validate "BE697449992" in
  Alcotest.(check string) "test_validate_1" "BE697449992" result1;
  let result2 = Eu.Vat.validate "FR 61 954 506 077" in
  Alcotest.(check string) "test_validate_2" "FR61954506077" result2

let test_validate_invalid_component () =
  try
    ignore (Eu.Vat.validate "US12345678");
    Alcotest.fail "Expected Invalid_component exception"
  with Eu.Vat.Invalid_component -> ()

let test_guess_country () =
  let result = Eu.Vat.guess_country "NL00449544B01" in
  Alcotest.(check (list string)) "test_guess_country" [ "nl" ] result

let test_is_valid () =
  let test_cases =
    [
      ("ATU 57194903", true)
    ; ("BE697449992", true)
    ; ("FR 61 954 506 077", true)
    ; ("US12345678", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Eu.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_guess_country", `Quick, test_guess_country)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Eu.Vat" [ ("suite", suite) ]
