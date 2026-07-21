type t =
  | Invalid_format
  | Invalid_length
  | Invalid_checksum
  | Invalid_component

let to_string = function
  | Invalid_format -> "invalid format"
  | Invalid_length -> "invalid length"
  | Invalid_checksum -> "invalid checksum"
  | Invalid_component -> "invalid component"
