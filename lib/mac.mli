(** MAC address (Media Access Control address).

    A media access control address (MAC address, sometimes Ethernet address) of
    a device is meant as a unique identifier within a network at the data link
    layer.

    More information:
    - https://en.wikipedia.org/wiki/MAC_address
    - https://en.wikipedia.org/wiki/Organizationally_unique_identifier
    - https://standards.ieee.org/faqs/regauth.html#2 *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** Convert the MAC address to the minimal, consistent representation. *)

val is_unicast : string -> bool
(** Check whether the number is a unicast address. Unicast addresses are
    received by one node in a network (LAN). *)

val is_multicast : string -> bool
(** Check whether the number is a multicast address. Multicast addresses are
    meant to be received by (potentially) multiple nodes in a network (LAN). *)

val is_broadcast : string -> bool
(** Check whether the number is the broadcast address. Broadcast addresses are
    meant to be received by all nodes in a network. *)

val is_universally_administered : string -> bool
(** Check if the address is supposed to be assigned by the manufacturer. *)

val is_locally_administered : string -> bool
(** Check if the address is meant to be configured by an administrator. *)

val validate : ?validate_manufacturer:bool -> string -> string
(** Check if the number provided is a valid MAC address. *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : ?validate_manufacturer:bool -> string -> bool
(** Check if the number provided is a valid MAC address. *)

val to_eui48 : string -> string
(** Convert the MAC address to EUI-48 format. *)
