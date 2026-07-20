let test_compact () =
  let result = Be.Ogm_vcs.compact " +++010/8068/17183+++ " in
  Alcotest.(check string) "test_compact" "010806817183" result

let test_calc_check_digits () =
  let result = Be.Ogm_vcs.calc_check_digits "0108068171" in
  Alcotest.(check string) "test_calc_check_digits" "83" result

let test_validate () =
  let result = Be.Ogm_vcs.validate "+++010/8068/17183+++" in
  Alcotest.(check string) "test_validate" "010806817183" result

let test_validate_invalid_checksum () =
  try
    ignore (Be.Ogm_vcs.validate "010/8068/17180");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Be.Ogm_vcs.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Be.Ogm_vcs.validate "010/8068/1718");
    Alcotest.fail "Expected Invalid_length exception"
  with Be.Ogm_vcs.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Be.Ogm_vcs.validate "010/8068/1718A");
    Alcotest.fail "Expected Invalid_format exception"
  with Be.Ogm_vcs.Invalid_format -> ()
  
let test_validate_zeros () =
  try
    ignore (Be.Ogm_vcs.validate "000000000000");
    Alcotest.fail "Expected Invalid_format exception"
  with Be.Ogm_vcs.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("+++010/8068/17183+++", true)
    ; ("010/8068/17180", false)
    ; ("000000000000", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Be.Ogm_vcs.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Be.Ogm_vcs.format "010806817183" in
  Alcotest.(check string) "test_format" "010/8068/17183" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digits", `Quick, test_calc_check_digits)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_zeros", `Quick, test_validate_zeros)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Be.Ogm_vcs" [ ("suite", suite) ]
