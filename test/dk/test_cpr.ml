let test_compact () =
  let result = Dk.Cpr.compact " 211062-5629 " in
  Alcotest.(check string) "test_compact" "2110625629" result

let test_checksum () =
  let result = Dk.Cpr.checksum "2110625629" in
  Alcotest.(check int) "test_checksum" 0 result

let test_validate () =
  let result = Dk.Cpr.validate "211062-5629" in
  Alcotest.(check string) "test_validate" "2110625629" result

let test_validate_invalid_date () =
  try
    ignore (Dk.Cpr.validate "511062-5629");
    Alcotest.fail "Expected Invalid_component exception"
  with Dk.Cpr.Invalid_component -> ()

let test_validate_future_date () =
  try
    (* 52 means year + 2000 = 2052 (if prefix indicates so), wait:
       let's test exact case from python: "2110525629".
       52 in year, 5 as prefix -> 1800 if year >= 58, else it's 2000! So 2052.
       This is a future date. *)
    ignore (Dk.Cpr.validate "2110525629");
    Alcotest.fail "Expected Invalid_component exception"
  with Dk.Cpr.Invalid_component -> ()

let test_get_birth_date () =
  let result = Dk.Cpr.get_birth_date "2110620629" in
  Alcotest.(check (pair int (pair int int)))
    "test_get_birth_date"
    (1962, (10, 21))
    (let y, m, d = result in
     (y, (m, d)))

let test_format () =
  let result = Dk.Cpr.format "2110625629" in
  Alcotest.(check string) "test_format" "211062-5629" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_date", `Quick, test_validate_invalid_date)
  ; ("test_validate_future_date", `Quick, test_validate_future_date)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Dk.Cpr" [ ("suite", suite) ]
