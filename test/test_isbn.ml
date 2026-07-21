let test_compact () =
  let result = Stdnum.Isbn.compact "1-85798-218-5" in
  Alcotest.(check string) "test_compact_isbn10" "1857982185" result

let test_validate () =
  let result1 = Stdnum.Isbn.validate "978-9024538270" in
  Alcotest.(check string) "test_validate_isbn13" "9789024538270" result1;
  try
    ignore (Stdnum.Isbn.validate "978-9024538271");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Stdnum.Isbn.Invalid_checksum -> ()

let test_isbn_type () =
  let t1 = Stdnum.Isbn.isbn_type "1-85798-218-5" in
  Alcotest.(check (option string)) "test_isbn_type_isbn10" (Some "ISBN10") t1;
  let t2 = Stdnum.Isbn.isbn_type "978-0-471-11709-4" in
  Alcotest.(check (option string)) "test_isbn_type_isbn13" (Some "ISBN13") t2

let test_to_isbn13 () =
  let result = Stdnum.Isbn.to_isbn13 "1-85798-218-5" in
  Alcotest.(check string) "test_to_isbn13" "978-1-85798-218-3" result

let test_to_isbn10 () =
  let result = Stdnum.Isbn.to_isbn10 "978-1-85798-218-3" in
  Alcotest.(check string) "test_to_isbn10" "1-85798-218-5" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_isbn_type", `Quick, test_isbn_type)
  ; ("test_to_isbn13", `Quick, test_to_isbn13)
  ; ("test_to_isbn10", `Quick, test_to_isbn10)
  ]

let () = Alcotest.run "Stdnum.Isbn" [ ("suite", suite) ]
