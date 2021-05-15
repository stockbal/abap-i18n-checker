"! <p class="shorttext synchronized" lang="en">Repository Access</p>
CLASS zcl_i18nchk_rep_access DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      zif_i18nchk_rep_access.
    METHODS:
      constructor
        IMPORTING
          bsp_name TYPE o2applname.
  PROTECTED SECTION.
  PRIVATE SECTION.
    ALIASES:
      get_file_content FOR zif_i18nchk_rep_access~get_file_content.

    CONSTANTS:
      c_ui5_mapping_file_name TYPE string VALUE 'UI5RepositoryPathMapping.xml'.

    DATA:
      repo_pers_layer TYPE REF TO /ui5/if_ui5_rep_persistence.
ENDCLASS.



CLASS zcl_i18nchk_rep_access IMPLEMENTATION.


  METHOD constructor.
    repo_pers_layer = NEW /ui5/cl_ui5_rep_persistence( iv_bsp_repo_name = bsp_name ).
  ENDMETHOD.


  METHOD zif_i18nchk_rep_access~get_bsp_description.
    result = repo_pers_layer->repository_info-description.
  ENDMETHOD.


  METHOD zif_i18nchk_rep_access~get_ui5_app_map_entries.
    " read UI5 Repository Mapping XML file
    repo_pers_layer->read_bsp_page(
      EXPORTING p_pagekey   = VALUE #(
                applname = repo_pers_layer->repository_info-name
                pagekey  = to_upper( c_ui5_mapping_file_name ) )
      IMPORTING p_source    = DATA(mapping_file_source_table)
                ev_sy_subrc = DATA(sy_subrc) ).

    CASE sy_subrc.
      WHEN 0.
        DATA(mapping_file_source) = /ui5/cl_ui5_rep_utility=>code_tab_2_code_string( mapping_file_source_table ).

      WHEN OTHERS.
        " if xml file doesn't exist the source are empty
        " TODO: raise exception
        RETURN.
    ENDCASE.

    " create path mapper instance
    DATA(path_mapper) = NEW /ui5/cl_ui5_rep_path_mapper( mapping_file_source ).
    result = path_mapper->get_mapping_entries( ).
  ENDMETHOD.


  METHOD zif_i18nchk_rep_access~get_file_content.
    TRY.
        CASE map_entry-internal_rep.

          WHEN /ui5/cl_ui5_rep_utility=>c_internal_target_rep_mime.
            repo_pers_layer->read_mime_object(
              EXPORTING is_path_mapping  = map_entry
              IMPORTING ev_file_content  = DATA(file_raw) ).

            DATA(file_content_string) = /ui5/cl_ui5_rep_utility=>convert_xstring_2_string( file_raw ).
            result = /ui5/cl_ui5_rep_utility=>code_string_2_code_tab( file_content_string ).

          WHEN /ui5/cl_ui5_rep_utility=>c_internal_target_rep_bsp.
            repo_pers_layer->read_bsp_page(
              EXPORTING p_pagekey   = VALUE #(
                applname = repo_pers_layer->repository_info-name
                pagekey  = to_upper( map_entry-internal_rep_path ) )
              IMPORTING p_source    = DATA(file_content_tab) ).

            file_content_string = /ui5/cl_ui5_rep_utility=>code_tab_2_code_string( it_src_tab = file_content_tab ).
            SPLIT file_content_string AT cl_abap_char_utilities=>cr_lf INTO TABLE result.
        ENDCASE.

        IF remove_empty_lines = abap_true.
          DELETE result WHERE table_line IS INITIAL.
        ENDIF.

        IF condense_lines = abap_true OR
            ( remove_comments = abap_true AND comment_pattern_range IS NOT INITIAL ).

          LOOP AT result ASSIGNING FIELD-SYMBOL(<result_line>).
            IF condense_lines = abap_true.
              CONDENSE <result_line>.
            ENDIF.

            IF remove_comments = abap_true AND <result_line> IN comment_pattern_range.
              DELETE result.
            ENDIF.
          ENDLOOP.

        ENDIF.
      CATCH /ui5/cx_ui5_rep_dt.
        "handle exception
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
