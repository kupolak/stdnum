let test_compact () =
  let test_cases =
    [
      ("3-0455-0175", "0304550175")
    ; ("3-455-175", "0304550175")
    ; ("701610395", "0701610395")
    ; ("1-613-584", "0106130584")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cr.Cpf.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("3-0455-0175", "0304550175")
    ; ("8-0074-0308", "0800740308")
    ; ("701610395", "0701610395")
    ; ("1-613-584", "0106130584")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cr.Cpf.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_errors () =
  let invalid_cases =
    [
      ("12345678", Cr.Cpf.Invalid_length)
    ; ("FF8490717", Cr.Cpf.Invalid_format)
    ; ("30-1234-1234", Cr.Cpf.Invalid_component) (* Invalid first digit *)
    ]
  in
  List.iter
    (fun (input, expected_exception) ->
      Alcotest.check_raises ("test_validate_error_" ^ input) expected_exception
        (fun () -> ignore (Cr.Cpf.validate input)))
    invalid_cases

let test_is_valid () =
  let valid_cases =
    [
      "01-0913-0259"
    ; "1-0054-1023"
    ; "1-0087-1407"
    ; "1-0150-0837"
    ; "1-0228-0776"
    ; "1-0278-0527"
    ; "1-0316-0324"
    ; "1-0332-0133"
    ; "1-0390-0960"
    ; "1-0407-0888"
    ; "701610395"
    ; "107560893"
    ; "107580405"
    ]
  in
  List.iter
    (fun input ->
      let result = Cr.Cpf.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) true result)
    valid_cases

let test_format () =
  let test_cases =
    [
      ("701610395", "07-0161-0395")
    ; ("1-613-584", "01-0613-0584")
    ; ("3-0455-0175", "03-0455-0175")
    ; ("8-0074-0308", "08-0074-0308")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cr.Cpf.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_errors", `Quick, test_validate_errors)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Cr.Cpf" [ ("suite", suite) ]
