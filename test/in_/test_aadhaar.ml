let test_compact () =
  let result = In_.Aadhaar.compact " 2341-2341-2346 " in
  Alcotest.(check string) "test_compact" "234123412346" result

let test_validate () =
  let result = In_.Aadhaar.validate "234123412346" in
  Alcotest.(check string) "test_validate" "234123412346" result

let test_validate_invalid_checksum () =
  try
    ignore (In_.Aadhaar.validate "234123412347");
    Alcotest.fail "Expected Invalid_checksum exception"
  with In_.Aadhaar.Invalid_checksum -> ()

let test_validate_invalid_format_start () =
  try
    ignore (In_.Aadhaar.validate "123412341234");
    Alcotest.fail "Expected Invalid_format exception"
  with In_.Aadhaar.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (In_.Aadhaar.validate "643343121");
    Alcotest.fail "Expected Invalid_length exception"
  with In_.Aadhaar.Invalid_length -> ()

let test_validate_invalid_format_palindrome () =
  try
    ignore (In_.Aadhaar.validate "222222222222");
    Alcotest.fail "Expected Invalid_format exception"
  with In_.Aadhaar.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("234123412346", true)
    ; ("234123412347", false)
    ; ("123412341234", false)
    ; ("643343121", false)
    ; ("222222222222", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = In_.Aadhaar.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = In_.Aadhaar.format "234123412346" in
  Alcotest.(check string) "test_format" "2341 2341 2346" result

let test_mask () =
  let result = In_.Aadhaar.mask "234123412346" in
  Alcotest.(check string) "test_mask" "XXXX XXXX 2346" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format_start", `Quick, test_validate_invalid_format_start)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format_palindrome", `Quick, test_validate_invalid_format_palindrome)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ; ("test_mask", `Quick, test_mask)
  ]

let () = Alcotest.run "Stdnum.In_.Aadhaar" [ ("suite", suite) ]
