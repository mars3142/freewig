## GWC file structure format
   
```
@0000:
 ; Signature:
 BYTE  0x02
 BYTE  0x0a
 BYTE  "CART", 0x00

@0007:
 ; Number of objects ("media files") in cartridge:
 USHORT  number_of_objects

@0009:
 ; references to individual objects in cartridge.
 ; there is exactly [number_of_objects] blocks like this:
 repeat times {
   USHORT  object_id  ; distinct ID for each object, duplicates are forbidden
   LONG  address      ; address of object in GWC file
 }

@xxxx:
 LONG  header_length  ; length of information header (following block):
 struct {
     DOUBLE  Latitude                     ; N+/S-
     DOUBLE  Longitude                    ; E+/W-
     DOUBLE  Altitude                     ; (see url 2)

     LONG  unknown_value
     LONG  unknown_value

     ; media-ID of icon and splashscreen:
     SHORT  ID_of_splashscreen            ; -1 = without splashscreen/poster
     SHORT  ID_of_small_icon              ; -1 = without icon

     ASCIIZ  type_of_cartridge            ; "Tour guide", "Wherigo cache", etc.
     ASCIIZ  PlayerName                   ; name of player who downloaded this cartridge

     LONG  unknown_value
     LONG  unknown_value

     ASCIIZ  CartridgeName                ; "Name of this cartridge"
     ASCIIZ  CartridgeGUID
     ASCIIZ  CartridgeDescription         ; "this is a sample cartridge"
     ASCIIZ  StartingLocationDescription  ; "nice parking"
     ASCIIZ  Version                      ; "1.2"
     ASCIIZ  Author
     ASCIIZ  Company
     ASCIIZ  RecommendedDevice            ; "Garmin Colorado", "Windows PPC", etc.
     
     LONG  unknown_value

     ASCIIZ  CompletionCode               ; only the first 15 chars are needed
 } header

@xxxx + header_length + 4:
 ; here should be first object, but it is not important, as all objects have
 ; it's address (offset in .gwc file) known, including the first one:


@address_of_FIRST_object (with ID=0):
 ; always Lua bytecode
 LONG  length 
 BYTE[length]  content_of_object  ; Lua bytecode

@address_of_ALL_OTHER_objects (with ID > 0):
 BYTE  valid_object
 if (valid_object == 0) {
   ; when valid_object == 0, it means that object is DELETED and does not exist in cartridge.
   ; nothing else follows.
 } else {
   LONG  object_type  ; -1=deleted, 1=bmp, 2=png, 3=jpg, 4=gif, 17=wav, 18=mp3, 19=fdl, other values have unknown meaning
   LONG  length
   BYTE[length]  content_of_object
 }
; ============================================================================
; And that is all.
; ============================================================================

BYTE = unsigned char (1 byte)
SHORT = signed short (2 bytes)
USHORT = unsigned short (2 bytes)
LONG = signed long (4 bytes)
ULONG = unsigned long (4 bytes)
DOUBLE = double-precision floating point number (8 bytes)
ASCIIZ = zero-terminated string ("hello world!", 0x00)
```
Sources:

- http://ati.land.cz/gps/wherigo/gwc.htm (site down)
- http://github.com/wijnen/python-wherigo/blob/master/wherigo.py
