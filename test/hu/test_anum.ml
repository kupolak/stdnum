let test_compact () =
  let input = "HU-12892312" in
  let expected_result = "12892312" in
  let result = Hu.Anum.compact input in
  Alcotest.(check string) "test_compact" expected_result result

let test_validate () =
  let input = "HU-12892312" in
  let expected_result = "12892312" in
  let result = Hu.Anum.validate input in
  Alcotest.(check string) "test_validate" expected_result result

let test_is_valid () =
  let input = "HU-12892312" in
  let expected_result = true in
  let result = Hu.Anum.is_valid input in
  Alcotest.(check bool) "test_is_valid" expected_result result

let test_is_not_valid () =
  let input = "570007868" in
  let expected_result = false in
  let result = Hu.Anum.is_valid input in
  Alcotest.(check bool) "test_is_valid" expected_result result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_is_not_valid", `Quick, test_is_not_valid)
  ]

let () = Alcotest.run "Hu.Anum" [ ("suite", suite) ]
