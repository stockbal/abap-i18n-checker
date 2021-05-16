"! <p class="shorttext synchronized" lang="en">Handles retrieve of library file (.library) information</p>
CLASS zcl_i18nchk_library_file DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          content TYPE string_table,
      "! <p class="shorttext synchronized" lang="en">Returns the id of the library</p>
      get_library_id
        RETURNING
          VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_library_file IMPLEMENTATION.


  METHOD constructor.

  ENDMETHOD.


  METHOD get_library_id.

  ENDMETHOD.

ENDCLASS.
