"! <p class="shorttext synchronized" lang="en">Handles retrieve of manifest file information</p>
CLASS zcl_i18nchk_manifest_file DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          content TYPE string_table,
      "! <p class="shorttext synchronized" lang="en">Returns the id of the library</p>
      get_id
        RETURNING
          VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_manifest_file IMPLEMENTATION.


  METHOD constructor.

  ENDMETHOD.


  METHOD get_id.

  ENDMETHOD.


ENDCLASS.
