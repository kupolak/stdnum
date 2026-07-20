let test_compact () =
  let result = Cr.Cpj.compact " 3-101-999999 " in
  Alcotest.(check string) "test_compact" "3101999999" result

let test_validate () =
  let result = Cr.Cpj.validate "3-101-999999" in
  Alcotest.(check string) "test_validate" "3101999999" result

let test_validate_invalid_component_type () =
  try
    ignore (Cr.Cpj.validate "3-534-123559");
    Alcotest.fail "Expected Invalid_component exception"
  with Cr.Cpj.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (Cr.Cpj.validate "310132541");
    Alcotest.fail "Expected Invalid_length exception"
  with Cr.Cpj.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Cr.Cpj.validate "310132541A");
    Alcotest.fail "Expected Invalid_format exception"
  with Cr.Cpj.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("3-101-999999", true)
    ; ("3-534-123559", false)
    ; ("310132541", false)
    ; ("4 000 042138", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cr.Cpj.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Cr.Cpj.format "4 000 042138" in
  Alcotest.(check string) "test_format" "4-000-042138" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_component_type", `Quick, test_validate_invalid_component_type)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Cr.Cpj" [ ("suite", suite) ]
