let test_compact () =
  let result = Stdnum.Imsi.compact " 429011234567890 " in
  Alcotest.(check string) "test_compact" "429011234567890" result

let test_validate () =
  let result = Stdnum.Imsi.validate "429011234567890" in
  Alcotest.(check string) "test_validate" "429011234567890" result

let test_validate_invalid_length () =
  try
    ignore (Stdnum.Imsi.validate "4290112345678");
    Alcotest.fail "Expected Invalid_length exception"
  with Stdnum.Imsi.Invalid_length -> ()

let test_is_valid () =
  let test_cases = [ ("429011234567890", true); ("4290112345678", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Imsi.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Imsi" [ ("suite", suite) ]
