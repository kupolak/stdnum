let test_compact () =
  let test_cases =
    [
      ("AGRIFRPP882", "AGRIFRPP882")
    ; ("ABNA BE 2A", "ABNABE2A")
    ; ("agri-fr-pp", "AGRIFRPP")
    ; ("AGRI FR PP", "AGRIFRPP")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Bic.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("AGRIFRPP882", "AGRIFRPP882")
    ; ("ABNABE2A", "ABNABE2A")
    ; ("AGRIFRPP", "AGRIFRPP")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Bic.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Bic.validate "AGRIFRPP8");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Bic.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Stdnum.Bic.validate "AGRIF2PP");
    (* country code can't contain digits *)
    Alcotest.fail "Expected Invalid_format exception"
  with Stdnum.Bic.Invalid_format -> ()

let test_validate_invalid_country () =
  try
    ignore (Stdnum.Bic.validate "AGRIXXPP");
    (* XX is not a valid country code *)
    Alcotest.fail "Expected Invalid_component exception"
  with Stdnum.Bic.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("AGRIFRPP882", true) (* Valid 11-char BIC *)
    ; ("AGRIFRPP", true) (* Valid 8-char BIC *)
    ; ("ABNABE2A", true) (* Valid BIC *)
    ; ("AGRIFRPP8", false) (* Invalid length *)
    ; ("AGRIF2PP", false) (* Invalid format - digit in country code *)
    ; ("AGRIXXPP", false) (* Invalid country code *)
    ; ("12345678", false) (* Invalid format - digits instead of letters *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Bic.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("agriFRPP", "AGRIFRPP") (* conventionally caps *)
    ; ("abna be 2a", "ABNABE2A")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Bic.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_country", `Quick, test_validate_invalid_country)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Bic" [ ("suite", suite) ]
