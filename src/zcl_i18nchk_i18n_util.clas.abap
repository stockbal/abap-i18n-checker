"! <p class="shorttext synchronized" lang="en">Utilities for i18n file handling</p>
CLASS zcl_i18nchk_i18n_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Converts i18n file content to key/value pairs</p>
      convert_to_key_value_pairs
        IMPORTING
          file_content  TYPE string_table
          sort_keys     TYPE abap_bool DEFAULT abap_true
        RETURNING
          VALUE(result) TYPE zif_i18nchk_ty_global=>ty_i18n_texts.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_i18n_util IMPLEMENTATION.


  METHOD convert_to_key_value_pairs.

    " each line consists of the pattern <key> = <value>
    LOOP AT file_content ASSIGNING FIELD-SYMBOL(<content>).
      DATA(sep_offset) = find( val = <content> sub = '=' ).
      CHECK sep_offset > 0.

      DATA(value_offset) = sep_offset + 1.

      result = VALUE #( BASE result
        ( key   = condense( <content>(sep_offset) )
          value = condense( <content>+value_offset ) ) ).
    ENDLOOP.

    IF sort_keys = abap_true.
      SORT result BY key.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
