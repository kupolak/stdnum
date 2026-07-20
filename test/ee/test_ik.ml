let test_compact () =
  let result = Ee.Ik.compact " 36805280109 " in
  Alcotest.(check string) "test_compact" "36805280109" result

let test_validate () =
  let result = Ee.Ik.validate "36805280109" in
  Alcotest.(check string) "test_validate" "36805280109" result

let test_validate_invalid_checksum () =
  try
    ignore (Ee.Ik.validate "36805280108");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Ee.Ik.Invalid_checksum -> ()

let test_get_birth_date () =
  let result = Ee.Ik.get_birth_date "36805280109" in
  Alcotest.(check (pair int (pair int int))) "test_get_birth_date" (1968, (5, 28)) 
    (let y, m, d = result in y, (m, d))

let test_get_gender () =
  let result1 = Ee.Ik.get_gender "36805280109" in
  Alcotest.(check string) "test_get_gender_1" "M" result1;
  let result2 = Ee.Ik.get_gender "46805280109" in
  Alcotest.(check string) "test_get_gender_2" "F" result2

let test_is_valid () =
  let test_cases =
    [
      ("36805280109", true)
    ; ("36805280108", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ee.Ik.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Ee.Ik" [ ("suite", suite) ]
