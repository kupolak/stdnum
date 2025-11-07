let test_compact () =
  Alcotest.(check string)
    "test_compact" "0105536112014"
    (Th.Moa.compact "0 10 5 536 11201 4")

let test_validate_valid () =
  let result = Th.Moa.validate "0994000617721" in
  Alcotest.(check string) "test_validate_valid" "0994000617721" result

let test_validate_with_hyphens () =
  let result = Th.Moa.validate "0-99-4-000-61772-1" in
  Alcotest.(check string) "test_validate_hyphens" "0994000617721" result

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Th.Moa.Invalid_checksum (fun () ->
      ignore (Th.Moa.validate "0-99-4-000-61772-3"))

let test_is_valid_true () =
  let result = Th.Moa.is_valid "0994000617721" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Th.Moa.is_valid "0-99-4-000-61772-3" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format () =
  let result = Th.Moa.format "0993000133978" in
  Alcotest.(check string) "test_format" "0-99-3-000-13397-8" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_with_hyphens", `Quick, test_validate_with_hyphens)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Th.Moa" [ ("suite", suite) ]
