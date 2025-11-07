let test_compact () =
  Alcotest.(check string)
    "test_compact" "1234545678781"
    (Th.Pin.compact "1-2345-45678-78-1")

let test_validate_valid () =
  let result = Th.Pin.validate "3100600445635" in
  Alcotest.(check string) "test_validate_valid" "3100600445635" result

let test_validate_with_hyphens () =
  let result = Th.Pin.validate "1-2345-45678-78-1" in
  Alcotest.(check string) "test_validate_hyphens" "1234545678781" result

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Th.Pin.Invalid_checksum (fun () ->
      ignore (Th.Pin.validate "1-2345-45678-78-9"))

let test_is_valid_true () =
  let result = Th.Pin.is_valid "3100600445635" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Th.Pin.is_valid "1-2345-45678-78-9" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format () =
  let result = Th.Pin.format "7100600445635" in
  Alcotest.(check string) "test_format" "7-1006-00445-63-5" result

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

let () = Alcotest.run "Th.Pin" [ ("suite", suite) ]
