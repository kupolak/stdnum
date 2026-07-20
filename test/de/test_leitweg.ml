let test_compact () =
  let result = De.Leitweg.compact " 991-03730-19 " in
  Alcotest.(check string) "test_compact" "991-03730-19" result

let test_validate () =
  let result = De.Leitweg.validate "991-03730-19" in
  Alcotest.(check string) "test_validate" "991-03730-19" result

let test_validate_invalid_format () =
  try
    ignore (De.Leitweg.validate "1-03730-19");
    Alcotest.fail "Expected Invalid_format exception"
  with De.Leitweg.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (De.Leitweg.validate "201-03730-19");
    Alcotest.fail "Expected Invalid_component exception"
  with De.Leitweg.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("991-03730-19", true)
    ; ("1-03730-19", false)
    ; ("201-03730-19", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Leitweg.is_valid input in
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

let () = Alcotest.run "Stdnum.De.Leitweg" [ ("suite", suite) ]
