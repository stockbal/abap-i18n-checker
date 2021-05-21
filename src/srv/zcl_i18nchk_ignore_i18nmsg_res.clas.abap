"! <p class="shorttext synchronized" lang="en">Resource for Ignore entries for i18n keys</p>
CLASS zcl_i18nchk_ignore_i18nmsg_res DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_resource
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      if_rest_resource~post
        REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      bsp_name       TYPE o2applname,
      ignore_entries TYPE zif_i18nchk_ty_global=>ty_i18n_ignored_entries,
      new_entries    TYPE zif_i18nchk_ty_global=>ty_i18n_ignored_entries,
      delete_mode    TYPE abap_bool.

    METHODS:
      process_ignore_data,
      get_request_body
        IMPORTING
          entity        TYPE REF TO if_rest_entity
        RETURNING
          VALUE(result) TYPE abap_bool,
      merge_with_existing
        IMPORTING
          existing TYPE zif_i18nchk_ty_global=>ty_i18n_ignored_entries,
      set_error
        IMPORTING
          error_text TYPE string,
      check_bsp_name
        RETURNING
          VALUE(result) TYPE abap_bool.
ENDCLASS.



CLASS zcl_i18nchk_ignore_i18nmsg_res IMPLEMENTATION.


  METHOD if_rest_resource~post.
    CHECK get_request_body( io_entity ).
    delete_mode = COND #( WHEN mo_request->get_uri_query_parameter( iv_name = 'delete' ) = 'true' THEN abap_true ).

    IF NOT check_bsp_name( ).
      RETURN.
    ENDIF.
    process_ignore_data( ).

  ENDMETHOD.


  METHOD get_request_body.
    DATA(bin_req_data) = entity->get_binary_data( ).
    IF bin_req_data IS INITIAL.
      set_error( 'No request payload detected' ).
      RETURN.
    ENDIF.

    /ui2/cl_json=>deserialize(
      EXPORTING jsonx       = bin_req_data
                pretty_name = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING  data        = ignore_entries ).

    IF ignore_entries IS INITIAL.
      set_error( 'No ignore entries supplied' ).
      RETURN.
    ENDIF.

    result = abap_true.
  ENDMETHOD.


  METHOD check_bsp_name.
    LOOP AT ignore_entries ASSIGNING FIELD-SYMBOL(<ignore_entry>) WHERE bsp_name IS INITIAL.
      EXIT.
    ENDLOOP.

    IF sy-subrc = 0.
      set_error( 'BSP name missing from some/all ignore entries!' ).
    ELSE.
      result = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD process_ignore_data.
    FIELD-SYMBOLS: <ignore_entry> TYPE zif_i18nchk_ty_global=>ty_i18n_ignored_entry.

    IF delete_mode = abap_true.
      zcl_i18nchk_ign_files_dac=>delete_entries_by_key(
        VALUE #(
          FOR entry IN ignore_entries
          WHERE ( ign_entry_uuid IS NOT INITIAL )
          ( sign = 'I' option = 'EQ' low = entry-ign_entry_uuid ) ) ).

      LOOP AT ignore_entries ASSIGNING <ignore_entry>.
        CLEAR: <ignore_entry>-ign_entry_uuid.
      ENDLOOP.

    ELSE.
      " entries with UUIDs should not be processed again.
      DELETE ignore_entries WHERE ign_entry_uuid IS NOT INITIAL.
      DATA(existing) = zcl_i18nchk_ign_files_dac=>read_existing( bsp_name ).
      IF existing IS NOT INITIAL.
        merge_with_existing( existing = existing ).
      ENDIF.

      LOOP AT ignore_entries ASSIGNING <ignore_entry> WHERE ign_entry_uuid IS INITIAL.
        TRY.
            <ignore_entry>-ign_entry_uuid = cl_system_uuid=>create_uuid_x16_static( ).
            INSERT <ignore_entry> INTO TABLE new_entries.
          CATCH cx_uuid_error.
            set_error( 'Key generation for ignore entry failed' ).
            RETURN.
        ENDTRY.
      ENDLOOP.

      IF new_entries IS NOT INITIAL.
        TRY.
            zcl_i18nchk_ign_files_dac=>insert_entries( new_entries ).
          CATCH zcx_i18nchk_error INTO DATA(db_error).
            set_error( db_error->get_text( ) ).
            RETURN.
        ENDTRY.

      ENDIF.

    ENDIF.

    DATA(json) = /ui2/cl_json=>serialize(
      data        = ignore_entries
      pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    DATA(response_entity) = mo_response->create_entity( ).
    response_entity->set_string_data( json ).

  ENDMETHOD.


    METHOD merge_with_existing.

      LOOP AT ignore_entries ASSIGNING FIELD-SYMBOL(<ignore_entry>).
        ASSIGN existing[ file_path    = <ignore_entry>-file_path
                         file_name    = <ignore_entry>-file_name
                         message_type = <ignore_entry>-message_type
                         i18n_key     = <ignore_entry>-i18n_key ] TO FIELD-SYMBOL(<existing_ignore_entry>).
        IF sy-subrc = 0.
          <ignore_entry>-ign_entry_uuid = <existing_ignore_entry>-ign_entry_uuid.
        ENDIF.

      ENDLOOP.

    ENDMETHOD.


    METHOD set_error.
      mo_response->set_status( 500 ).
      mo_response->set_reason( error_text ).
    ENDMETHOD.

ENDCLASS.
