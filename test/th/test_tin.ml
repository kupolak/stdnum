let test_tin_type_pin () =
  let result = Th.Tin.tin_type "1-2345-45678-78-1" in
  Alcotest.(check (option string)) "test_tin_type_pin" (Some "pin") result

let test_tin_type_moa () =
  let result = Th.Tin.tin_type "0-99-4-000-61772-1" in
  Alcotest.(check (option string)) "test_tin_type_moa" (Some "moa") result

let test_validate_pin () =
  let result = Th.Tin.validate "1-2345-45678-78-1" in
  Alcotest.(check string) "test_validate_pin" "1234545678781" result

let test_validate_moa () =
  let result = Th.Tin.validate "0-99-4-000-61772-1" in
  Alcotest.(check string) "test_validate_moa" "0994000617721" result

let test_validate_invalid () =
  Alcotest.check_raises "Invalid Format" Th.Tin.Invalid_format (fun () ->
      ignore (Th.Tin.validate "1234545678789"))

let test_format_pin () =
  let result = Th.Tin.format "3100600445635" in
  Alcotest.(check string) "test_format_pin" "3-1006-00445-63-5" result

let test_format_moa () =
  let result = Th.Tin.format "0993000133978" in
  Alcotest.(check string) "test_format_moa" "0-99-3-000-13397-8" result

let suite =
  [
    ("test_tin_type_pin", `Quick, test_tin_type_pin)
  ; ("test_tin_type_moa", `Quick, test_tin_type_moa)
  ; ("test_validate_pin", `Quick, test_validate_pin)
  ; ("test_validate_moa", `Quick, test_validate_moa)
  ; ("test_validate_invalid", `Quick, test_validate_invalid)
  ; ("test_format_pin", `Quick, test_format_pin)
  ; ("test_format_moa", `Quick, test_format_moa)
  ]

let () = Alcotest.run "Th.Tin" [ ("suite", suite) ]
