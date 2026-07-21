let test_compact () =
  let result = In_.Gstin.compact " 27AAPFU0939F1ZV " in
  Alcotest.(check string) "test_compact" "27AAPFU0939F1ZV" result

let test_validate () =
  let result = In_.Gstin.validate "27AAPFU0939F1ZV" in
  Alcotest.(check string) "test_validate" "27AAPFU0939F1ZV" result

let test_validate_invalid_length () =
  try
    ignore (In_.Gstin.validate "27AAPFU0939F1Z");
    Alcotest.fail "Expected Invalid_length exception"
  with In_.Gstin.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (In_.Gstin.validate "369296450896540");
    Alcotest.fail "Expected Invalid_format exception"
  with In_.Gstin.Invalid_format -> ()

let test_validate_invalid_component () =
  try
    ignore (In_.Gstin.validate "27AAPFU0939F1AA");
    Alcotest.fail "Expected Invalid_component exception"
  with In_.Gstin.Invalid_component -> ()

let test_validate_invalid_checksum () =
  try
    ignore (In_.Gstin.validate "27AAPFU0939F1ZO");
    Alcotest.fail "Expected Invalid_checksum exception"
  with In_.Gstin.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("27AAPFU0939F1ZV", true)
    ; ("27AAPFU0939F1Z", false)
    ; ("369296450896540", false)
    ; ("27AAPFU0939F1AA", false)
    ; ("27AAPFU0939F1ZO", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = In_.Gstin.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_to_pan () =
  let result = In_.Gstin.to_pan "27AAPFU0939F1ZV" in
  Alcotest.(check string) "test_to_pan" "AAPFU0939F" result

let test_info () =
  let info = In_.Gstin.info "27AAPFU0939F1ZV" in
  Alcotest.(check (option string)) "test_info state" (Some "Maharashtra") info.state;
  Alcotest.(check string) "test_info pan" "AAPFU0939F" info.pan;
  Alcotest.(check string) "test_info holder_type" "Firm/Limited Liability Partnership" info.holder_type;
  Alcotest.(check string) "test_info initial" "U" info.initial;
  Alcotest.(check int) "test_info registration_count" 1 info.registration_count

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_to_pan", `Quick, test_to_pan)
  ; ("test_info", `Quick, test_info)
  ]

let () = Alcotest.run "Stdnum.In_.Gstin" [ ("suite", suite) ]
