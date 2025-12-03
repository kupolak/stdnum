let test_compact () =
  let test_cases =
    [
      ("591705582", "591705582")
    ; ("УНП 591705582", "591705582")
    ; ("UNP 591705582", "591705582")
    ; (" 591 705 582 ", "591705582")
    ; ("МА1953684", "MA1953684")
      (* Cyrillic М and А converted to Latin M and A *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = By.Unp.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [ ("59170558", "2"); ("20098854", "1"); ("MA195368", "4") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = By.Unp.calc_check_digit input in
      Alcotest.(check string) "test_calc_check_digit" expected_result result)
    test_cases

let test_calc_check_digit_invalid () =
  (* Check digit cannot be 10 *)
  try
    ignore (By.Unp.calc_check_digit "711953681");
    Alcotest.fail "Expected Invalid_checksum exception"
  with By.Unp.Invalid_checksum -> ()

let test_validate () =
  let test_cases =
    [
      ("591705582", "591705582")
    ; ("200988541", "200988541")
    ; ("УНП MA1953684", "MA1953684")
    ; ("МА1953684", "MA1953684") (* Cyrillic *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = By.Unp.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (By.Unp.validate "200988542");
    Alcotest.fail "Expected Invalid_checksum exception"
  with By.Unp.Invalid_checksum -> ()

let test_validate_invalid_format_letters_wrong_places () =
  (* Letters in wrong places *)
  try
    ignore (By.Unp.validate "5917DDD82");
    Alcotest.fail "Expected Invalid_format exception"
  with By.Unp.Invalid_format -> ()

let test_validate_invalid_format_first_letter_only () =
  (* If first digit is letter, so should the second *)
  try
    ignore (By.Unp.validate "M01953684");
    Alcotest.fail "Expected Invalid_format exception"
  with By.Unp.Invalid_format -> ()

let test_validate_invalid_format_second_letter_only () =
  (* If second digit is letter, so should the first *)
  try
    ignore (By.Unp.validate "7A1953689");
    Alcotest.fail "Expected Invalid_format exception"
  with By.Unp.Invalid_format -> ()

let test_validate_invalid_component () =
  (* First digit is unknown region *)
  try
    ignore (By.Unp.validate "991705588");
    Alcotest.fail "Expected Invalid_component exception"
  with By.Unp.Invalid_component -> ()

let test_validate_invalid_length () =
  try
    ignore (By.Unp.validate "12345678");
    Alcotest.fail "Expected Invalid_length exception"
  with By.Unp.Invalid_length -> ()

let test_is_valid () =
  let test_cases =
    [
      ("591705582", true)
    ; ("200988541", true)
    ; ("УНП MA1953684", true)
    ; ("МА1953684", true)
    ; (* Invalid checksum *)
      ("200988542", false)
    ; (* Letters in wrong places *)
      ("5917DDD82", false)
    ; (* First letter only *)
      ("M01953684", false)
    ; (* Second letter only *)
      ("7A1953689", false)
    ; (* Invalid region *)
      ("991705588", false)
    ; (* Invalid length *)
      ("12345678", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = By.Unp.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

(* Test all valid numbers from doctest *)
let test_valid_numbers_from_doctest () =
  let numbers =
    [
      "100217336"
    ; "100693551"
    ; "100864035"
    ; "101288529"
    ; "101541947"
    ; "190658169"
    ; "190960352"
    ; "191453533"
    ; "191682495"
    ; "191767445"
    ; "191827058"
    ; "192035780"
    ; "192345153"
    ; "192988109"
    ; "200019773"
    ; "290380347"
    ; "400051902"
    ; "490127567"
    ; "500037201"
    ; "591705582"
    ; "690314863"
    ; "691631805"
    ; "791022114"
    ]
  in
  List.iter
    (fun number ->
      if not (By.Unp.is_valid number) then
        Alcotest.fail (Printf.sprintf "Number should be valid: %s" number))
    numbers

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_calc_check_digit_invalid", `Quick, test_calc_check_digit_invalid)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ( "test_validate_invalid_format_letters_wrong_places"
    , `Quick
    , test_validate_invalid_format_letters_wrong_places )
  ; ( "test_validate_invalid_format_first_letter_only"
    , `Quick
    , test_validate_invalid_format_first_letter_only )
  ; ( "test_validate_invalid_format_second_letter_only"
    , `Quick
    , test_validate_invalid_format_second_letter_only )
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_valid_numbers_from_doctest", `Quick, test_valid_numbers_from_doctest)
  ]

let () = Alcotest.run "By.Unp" [ ("suite", suite) ]
