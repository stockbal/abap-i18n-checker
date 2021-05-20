"! <p class="shorttext synchronized" lang="en">Reader for accessing ignored i18n check entries</p>
CLASS zcl_i18nchk_ign_entry_reader DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      zif_i18nchk_ign_entry_reader.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_bsp_ignore,
        bsp_name       TYPE o2applname,
        ignore_entries TYPE zif_i18nchk_ty_global=>ty_i18n_ignored_entries,
      END OF ty_bsp_ignore,
      ty_bsp_ignore_list TYPE HASHED TABLE OF ty_bsp_ignore WITH UNIQUE KEY bsp_name.

    DATA:
      bsp_ignore_data_list TYPE ty_bsp_ignore_list.


    METHODS:
      get_ignored_entries
        IMPORTING
          bsp_name      TYPE o2applname
        RETURNING
          VALUE(result) TYPE REF TO ty_bsp_ignore.
ENDCLASS.



CLASS zcl_i18nchk_ign_entry_reader IMPLEMENTATION.


  METHOD zif_i18nchk_ign_entry_reader~get_ignored_entry.
    DATA(bsp_ignore_data) = get_ignored_entries( bsp_name ).
    result = VALUE #( bsp_ignore_data->ignore_entries[ file_path    = file_path
                                                       file_name    = file_name
                                                       message_type = message_type
                                                       i18n_key     = i18n_Key ] OPTIONAL ).
  ENDMETHOD.


  METHOD get_ignored_entries.
    TRY.
        result = REF #( bsp_ignore_data_list[ bsp_name = bsp_name ] ).
      CATCH cx_sy_itab_line_not_found.
        INSERT VALUE #(
          bsp_name       = bsp_name
          ignore_entries = zcl_i18nchk_ign_files_dac=>read_existing( bsp_name = bsp_name )
        ) INTO TABLE bsp_ignore_data_list REFERENCE INTO result.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
