"! <p class="shorttext synchronized" lang="en">Data Access class for ignore entries</p>
CLASS zcl_i18nchk_ign_files_dac DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Reads existing ignore entries for bsp app</p>
      read_existing
        IMPORTING
          bsp_name      TYPE o2applname
        RETURNING
          VALUE(result) TYPE zif_i18nchk_ty_global=>ty_i18n_ignored_entries,
      "! <p class="shorttext synchronized" lang="en">Inserts new ignore entries</p>
      insert_entries
        IMPORTING
          new_entries TYPE zif_i18nchk_ty_global=>ty_i18n_ignored_entries
        RAISING
          zcx_i18nchk_error,
      "! <p class="shorttext synchronized" lang="en">Deletes entries by range of key</p>
      delete_entries_by_key
        IMPORTING
          ignore_uuid_range TYPE zif_i18nchk_ty_global=>ty_ignore_uuid_range.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_ign_files_dac IMPLEMENTATION.


  METHOD read_existing.
    SELECT *
      FROM zi18nchk_ignr
      WHERE bsp_name = @bsp_name
      INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.


  METHOD insert_entries.
    DATA: ignore_db_tab TYPE TABLE OF zi18nchk_ignr.
    CHECK new_entries IS NOT INITIAL.

    ignore_db_tab = CORRESPONDING #( new_entries ).
    INSERT zi18nchk_ignr FROM TABLE ignore_db_tab ACCEPTING DUPLICATE KEYS.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_i18nchk_error
        EXPORTING
          text = 'Error during creating i18n ignore entries'.
    ENDIF.

    COMMIT WORK.
  ENDMETHOD.


  METHOD delete_entries_by_key.
    CHECK ignore_uuid_range IS NOT INITIAL.

    DELETE FROM zi18nchk_ignr WHERE ign_entry_uuid IN ignore_uuid_range.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


ENDCLASS.
