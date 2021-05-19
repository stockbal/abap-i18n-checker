"! <p class="shorttext synchronized" lang="en">I18n translation checker</p>
CLASS zcl_i18nchk_checker DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS:
      "! <p class="shorttext synchronized" lang="en">Creates new instance of i18n checker</p>
      constructor
        IMPORTING
          bsp_name_range           TYPE zif_i18nchk_ty_global=>ty_bsp_range
          default_language         TYPE string DEFAULT 'en'
          compare_against_def_file TYPE abap_bool DEFAULT abap_true
          target_languages         TYPE zif_i18nchk_ty_global=>ty_i18n_languages,
      "! <p class="shorttext synchronized" lang="en">Starts check for missing/incomplete translations</p>
      check_translations
        RAISING
          zcx_i18nchk_error,
      "! <p class="shorttext synchronized" lang="en">Returns i18n check result</p>
      get_check_result
        RETURNING
          VALUE(result) TYPE zif_i18nchk_ty_global=>ty_check_results,
      "! <p class="shorttext synchronized" lang="en">Returns the number of UI5 reps without i18n errors</p>
      get_error_free_ui5_rep_count
        RETURNING
          VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      c_app_manifest     TYPE string VALUE 'manifest.json',
      c_app_i18n_prefix  TYPE string VALUE 'i18n',
      c_lib_i18n_prefix  TYPE string VALUE 'messagebundle',
      c_i18n_file_suffix TYPE string VALUE '.properties',
      c_library_manifest TYPE string VALUE '.library',

      BEGIN OF c_messages,
        language_missing         TYPE string VALUE `The language file for locale <strong>{1}</strong> is missing`,
        default_language_missing TYPE string VALUE `The default language file is missing at path <strong>{1}</strong>`,
        key_missing              TYPE string VALUE `Key <strong>{1}</strong> is missing`,
        value_missing            TYPE string VALUE `There is no value for key <strong>{1}</strong>`,
        same_key_value           TYPE string VALUE `The value for <strong>{1}</strong> equals the default value <strong>{2}</strong>`,
        different_key_value      TYPE string VALUE `The value for <strong>{1}</strong> differs from the default value <strong>{2}</strong>`,
        default_key_missing      TYPE string VALUE `There is no entry for <strong>{1}</strong> in the default file <strong>{2}</strong>`,
      END OF c_messages.

    TYPES:
      BEGIN OF ty_i18n_file_group,
        path  TYPE string,
        files TYPE zif_i18nchk_ty_global=>ty_i18n_files_int,
      END OF ty_i18n_file_group,

      ty_i18n_file_groups TYPE STANDARD TABLE OF ty_i18n_file_group WITH EMPTY KEY,

      BEGIN OF ty_i18n_translation,
        file  TYPE zif_i18nchk_ty_global=>ty_i18n_file,
        texts TYPE zif_i18nchk_ty_global=>ty_i18n_texts,
      END OF ty_i18n_translation,

      ty_i18n_translations TYPE STANDARD TABLE OF ty_i18n_translation WITH EMPTY KEY,

      BEGIN OF ty_i18n_info,
        path         TYPE string,
        language_key TYPE string,
        content      TYPE string_table,
      END OF ty_i18n_info,

      ty_i18n_infos TYPE STANDARD TABLE OF ty_i18n_info WITH KEY path,

      BEGIN OF ty_i18n_map,
        app_name   TYPE o2appl-applname,
        i18n_infos TYPE ty_i18n_infos,
      END OF          ty_i18n_map,

      ty_i18n_maps TYPE STANDARD TABLE OF ty_i18n_map WITH KEY app_name,

      BEGIN OF ty_ui5_bsp,
        name               TYPE o2appl-applname,
        description        TYPE o2applt-text,
        id                 TYPE string,
        i18n_map_entries   TYPE /ui5/ui5_rep_path_map_t,
        manifest_map_entry TYPE /ui5/ui5_rep_path_map_s,
        library_map_entry  TYPE /ui5/ui5_rep_path_map_s,
        is_app             TYPE abap_bool,
      END OF ty_ui5_bsp.

    DATA:
      repo_reader                TYPE REF TO zif_i18nchk_repo_reader,
      current_repo_access        TYPE REF TO zif_i18nchk_rep_access,
      repo_access_factory        TYPE REF TO zif_i18nchk_rep_access_factory,
      bsp_name_range             TYPE zif_i18nchk_ty_global=>ty_bsp_range,
      default_language           TYPE string,
      compare_against_def_file   TYPE abap_bool,
      target_languages           TYPE RANGE OF string,
      all_languages              TYPE RANGE OF string,
      bsp_infos                  TYPE zif_i18nchk_ty_global=>ty_bsp_infos,
      check_results              TYPE zif_i18nchk_ty_global=>ty_check_results,
      ui5_rep_no_errors_count    TYPE i,
      current_check_result       TYPE zif_i18nchk_ty_global=>ty_check_result,
      i18n_comment_pattern_range TYPE zif_i18nchk_ty_global=>ty_comment_patterns.

    METHODS:
      read_ui5_repositories,
      validate_ui5_repositories,
      validate_translations
        IMPORTING
          ui5_bsp TYPE ty_ui5_bsp,
      get_i18n_file_language
        IMPORTING
          is_app        TYPE abap_bool
          file_name     TYPE string
        RETURNING
          VALUE(result) TYPE string,
      get_relevant_i18n_files
        IMPORTING
          map_entries   TYPE /ui5/ui5_rep_path_map_t
          is_app        TYPE abap_bool
        RETURNING
          VALUE(result) TYPE ty_i18n_file_groups,
      check_file_existence
        IMPORTING
          file_group    TYPE ty_i18n_file_group
          is_app        TYPE abap_bool
        RETURNING
          VALUE(result) TYPE abap_bool,
      "! <p class="shorttext synchronized" lang="en">Returns texts of i18n file</p>
      get_i18n_file_texts
        IMPORTING
          file          TYPE zif_i18nchk_ty_global=>ty_i18n_file_int
        RETURNING
          VALUE(result) TYPE zif_i18nchk_ty_global=>ty_i18n_texts,
      compare_texts
        IMPORTING
          base             TYPE zif_i18nchk_ty_global=>ty_i18n_texts
          base_file        TYPE zif_i18nchk_ty_global=>ty_i18n_file
          compare          TYPE zif_i18nchk_ty_global=>ty_i18n_texts
          compare_file     TYPE zif_i18nchk_ty_global=>ty_i18n_file
          compare_language TYPE string.
ENDCLASS.



CLASS zcl_i18nchk_checker IMPLEMENTATION.


  METHOD constructor.
    me->repo_reader = NEW zcl_i18nchk_repo_reader( ).
    me->repo_access_factory = NEW zcl_i18nchk_rep_access_factory( ).
    me->default_language = default_language.
    me->compare_against_def_file = compare_against_def_file.
    me->bsp_name_range = bsp_name_range.
    me->target_languages = VALUE #( FOR language IN target_languages ( sign = 'I' option = 'EQ' low = language ) ).
    " include the default language, i.e. the properties file without a locale (e.g. i18n.properties/messagebundle.properties)
    all_languages = VALUE #( BASE me->target_languages ( sign = 'I' option = 'EQ' low = space ) ).
    IF compare_against_def_file = abap_false.
      all_languages = VALUE #( BASE all_languages ( sign = 'I' option = 'EQ' low = default_language ) ).
    ENDIF.
    SORT all_languages.
    DELETE ADJACENT DUPLICATES FROM all_languages.
    i18n_comment_pattern_range = VALUE zif_i18nchk_ty_global=>ty_comment_patterns(
      ( sign = 'I' option = 'CP' low = '##*' ) ).
  ENDMETHOD.


  METHOD check_translations.
    read_ui5_repositories( ).
    validate_ui5_repositories( ).
  ENDMETHOD.


  METHOD get_check_result.
    result = check_results.
  ENDMETHOD.


  METHOD get_error_free_ui5_rep_count.
    result = ui5_rep_no_errors_count.
  ENDMETHOD.


  METHOD validate_ui5_repositories.

    LOOP AT bsp_infos ASSIGNING FIELD-SYMBOL(<bsp_info>).
      current_repo_access = repo_access_factory->create_repo_access( <bsp_info>-bsp_name ).
      DATA(ui5_repo) = VALUE zif_i18nchk_ty_global=>ty_ui5_repo(
        name               = <bsp_info>-bsp_name
        description        = current_repo_access->get_bsp_description( ) ).
      TRY.
          DATA(mapping_entries) = current_repo_access->get_ui5_app_map_entries( ).
        CATCH /ui5/cx_ui5_rep ##NO_HANDLER.
          CONTINUE.
      ENDTRY.

      CHECK mapping_entries IS NOT INITIAL.

      ui5_repo-manifest_map_entry = VALUE #( mapping_entries[ path = c_app_manifest ] OPTIONAL ).
      ui5_repo-library_map_entry =  VALUE #( mapping_entries[ path = c_library_manifest ] OPTIONAL ).
      ui5_repo-is_app = xsdbool( ui5_repo-library_map_entry IS INITIAL ).
      ui5_repo-i18n_map_entries = VALUE #(
        FOR <map_entry> IN mapping_entries
        WHERE ( path CP COND #(
                          WHEN ui5_repo-is_app = abap_true THEN |{ c_app_i18n_prefix }*{ c_i18n_file_suffix }|
                          ELSE |{ c_lib_i18n_prefix }*{ c_i18n_file_suffix }| ) )
        ( <map_entry> ) ).

      CLEAR current_check_result.
      current_check_result = VALUE #(
        bsp_name    = ui5_repo-name
        git_url     = <bsp_info>-git_url
        is_app      = ui5_repo-is_app
        description = ui5_repo-description ).

      validate_translations( ui5_bsp = ui5_repo ).
      IF line_exists( current_check_result-i18n_results[ sy_msg_type = 'E' ] ).
        current_check_result-status = 'E'.
      ELSEIF line_exists( current_check_result-i18n_results[ sy_msg_type = 'W' ] ).
        current_check_result-status = 'W'.
      ELSE.
        current_check_result-status = 'S'.
      ENDIF.
      check_results = VALUE #( BASE check_results ( current_check_result ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD validate_translations.
    DATA: excluded_languages TYPE RANGE OF string.

    FIELD-SYMBOLS: <base_i18n_file> TYPE zif_i18nchk_ty_global=>ty_i18n_file_int.

    excluded_languages = VALUE #( ( sign = 'E' option = 'EQ' low = space ) ).
    IF compare_against_def_file = abap_false.
      APPEND VALUE #( sign = 'E' option = 'EQ' low = default_language ) TO excluded_languages.
    ENDIF.

    DATA(i18n_file_groups) = get_relevant_i18n_files(
      map_entries = ui5_bsp-i18n_map_entries
      is_app      = ui5_bsp-is_app ).

    LOOP AT i18n_file_groups ASSIGNING FIELD-SYMBOL(<i18n_file_group>).

      IF compare_against_def_file = abap_true.
        ASSIGN <i18n_file_group>-files[ language = space ] TO <base_i18n_file>.
        CHECK sy-subrc = 0.
      ELSE.
        ASSIGN <i18n_file_group>-files[ language = default_language ] TO <base_i18n_file>.
        CHECK sy-subrc = 0.
      ENDIF.

      DATA(base_file_texts) = get_i18n_file_texts( <base_i18n_file> ).

      LOOP AT <i18n_file_group>-files ASSIGNING FIELD-SYMBOL(<i18n_file>) WHERE language IN excluded_languages.
        DATA(i18n_texts) = get_i18n_file_texts( file = <i18n_file> ).
        compare_texts( base             = base_file_texts
                       base_file        = CORRESPONDING #( <base_i18n_file> )
                       compare          = i18n_texts
                       compare_file     = CORRESPONDING #( <i18n_file> )
                       compare_language = <i18n_file>-language ).
        ADD 1 TO current_check_result-checked_files.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_relevant_i18n_files.
    DATA: last_path  TYPE string,
          file_group TYPE ty_i18n_file_group.

    LOOP AT map_entries ASSIGNING FIELD-SYMBOL(<i18n_map_entry>).
      DATA(last_path_offset) = find( val = <i18n_map_entry>-path sub = '/' occ = -1 ).

      DATA(path) = `/` && COND #( WHEN last_path_offset > 0 THEN  <i18n_map_entry>-path(last_path_offset) ).

      IF last_path <> path AND file_group IS NOT INITIAL.
        check_file_existence( file_group = file_group is_app = is_app ).
        result = VALUE #( BASE result ( file_group ) ).
        CLEAR file_group.
      ENDIF.

      file_group-path = path.
      last_path = path.
      DATA(filename_offset) = last_path_offset + 1.

      DATA(file_name) = <i18n_map_entry>-path+filename_offset.
      DATA(language) = get_i18n_file_language(
        is_app    = is_app
        file_name = file_name ).

      " Other language files are not of interest at the moment
      CHECK language IN all_languages.

      file_group-files = VALUE #( BASE file_group-files
       ( rep_map = <i18n_map_entry>
         name     = file_name
         path     = path
         language = language ) ).
    ENDLOOP.

    IF file_group-files IS NOT INITIAL.
      check_file_existence( file_group = file_group is_app = is_app ).
      result = VALUE #( BASE result ( file_group ) ).
    ENDIF.

  ENDMETHOD.


  METHOD check_file_existence.
    DATA: language_missing_msg TYPE string,
          message_type         TYPE zif_i18nchk_ty_global=>ty_message_type,
          file_name            TYPE string.

    result = abap_true.
    IF lines( file_group-files ) = lines( all_languages ).
      RETURN.
    ENDIF.

    " a language file is missing, add the appropriate message to the check result
    LOOP AT all_languages INTO DATA(language_key).
      IF NOT line_exists( file_group-files[ language = language_key-low ] ).
        CLEAR result.

        IF language_key-low = space.
          file_name = COND #(
            WHEN is_app = abap_true THEN |{ c_app_i18n_prefix }{ c_i18n_file_suffix }|
            ELSE |{ c_lib_i18n_prefix }{ c_i18n_file_suffix }| ).
          language_missing_msg = zcl_i18nchk_message_util=>fill_text(
            text               = c_messages-default_language_missing
            placeholder_values = VALUE #( ( file_group-path ) ) ).
          message_type = zif_i18nchk_c_msg_types=>missing_default_i18n_file.
        ELSE.
          file_name = COND #(
            WHEN is_app = abap_true THEN |{ c_app_i18n_prefix }_{ language_key-low }{ c_i18n_file_suffix }|
            ELSE |{ c_lib_i18n_prefix }_{ language_key-low }{ c_i18n_file_suffix }| ).
          message_type = zif_i18nchk_c_msg_types=>missing_i18n_file.
          language_missing_msg = zcl_i18nchk_message_util=>fill_text(
            text               = c_messages-language_missing
            placeholder_values = VALUE #( ( language_key-low ) ( file_name ) ) ).
        ENDIF.

        APPEND VALUE #(
          file         = VALUE #(
            name = file_name
            path = file_group-path )
          message      = language_missing_msg
          sy_msg_type  = 'E'
          message_type = message_type ) TO current_check_result-i18n_results.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_i18n_file_language.
    DATA(pattern) = COND #(
      WHEN is_app = abap_true THEN c_app_i18n_prefix ELSE c_lib_i18n_prefix ) &&
      '_(\w+)\.'.

    FIND FIRST OCCURRENCE OF REGEX pattern IN file_name
     RESULTS DATA(match).

    IF match IS NOT INITIAL.
      DATA(language_match) = match-submatches[ 1 ].
      result = file_name+language_match-offset(language_match-length).
    ENDIF.
  ENDMETHOD.


  METHOD read_ui5_repositories.
    bsp_infos = repo_reader->read( bsp_name_range = bsp_name_range ).
  ENDMETHOD.


  METHOD get_i18n_file_texts.
    DATA(contents) = current_repo_access->get_file_content(
      map_entry             = file-rep_map
      remove_comments       = abap_true
      comment_pattern_range = i18n_comment_pattern_range ).

    result = zcl_i18nchk_i18n_util=>convert_to_key_value_pairs( contents ).
  ENDMETHOD.


  METHOD compare_texts.

    LOOP AT base ASSIGNING FIELD-SYMBOL(<base_text>).

      ASSIGN compare[ key = <base_text>-key ] TO FIELD-SYMBOL(<compare_text>).
      IF sy-subrc = 0.
        IF <compare_text>-value = <base_text>-value.

          IF compare_language <> default_language.
            APPEND VALUE #(
              file          = compare_file
              key           = <base_text>-key
              value         = <compare_text>-value
              default_value = <base_text>-value
              sy_msg_type   = 'E'
              message_type  = zif_i18nchk_c_msg_types=>i18n_key_with_same_value
              message       = zcl_i18nchk_message_util=>fill_text(
                text               = c_messages-same_key_value
                placeholder_values = VALUE #( ( <base_text>-key ) ( <base_text>-value ) ) )
            ) TO current_check_result-i18n_results.
          ENDIF.
        ELSEIF compare_language = default_language.
          APPEND VALUE #(
              file          = compare_file
              key           = <base_text>-key
              value         = <compare_text>-value
              default_value = <base_text>-value
              sy_msg_type   = 'E'
              message_type  = zif_i18nchk_c_msg_types=>i18n_key_with_different_value
              message       = zcl_i18nchk_message_util=>fill_text(
                text               = c_messages-different_key_value
                placeholder_values = VALUE #( ( <base_text>-key ) ( <base_text>-value ) ) )
            ) TO current_check_result-i18n_results.
        ENDIF.
      ELSE.
        APPEND VALUE #(
          file          = compare_file
          key           = <base_text>-key
          default_value = <base_text>-value
          sy_msg_type   = 'E'
          message_type  = zif_i18nchk_c_msg_types=>missing_i18n_key
          message       = zcl_i18nchk_message_util=>fill_text(
            text               = c_messages-key_missing
            placeholder_values = VALUE #( ( <base_text>-key ) ) )
        ) TO current_check_result-i18n_results.
      ENDIF.
    ENDLOOP.

    " check if key is missing in base file
    IF sy-subrc <> 0.

      LOOP AT compare ASSIGNING <compare_text>.
        APPEND VALUE #(
          file          = base_file
          key           = <compare_text>-key
          value         = <compare_text>-value
          sy_msg_type   = 'E'
          message_type  = zif_i18nchk_c_msg_types=>missing_default_i18n_key
          message       = zcl_i18nchk_message_util=>fill_text(
            text               = c_messages-default_key_missing
            placeholder_values = VALUE #( ( <compare_text>-key ) ) )
        ) TO current_check_result-i18n_results.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.

ENDCLASS.
