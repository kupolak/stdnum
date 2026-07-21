let test_compact () =
  let result = Kr.Brn.compact " 116 - 82 - 00276  " in
  Alcotest.(check string) "test_compact" "1168200276" result

let test_validate () =
  let result = Kr.Brn.validate "116-82-00276" in
  Alcotest.(check string) "test_validate" "1168200276" result

let test_validate_invalid_length () =
  try
    ignore (Kr.Brn.validate "123456789");
    Alcotest.fail "Expected Invalid_length exception"
  with Kr.Brn.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Kr.Brn.validate "11682A0276");
    Alcotest.fail "Expected Invalid_format exception"
  with Kr.Brn.Invalid_format -> ()

let test_validate_invalid_component_tax () =
  try
    ignore (Kr.Brn.validate "1008200276");
    Alcotest.fail "Expected Invalid_component exception"
  with Kr.Brn.Invalid_component -> ()

let test_validate_invalid_component_type () =
  try
    ignore (Kr.Brn.validate "1160000276");
    Alcotest.fail "Expected Invalid_component exception"
  with Kr.Brn.Invalid_component -> ()

let test_validate_invalid_component_serial () =
  try
    ignore (Kr.Brn.validate "1168200006");
    Alcotest.fail "Expected Invalid_component exception"
  with Kr.Brn.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("116-82-00276", true)
    ; ("1168200276", true)
    ; (" 116 - 82 - 00276  ", true)
    ; ("123456789", false)
    ; ("11682A0276", false)
    ; ("1008200276", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Kr.Brn.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Kr.Brn.format "1348672683" in
  Alcotest.(check string) "test_format" "134-86-72683" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ( "test_validate_invalid_component_tax"
    , `Quick
    , test_validate_invalid_component_tax )
  ; ( "test_validate_invalid_component_type"
    , `Quick
    , test_validate_invalid_component_type )
  ; ( "test_validate_invalid_component_serial"
    , `Quick
    , test_validate_invalid_component_serial )
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Kr.Brn" [ ("suite", suite) ]
