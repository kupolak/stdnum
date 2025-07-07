let test_validate () =
  let input = "900-93-0000" in
  let expected_result = "900-93-0000" in
  let result = Us.Atin.validate input in
  Alcotest.(check string) "test_validate" expected_result result

let test_is_valid () =
  let input = "900-93-0000" in
  let expected_result = true in
  let result = Us.Atin.is_valid input in
  Alcotest.(check bool) "test_is_valid" expected_result result

let test_is_not_valid () =
  Alcotest.check_raises "Invalid Length" Us.Atin.Invalid_format (fun () ->
      ignore (Us.Atin.validate "123"))

let suite =
  [
    ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_is_not_valid", `Quick, test_is_not_valid)
  ]

let () = Alcotest.run "Us.Atin" [ ("suite", suite) ]
