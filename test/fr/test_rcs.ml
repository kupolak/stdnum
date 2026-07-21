let test_compact () =
  let result = Fr.Rcs.compact " RCS Nancy B 323 159 715 " in
  Alcotest.(check string) "test_compact" "RCS Nancy B 323159715" result

let test_compact_spaces () =
  let result = Fr.Rcs.compact " RCS Le Mans B 323 159 715 " in
  Alcotest.(check string) "test_compact_spaces" "RCS Le Mans B 323159715" result

let test_validate () =
  let result = Fr.Rcs.validate "RCS Nancy B 323 159 715" in
  Alcotest.(check string) "test_validate" "RCS Nancy B 323159715" result

let test_validate_invalid_checksum () =
  try
    ignore (Fr.Rcs.validate "RCS Nancy B 323 159 716");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fr.Rcs.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Fr.Rcs.validate "RCSNancy B 323 159 716");
    Alcotest.fail "Expected Invalid_format exception"
  with Fr.Rcs.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("RCS Nancy B 323 159 715", true)
    ; ("RCS Nancy B 323 159 716", false)
    ; ("RCSNancy B 323 159 716", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Rcs.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Fr.Rcs.format "RCS Nancy B323159715" in
  Alcotest.(check string) "test_format" "RCS Nancy B 323 159 715" result

let test_to_siren () =
  let result = Fr.Rcs.to_siren "RCS Nancy B 323159 715" in
  Alcotest.(check string) "test_to_siren" "323159715" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_compact_spaces", `Quick, test_compact_spaces)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ; ("test_to_siren", `Quick, test_to_siren)
  ]

let () = Alcotest.run "Stdnum.Fr.Rcs" [ ("suite", suite) ]
