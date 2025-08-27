let test_compact () =
  let cases =
    [
      ("0001339050", "0001339050")
    ; ("2449/494/16/0", "2449494160")
    ; ("084308984-8", "0843089848")
    ; (" 0843089848 ", "0843089848")
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Za.Tin.compact input in
      Alcotest.(check string) ("compact_" ^ input) expected result)
    cases

let test_validate () =
  let cases =
    [
      ("0001339050", Some "0001339050")
    ; ("2449/494/16/0", None)
    ; ("9125568", None)
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result =
        try Some (Za.Tin.validate input)
        with
        | Za.Tin.Invalid_length | Za.Tin.Invalid_format
        | Za.Tin.Invalid_component | Za.Tin.Invalid_checksum
        ->
          None
      in
      Alcotest.(check (option string)) ("validate_" ^ input) expected result)
    cases

let test_is_valid () =
  let cases =
    [ ("0001339050", true); ("2449/494/16/0", false); ("9125568", false) ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Za.Tin.is_valid input in
      Alcotest.(check bool) ("is_valid_" ^ input) expected result)
    cases

let test_format () =
  let cases = [ ("084308984-8", "0843089848") ] in
  List.iter
    (fun (input, expected) ->
      let result = Za.Tin.format input in
      Alcotest.(check string) ("format_" ^ input) expected result)
    cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Za.Tin" [ ("suite", suite) ]
