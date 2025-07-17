(** {1 Utility Functions}

    This module provides common utility functions for string manipulation
    and validation used throughout the stdnum library.
*)

(** [is_digits number] checks if all characters in the string are digits.
    
    @param number The string to check
    @return [true] if all characters are digits (0-9), [false] otherwise
    
    {[is_digits "123456" = true]}
    {[is_digits "123a56" = false]} *)
val is_digits : string -> bool

(** [clean number deletechars] removes all occurrences of specified characters.
    
    @param number The input string to clean
    @param deletechars String containing characters to remove
    @return String with specified characters removed
    
    {[clean "123-45-6789" "-" = "123456789"]}
    {[clean "A B C" " " = "ABC"]} *)
val clean : string -> string -> string
