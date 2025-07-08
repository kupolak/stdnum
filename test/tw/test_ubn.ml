open Tw.Ubn

let test_valid_ubn () =
  let result = validate "00501503" in
  assert (result = "00501503");
  Printf.printf "✓ Test valid UBN passed\n"

let test_invalid_checksum () =
  try
    let _ = validate "00501502" in
    assert false (* Should have raised Invalid_checksum *)
  with Invalid_checksum -> Printf.printf "✓ Test invalid checksum passed\n"

let test_invalid_length () =
  try
    let _ = validate "12345" in
    assert false (* Should have raised Invalid_length *)
  with Invalid_length -> Printf.printf "✓ Test invalid length passed\n"

let test_format () =
  let result = format " 00501503 " in
  assert (result = "00501503");
  Printf.printf "✓ Test format passed\n"

let test_is_valid () =
  assert (is_valid "00501503" = true);
  assert (is_valid "00501502" = false);
  assert (is_valid "12345" = false);
  Printf.printf "✓ Test is_valid passed\n"

let test_compact () =
  let result = compact " 0050-1503 " in
  assert (result = "00501503");
  Printf.printf "✓ Test compact passed\n"

let test_calc_checksum () =
  let result = calc_checksum "00501503" in
  assert (result = 0);
  Printf.printf "✓ Test calc_checksum passed\n"

let () =
  Printf.printf "Running UBN tests...\n";
  test_valid_ubn ();
  test_invalid_checksum ();
  test_invalid_length ();
  test_format ();
  test_is_valid ();
  test_compact ();
  test_calc_checksum ();
  Printf.printf "All UBN tests passed!\n"
