(** UPN (English Unique Pupil Number).

    The Unique Pupil Number (UPN) is a 13-character code that identifies pupils
    in English state schools and is designed to aid tracking pupil progress
    through the school system.

    The number consists of a check letter, a 3-digit LA (Local Authority) number
    for the issuing school, a 4-digit DfE number (School Establishment Number),
    2 digits for the issue year and 3 digits for a serial number. Temporary
    numbers have a 2-digit serial and a letter.

    More information:
    - https://www.gov.uk/government/publications/unique-pupil-numbers *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let alphabet = "ABCDEFGHJKLMNPQRTUVWXYZ0123456789"

let la_numbers =
  [
    201; 202; 203; 204; 205; 206; 207; 208; 209; 210; 211; 212; 213; 301;
    302; 303; 304; 305; 306; 307; 308; 309; 310; 311; 312; 313; 314; 315;
    316; 317; 318; 319; 320; 330; 331; 332; 333; 334; 335; 336; 340; 341;
    342; 343; 344; 350; 351; 352; 353; 354; 355; 356; 357; 358; 359; 370;
    371; 372; 373; 380; 381; 382; 383; 384; 390; 391; 392; 393; 394; 420;
    800; 801; 802; 803; 805; 806; 807; 808; 810; 811; 812; 813; 815; 816;
    821; 822; 823; 825; 826; 830; 831; 835; 836; 837; 840; 841; 845; 846;
    850; 851; 852; 855; 856; 857; 860; 861; 865; 866; 867; 868; 869; 870;
    871; 872; 873; 874; 876; 877; 878; 879; 880; 881; 882; 883; 884; 885;
    886; 887; 888; 889; 890; 891; 892; 893; 894; 895; 896; 908; 909; 916;
    919; 921; 925; 926; 928; 929; 931; 933; 935; 936; 937; 938
  ]

let compact number =
  Utils.clean number "[ ]" |> String.trim |> String.uppercase_ascii

let index_of char =
  let rec aux i =
    if i >= String.length alphabet then raise Not_found
    else if alphabet.[i] = char then i
    else aux (i + 1)
  in
  aux 0

let calc_check_digit number =
  let sum = ref 0 in
  for i = 0 to 11 do
    let char = number.[i] in
    try
      sum := !sum + ((i + 2) * index_of char)
    with Not_found -> raise Invalid_format
  done;
  let check = !sum mod 23 in
  String.make 1 alphabet.[check]

let validate number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;
  if not (Utils.is_digits (String.sub number 1 11)) || 
     not (String.contains alphabet number.[12]) then
    raise Invalid_format;
  
  let la_num = int_of_string (String.sub number 1 3) in
  if not (List.mem la_num la_numbers) then raise Invalid_component;

  if calc_check_digit (String.sub number 1 12) <> String.sub number 0 1 then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false
