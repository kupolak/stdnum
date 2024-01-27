open Alcotest
open Tools

let test_is_digits () =
  let test_cases =
    [
      ("12345", true)
    ; ("abcde", false)
    ; ("9876a", false)
    ; ("", true)
    ; ("123 456", false)
    ]
  in
  List.iter
    (fun (number, expected) ->
      let result = Utils.is_digits number in
      check bool "is_digits" expected result)
    test_cases

let test_clean () =
  let test_cases =
    [
      ("123-456-789", "-", "123456789")
    ; ("abcde", "c", "abde")
    ; ("9876a", "a", "9876")
    ; ("", "!", "")
    ; ("123 456", " ", "123456")
    ]
  in
  List.iter
    (fun (number, deletechars, expected) ->
      let result = Utils.clean number deletechars in
      check string "clean" expected result)
    test_cases

let suite =
  [ ("is_digits", `Quick, test_is_digits); ("clean", `Quick, test_clean) ]

let () = run "Utils" [ ("Tools.Utils", suite) ]
