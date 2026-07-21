let test_compact () =
  let result = In_.Pan.compact " ACUPA 7085R " in
  Alcotest.(check string) "test_compact" "ACUPA7085R" result

let test_validate () =
  let result = In_.Pan.validate "ACUPA7085R" in
  Alcotest.(check string) "test_validate" "ACUPA7085R" result

let test_validate_invalid_length () =
  try
    ignore (In_.Pan.validate "ACUPA7085RR");
    Alcotest.fail "Expected Invalid_length exception"
  with In_.Pan.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (In_.Pan.validate "ABMPA32111");
    Alcotest.fail "Expected Invalid_format exception"
  with In_.Pan.Invalid_format -> ()

let test_validate_invalid_holder_type () =
  try
    ignore (In_.Pan.validate "ABMXA3211G");
    Alcotest.fail "Expected Invalid_component exception"
  with In_.Pan.Invalid_component -> ()

let test_validate_invalid_serial () =
  try
    ignore (In_.Pan.validate "ACUPA0000R");
    Alcotest.fail "Expected Invalid_component exception"
  with In_.Pan.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("ACUPA7085R", true)
    ; ("ACUPA7085RR", false)
    ; ("ABMPA32111", false)
    ; ("ABMXA3211G", false)
    ; ("ACUPA0000R", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = In_.Pan.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_mask () =
  let result = In_.Pan.mask "AAPPV8261K" in
  Alcotest.(check string) "test_mask" "AAPPVXXXXK" result

let test_info () =
  let (holder_type, _) = In_.Pan.info "AAPPV8261K" in
  Alcotest.(check string) "test_info" "Individual" holder_type

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_holder_type", `Quick, test_validate_invalid_holder_type)
  ; ("test_validate_invalid_serial", `Quick, test_validate_invalid_serial)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_mask", `Quick, test_mask)
  ; ("test_info", `Quick, test_info)
  ]

let () = Alcotest.run "Stdnum.In_.Pan" [ ("suite", suite) ]
