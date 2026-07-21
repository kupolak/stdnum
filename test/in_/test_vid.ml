let test_compact () =
  let result = In_.Vid.compact " 2341-2341-2341-2341 " in
  Alcotest.(check string) "test_compact" "2341234123412341" result

let test_validate () =
  let result = In_.Vid.validate "2341234123412341" in
  Alcotest.(check string) "test_validate" "2341234123412341" result

let test_validate_invalid_checksum () =
  try
    ignore (In_.Vid.validate "2341234123412342");
    Alcotest.fail "Expected Invalid_checksum exception"
  with In_.Vid.Invalid_checksum -> ()

let test_validate_invalid_format_start () =
  try
    ignore (In_.Vid.validate "1341234123412341");
    Alcotest.fail "Expected Invalid_format exception"
  with In_.Vid.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (In_.Vid.validate "13412341234123");
    Alcotest.fail "Expected Invalid_length exception"
  with In_.Vid.Invalid_length -> ()

let test_validate_invalid_format_palindrome () =
  try
    ignore (In_.Vid.validate "2222222222222222");
    Alcotest.fail "Expected Invalid_format exception"
  with In_.Vid.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("2341234123412341", true)
    ; ("2341234123412342", false)
    ; ("1341234123412341", false)
    ; ("13412341234123", false)
    ; ("2222222222222222", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = In_.Vid.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = In_.Vid.format "2341234123412342" in
  Alcotest.(check string) "test_format" "2341 2341 2341 2342" result

let test_mask () =
  let result = In_.Vid.mask "2341234123412342" in
  Alcotest.(check string) "test_mask" "XXXX XXXX XXXX 2342" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ( "test_validate_invalid_format_start"
    , `Quick
    , test_validate_invalid_format_start )
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_format_palindrome"
    , `Quick
    , test_validate_invalid_format_palindrome )
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ; ("test_mask", `Quick, test_mask)
  ]

let () = Alcotest.run "Stdnum.In_.Vid" [ ("suite", suite) ]
