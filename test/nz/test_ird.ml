let test_compact () =
  let result = Nz.Ird.compact " NZ 49-098-576 " in
  Alcotest.(check string) "test_compact" "49098576" result

let test_validate () =
  let result1 = Nz.Ird.validate "4909185-0" in
  Alcotest.(check string) "test_validate_1" "49091850" result1;
  let result2 = Nz.Ird.validate "NZ 49-098-576" in
  Alcotest.(check string) "test_validate_2" "49098576" result2

let test_validate_invalid_checksum () =
  try
    ignore (Nz.Ird.validate "136410133");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Nz.Ird.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Nz.Ird.validate "9125568");
    Alcotest.fail "Expected Invalid_length exception"
  with Nz.Ird.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("4909185-0", true)
    ; ("NZ 49-098-576", true)
    ; ("136410133", false)
    ; ("9125568", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Nz.Ird.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Nz.Ird.format "49098576" in
  Alcotest.(check string) "test_format" "49-098-576" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Nz.Ird" [ ("suite", suite) ]
