"! <p class="shorttext synchronized" lang="en">Utilities for i18n file handling</p>
CLASS zcl_i18nchk_i18n_file_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Converts i18n file content to key/value pairs</p>
      convert_to_key_value_pairs
        IMPORTING
          file_content  TYPE string_table
        RETURNING
          VALUE(result) TYPE zif_i18nchk_ty_global=>ty_i18n_texts.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_i18n_file_utility IMPLEMENTATION.


  METHOD convert_to_key_value_pairs.

    " each line consists of the pattern <key> = <value>
    LOOP AT file_content ASSIGNING FIELD-SYMBOL(<content>).
      SPLIT <content> AT '=' INTO TABLE DATA(tokens).

      CHECK lines( tokens ) = 2.

      result = VALUE #( BASE result
        ( key   = condense( tokens[ 1 ] )
          value = condense( tokens[ 2 ] ) ) ).
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
