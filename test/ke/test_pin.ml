let test_compact () =
  let result = Ke.Pin.compact " a004416331m " in
  Alcotest.(check string) "test_compact" "A004416331M" result

let test_validate () =
  let result = Ke.Pin.validate "P051365947M" in
  Alcotest.(check string) "test_validate_non_ind" "P051365947M" result;
  let result2 = Ke.Pin.validate "A004416331M" in
  Alcotest.(check string) "test_validate_ind" "A004416331M" result2

let test_validate_invalid_length () =
  try
    ignore (Ke.Pin.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Ke.Pin.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Ke.Pin.validate "V1234567890");
    Alcotest.fail "Expected Invalid_format exception"
  with Ke.Pin.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("P051365947M", true)
    ; ("A004416331M", true)
    ; ("12345", false)
    ; ("V1234567890", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ke.Pin.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Ke.Pin.format "a004416331m" in
  Alcotest.(check string) "test_format" "A004416331M" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Ke.Pin" [ ("suite", suite) ]
