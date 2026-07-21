let test_compact () =
  let result = Cy.Vat.compact " CY-10259033P " in
  Alcotest.(check string) "test_compact" "10259033P" result

let test_calc_check_digit () =
  let result = Cy.Vat.calc_check_digit "10259033" in
  Alcotest.(check string) "test_calc_check_digit" "P" result

let test_validate () =
  let result = Cy.Vat.validate "CY-10259033P " in
  Alcotest.(check string) "test_validate" "10259033P" result

let test_validate_invalid_checksum () =
  try
    ignore (Cy.Vat.validate "CY-10259033Z");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Cy.Vat.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Cy.Vat.validate "CY-1025903P");
    Alcotest.fail "Expected Invalid_length exception"
  with Cy.Vat.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Cy.Vat.validate "CY-102A9033P");
    Alcotest.fail "Expected Invalid_format exception"
  with Cy.Vat.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (Cy.Vat.validate "CY-12259033P");
    Alcotest.fail "Expected Invalid_component exception"
  with Cy.Vat.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [ ("CY-10259033P", true); ("CY-10259033Z", false); ("10259033P", true) ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cy.Vat.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Cy.Vat" [ ("suite", suite) ]
