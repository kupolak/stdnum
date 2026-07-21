let test_compact () =
  let result = Mu.Nid.compact " S 12 04 80 123456 B " in
  Alcotest.(check string) "test_compact" "S120480123456B" result

let test_validate () =
  let result = Mu.Nid.validate "S120480123456B" in
  Alcotest.(check string) "test_validate" "S120480123456B" result

let test_validate_invalid_checksum () =
  try
    ignore (Mu.Nid.validate "S120480123456A");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Mu.Nid.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Mu.Nid.validate "S121380123456A");
    Alcotest.fail "Expected Invalid_component exception"
  with Mu.Nid.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("S120480123456B", true)
    ; ("S120480123456A", false)
    ; ("S121380123456A", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Mu.Nid.is_valid input in
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

let () = Alcotest.run "Stdnum.Mu.Nid" [ ("suite", suite) ]
