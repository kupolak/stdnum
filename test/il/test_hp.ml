let test_compact () =
  let result = Il.Hp.compact " 5161 79157 " in
  Alcotest.(check string) "test_compact" "516179157" result

let test_validate () =
  let result = Il.Hp.validate "516179157" in
  Alcotest.(check string) "test_validate" "516179157" result

let test_validate_invalid_checksum () =
  try
    ignore (Il.Hp.validate "516179150");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Il.Hp.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Il.Hp.validate "490154203237518");
    Alcotest.fail "Expected Invalid_length exception"
  with Il.Hp.Invalid_length -> ()

let test_validate_invalid_component () =
  try
    ignore (Il.Hp.validate "416179157");
    Alcotest.fail "Expected Invalid_component exception"
  with Il.Hp.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("516179157", true)
    ; ("516179150", false)
    ; ("490154203237518", false)
    ; ("416179157", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Il.Hp.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Il.Hp.format " 5161 79157 " in
  Alcotest.(check string) "test_format" "516179157" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Il.Hp" [ ("suite", suite) ]
