let test_compact () =
  let test_cases =
    [
      ("114 18", "11418")
    ; ("11418", "11418")
    ; ("SE-11418", "11418")
    ; ("SE 11418", "11418")
    ; (" 114-18 ", "11418")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Se.Postnummer.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  let test_cases = [ "114 18"; "11418"; "SE-11418"; "12345"; "98765" ] in
  List.iter
    (fun input ->
      let compact_input = Se.Postnummer.compact input in
      let result = Se.Postnummer.validate input in
      Alcotest.(check string)
        ("test_validate_valid_" ^ input)
        compact_input result)
    test_cases

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Se.Postnummer.Invalid_length (fun () ->
      ignore (Se.Postnummer.validate "1145 18"))

let test_validate_invalid_format_non_digits () =
  Alcotest.check_raises "Invalid Format" Se.Postnummer.Invalid_format (fun () ->
      ignore (Se.Postnummer.validate "1141A"))

let test_validate_invalid_format_starts_with_zero () =
  Alcotest.check_raises "Invalid Format" Se.Postnummer.Invalid_format (fun () ->
      ignore (Se.Postnummer.validate "01418"))

let test_is_valid_true () =
  let test_cases = [ "114 18"; "11418"; "SE-11418"; "12345" ] in
  List.iter
    (fun input ->
      let result = Se.Postnummer.is_valid input in
      Alcotest.(check bool) ("test_is_valid_true_" ^ input) true result)
    test_cases

let test_is_valid_false () =
  let test_cases = [ "1145 18"; "0141A"; "01418"; "123" ] in
  List.iter
    (fun input ->
      let result = Se.Postnummer.is_valid input in
      Alcotest.(check bool) ("test_is_valid_false_" ^ input) false result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("11418", "114 18")
    ; ("114 18", "114 18")
    ; ("SE-11418", "114 18")
    ; ("12345", "123 45")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Se.Postnummer.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_format_non_digits"
    , `Quick
    , test_validate_invalid_format_non_digits )
  ; ( "test_validate_invalid_format_starts_with_zero"
    , `Quick
    , test_validate_invalid_format_starts_with_zero )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Se.Postnummer" [ ("suite", suite) ]
