let test_compact () =
  let result = In_.Epic.compact " WKH 1186253 " in
  Alcotest.(check string) "test_compact" "WKH1186253" result

let test_validate () =
  let result = In_.Epic.validate "WKH1186253" in
  Alcotest.(check string) "test_validate" "WKH1186253" result

let test_validate_invalid_length () =
  try
    ignore (In_.Epic.validate "WKH118624");
    Alcotest.fail "Expected Invalid_length exception"
  with In_.Epic.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (In_.Epic.validate "1231186253");
    Alcotest.fail "Expected Invalid_format exception"
  with In_.Epic.Invalid_format -> ()

let test_validate_invalid_checksum () =
  try
    ignore (In_.Epic.validate "WKH1186263");
    Alcotest.fail "Expected Invalid_checksum exception"
  with In_.Epic.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("WKH1186253", true)
    ; ("WKH118624", false)
    ; ("1231186253", false)
    ; ("WKH1186263", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = In_.Epic.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.In_.Epic" [ ("suite", suite) ]
