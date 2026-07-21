let test_compact () =
  let result = Pk.Cnic.compact "34201-0891231-8" in
  Alcotest.(check string) "test_compact" "3420108912318" result

let test_validate () =
  let result = Pk.Cnic.validate "34201-0891231-8" in
  Alcotest.(check string) "test_validate" "3420108912318" result

let test_get_gender () =
  let gender = Pk.Cnic.get_gender "42201-0397640-8" in
  Alcotest.(check (option string)) "test_get_gender" (Some "F") gender

let test_get_province () =
  let province = Pk.Cnic.get_province "42201-0397640-8" in
  Alcotest.(check (option string)) "test_get_province" (Some "Sindh") province

let test_format () =
  let result = Pk.Cnic.format "3420108912318" in
  Alcotest.(check string) "test_format" "34201-0891231-8" result

let test_validate_invalid_format () =
  try
    ignore (Pk.Cnic.validate "34201-0891231-A");
    Alcotest.fail "Expected Invalid_format exception"
  with Pk.Cnic.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (Pk.Cnic.validate "34201-0891231-88");
    Alcotest.fail "Expected Invalid_length exception"
  with Pk.Cnic.Invalid_length -> ()

let test_validate_invalid_component () =
  try
    ignore (Pk.Cnic.validate "04201-0891231-8");
    Alcotest.fail "Expected Invalid_component exception"
  with Pk.Cnic.Invalid_component -> ()

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_get_province", `Quick, test_get_province)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_component", `Quick, test_validate_invalid_component)
  ]

let () = Alcotest.run "Stdnum.Pk.Cnic" [ ("suite", suite) ]
