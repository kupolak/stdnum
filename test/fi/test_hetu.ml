let test_compact () =
  let result = Fi.Hetu.compact " 131052a308t " in
  Alcotest.(check string) "test_compact" "131052A308T" result

let test_validate () =
  let result = Fi.Hetu.validate "131052-308T" in
  Alcotest.(check string) "test_validate" "131052-308T" result

let test_validate_invalid_checksum () =
  try
    ignore (Fi.Hetu.validate "131052-308U");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fi.Hetu.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Fi.Hetu.validate "310252-308Y");
    Alcotest.fail "Expected Invalid_component exception"
  with Fi.Hetu.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("131052-308T", true)
    ; ("131052-308U", false)
    ; ("310252-308Y", false)
    ; ("131052a308t", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fi.Hetu.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Fi.Hetu" [ ("suite", suite) ]
