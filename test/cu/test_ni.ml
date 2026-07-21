let test_compact () =
  let result = Cu.Ni.compact " 91021027775 " in
  Alcotest.(check string) "test_compact" "91021027775" result

let test_validate () =
  let result = Cu.Ni.validate "91021027775" in
  Alcotest.(check string) "test_validate" "91021027775" result

let test_validate_invalid_format () =
  try
    ignore (Cu.Ni.validate "9102102777A");
    Alcotest.fail "Expected Invalid_format exception"
  with Cu.Ni.Invalid_format -> ()

let test_get_birth_date () =
  let result1 = Cu.Ni.get_birth_date "91021027775" in
  Alcotest.(check (pair int (pair int int)))
    "test_get_birth_date_1"
    (1991, (2, 10))
    (let y, m, d = result1 in
     (y, (m, d)));

  let result2 = Cu.Ni.get_birth_date "72062506561" in
  Alcotest.(check (pair int (pair int int)))
    "test_get_birth_date_2"
    (1972, (6, 25))
    (let y, m, d = result2 in
     (y, (m, d)));

  let result3 = Cu.Ni.get_birth_date "85020291531" in
  Alcotest.(check (pair int (pair int int)))
    "test_get_birth_date_3"
    (1885, (2, 2))
    (let y, m, d = result3 in
     (y, (m, d)))

let test_get_birth_date_invalid () =
  try
    ignore (Cu.Ni.get_birth_date "02023061531");
    Alcotest.fail "Expected Invalid_component exception"
  with Cu.Ni.Invalid_component -> ()

let test_get_gender () =
  let result1 = Cu.Ni.get_gender "91021027775" in
  Alcotest.(check string) "test_get_gender_1" "F" result1;

  let result2 = Cu.Ni.get_gender "72062506561" in
  Alcotest.(check string) "test_get_gender_2" "M" result2

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_birth_date_invalid", `Quick, test_get_birth_date_invalid)
  ; ("test_get_gender", `Quick, test_get_gender)
  ]

let () = Alcotest.run "Stdnum.Cu.Ni" [ ("suite", suite) ]
