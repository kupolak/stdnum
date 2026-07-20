let test_compact () =
  let result = Az.Voen.compact " 140 155 5071 " in
  Alcotest.(check string) "test_compact" "1401555071" result

let test_compact_9_digits () =
  let result = Az.Voen.compact "140155507" in
  Alcotest.(check string) "test_compact_9_digits" "0140155507" result

let test_validate () =
  let result = Az.Voen.validate "140 155 5071" in
  Alcotest.(check string) "test_validate" "1401555071" result

let test_validate_invalid_checksum () =
  try
    ignore (Az.Voen.validate "140 155 5081");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Az.Voen.Invalid_checksum -> ()

let test_validate_invalid_component () =
  try
    ignore (Az.Voen.validate "1400057424");
    Alcotest.fail "Expected Invalid_component exception"
  with Az.Voen.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (Az.Voen.validate "140 155 50");
    Alcotest.fail "Expected Invalid_length exception"
  with Az.Voen.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Az.Voen.validate "140 155 507A");
    Alcotest.fail "Expected Invalid_format exception"
  with Az.Voen.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("140 155 5071", true)
    ; ("140 155 5081", false)
    ; ("1400057424", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Az.Voen.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_compact_9_digits", `Quick, test_compact_9_digits)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Az.Voen" [ ("suite", suite) ]
