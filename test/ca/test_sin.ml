let test_compact () =
  let test_cases =
    [
      ("123-456-782", "123456782")
    ; ("123 456 782", "123456782")
    ; (" 123-456-782 ", "123456782")
    ; ("123456782", "123456782")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ca.Sin.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("123-456-782", "123456782")
    ; ("193-456-787", "193456787")
      (* Valid SIN starting with 9 - temporary worker *)
    ; ("546-456-781", "546456781")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ca.Sin.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Ca.Sin.validate "999-999-999");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ca.Sin.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Ca.Sin.validate "12345678Z");
    Alcotest.fail "Expected Invalid_format exception"
  with Ca.Sin.Invalid_format -> ()

let test_validate_invalid_component () =
  (* First digit cannot be 0 or 8 *)
  try
    ignore (Ca.Sin.validate "823456785");
    Alcotest.fail "Expected Invalid_component exception"
  with Ca.Sin.Invalid_component -> ()

let test_validate_invalid_component_zero () =
  (* First digit cannot be 0 *)
  try
    ignore (Ca.Sin.validate "023456789");
    Alcotest.fail "Expected Invalid_component exception"
  with Ca.Sin.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (Ca.Sin.validate "12345678");
    Alcotest.fail "Expected Invalid_length exception"
  with Ca.Sin.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("123-456-782", true)
    ; ("193-456-787", true)
    ; ("546-456-781", true)
    ; (* Invalid checksum *)
      ("999-999-999", false)
    ; (* Invalid format *)
      ("12345678Z", false)
    ; (* Invalid component - starts with 8 *)
      ("823456785", false)
    ; (* Invalid component - starts with 0 *)
      ("023456789", false)
    ; (* Invalid length *)
      ("12345678", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ca.Sin.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("123456782", "123-456-782")
    ; ("193456787", "193-456-787")
    ; ("123-456-782", "123-456-782")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ca.Sin.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ( "test_validate_invalid_component_zero"
    , `Quick
    , test_validate_invalid_component_zero )
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Ca.Sin" [ ("suite", suite) ]
