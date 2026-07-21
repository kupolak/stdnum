let test_compact () =
  let result = Id.Nik.compact " 3171011708450001 " in
  Alcotest.(check string) "test_compact" "3171011708450001" result

let test_validate () =
  let result = Id.Nik.validate "3171011708450001" in
  Alcotest.(check string) "test_validate" "3171011708450001" result

let test_validate_invalid_length () =
  try
    ignore (Id.Nik.validate "31710117084500");
    Alcotest.fail "Expected Invalid_length exception"
  with Id.Nik.Invalid_length -> ()

let test_validate_invalid_province () =
  try
    ignore (Id.Nik.validate "9971011708450001");
    Alcotest.fail "Expected Invalid_component exception"
  with Id.Nik.Invalid_component -> ()

let test_get_birth_date () =
  let y, m, d = Id.Nik.get_birth_date "3171015708450001" in
  Alcotest.(check int) "year" 1945 y;
  Alcotest.(check int) "month" 8 m;
  Alcotest.(check int) "day" 17 d;

  let y, m, d = Id.Nik.get_birth_date "3171012902001234" in
  Alcotest.(check int) "year" 2000 y;
  Alcotest.(check int) "month" 2 m;
  Alcotest.(check int) "day" 29 d

let test_get_birth_date_invalid () =
  try
    ignore (Id.Nik.get_birth_date "3171013002001234");
    Alcotest.fail "Expected Invalid_component exception"
  with Id.Nik.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("3171011708450001", true)
    ; ("31710117084500", false)
    ; ("9971011708450001", false)
    ; ("3171013002001234", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Id.Nik.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_province", `Quick, test_validate_invalid_province)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_birth_date_invalid", `Quick, test_get_birth_date_invalid)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Id.Nik" [ ("suite", suite) ]
