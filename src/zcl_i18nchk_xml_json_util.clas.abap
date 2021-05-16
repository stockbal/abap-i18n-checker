"! <p class="shorttext synchronized" lang="en">Utility for XML/JSON</p>
CLASS zcl_i18nchk_xml_json_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Removes the last segment of a path</p>
      remove_last_path_segment
        CHANGING
          path TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_xml_json_util IMPLEMENTATION.


  METHOD remove_last_path_segment.
    DATA(last_path_offset) = find( val = path sub = '/' occ = -1 ).

    IF last_path_offset <> -1.
      path = path(last_path_offset).
    ENDIF.

  ENDMETHOD.


ENDCLASS.
