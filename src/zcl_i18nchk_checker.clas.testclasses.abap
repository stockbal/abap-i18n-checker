*"* use this source file for your ABAP unit test classes
CONSTANTS:
  c_test_app1 TYPE o2applname VALUE 'BSP_APP',
  c_test_app2 TYPE o2applname VALUE 'BSP_APP2'.

TYPES:
  BEGIN OF ty_repo_content,
    file    TYPE string,
    content TYPE string_table,
  END OF ty_repo_content,

  BEGIN OF ty_repo,
    name        TYPE o2applname,
    files       TYPE TABLE OF ty_repo_content WITH EMPTY KEY,
    map_entries TYPE /ui5/ui5_rep_path_map_t,
  END OF ty_repo,

  ty_repos TYPE STANDARD TABLE OF ty_repo WITH EMPTY KEY.

CLASS lcl_repo_reader DEFINITION.

  PUBLIC SECTION.
    INTERFACES:
      zif_i18nchk_repo_reader.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_repo_reader IMPLEMENTATION.

  METHOD zif_i18nchk_repo_reader~read.
    data: bsp_apps type table of o2applname.

          bsp_apps = value #( ( c_test_app1 ) ( c_test_app2 ) ).

    result = value #( for bsp_app in bsp_apps where ( table_line in bsp_name_range ) ( bsp_app ) ).
  ENDMETHOD.

ENDCLASS.


CLASS lcl_repo_access DEFINITION.

  PUBLIC SECTION.
    INTERFACES:
      zif_i18nchk_rep_access.
    METHODS:
      constructor
        IMPORTING
          repo TYPE ty_repo.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      repo TYPE ty_repo.
ENDCLASS.

CLASS lcl_repo_access IMPLEMENTATION.

  METHOD constructor.
    me->repo = repo.
  ENDMETHOD.

  METHOD zif_i18nchk_rep_access~get_bsp_description ##NEEDED.
  ENDMETHOD.

  METHOD zif_i18nchk_rep_access~get_file_content.
    result = VALUE #( repo-files[ file = map_entry-path ]-content OPTIONAL ).
  ENDMETHOD.

  METHOD zif_i18nchk_rep_access~get_ui5_app_map_entries.
    result = repo-map_entries.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_repo_access_factory DEFINITION.

  PUBLIC SECTION.
    INTERFACES:
      zif_i18nchk_rep_access_factory.
    METHODS:
      constructor
        IMPORTING
          repos TYPE ty_repos.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      repos TYPE ty_repos.
ENDCLASS.

CLASS lcl_repo_access_factory IMPLEMENTATION.

  METHOD constructor.
    me->repos = repos.
  ENDMETHOD.

  METHOD zif_i18nchk_rep_access_factory~create_repo_access.
    result = NEW lcl_repo_access( repo = VALUE #( repos[ name = bsp_name ] OPTIONAL ) ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_abap_unit DEFINITION DEFERRED.
CLASS zcl_i18nchk_checker DEFINITION LOCAL FRIENDS ltcl_abap_unit.

CLASS ltcl_abap_unit DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    METHODS:
      constructor.
  PRIVATE SECTION.
    DATA:
      test_data TYPE ty_repos,
      cut       TYPE REF TO zcl_i18nchk_checker.

    METHODS:
      setup,
      test_srclang_in_targetlangs FOR TESTING,
      test_missing_key FOR TESTING.
ENDCLASS.

CLASS ltcl_abap_unit IMPLEMENTATION.


  METHOD constructor.
    test_data = VALUE #(
     ( name = c_test_app1
       map_entries = VALUE #(
         ( internal_rep = 'B' path = 'i18n/i18n.properties' )
         ( internal_rep = 'B' path = 'i18n/i18n_en.properties' )
         ( internal_rep = 'B' path = 'i18n/i18n_de.properties' )
         ( internal_rep = 'B' path = 'i18n/ListReport/C_Product/i18n.properties' ) )
       files = VALUE #(
         ( file    = 'manifest.json' )
         ( file    = 'i18n/i18n.properties'
           content = VALUE #(
             ( |button = Click| )
             ( |dialog_title = Warning| ) ) )
         ( file    = 'i18n/i18n_en.properties'
           content = VALUE #(
             ( |button = Click| )
             ( |dialog_title = Warning| ) ) )
         ( file    = 'i18n/i18n_de.properties'
           content = VALUE #(
             ( |button = Drücke| ) ) )
         ( file    = 'i18n/ListReport/C_Poduct/i18n.properties'
           content = VALUE #(
             ( |title = Product title| )
             ( |description = Product Description| ) ) ) ) ) ).
  ENDMETHOD.


  METHOD setup.
  ENDMETHOD.


  METHOD test_srclang_in_targetlangs.
    TRY.
        cut = NEW zcl_i18nchk_checker(
          bsp_name_range   = VALUE #( )
          source_language  = ''
          target_languages = VALUE #( ( `` ) ) ).
      CATCH zcx_i18nchk_error INTO DATA(error).
    ENDTRY.

    cl_abap_unit_assert=>assert_bound( act = error ).
  ENDMETHOD.


  METHOD test_missing_key.
    TRY.
        cut = NEW zcl_i18nchk_checker(
          bsp_name_range   = VALUE #( ( sign = 'I' option = 'EQ' low = c_test_app1 ) )
          source_language  = ''
          target_languages = VALUE #( ( `de` ) ) ).
      CATCH zcx_i18nchk_error INTO DATA(error).
    ENDTRY.
    cl_abap_unit_assert=>assert_not_bound( act = error ).

    cut->repo_access_factory = NEW lcl_repo_access_factory( test_data ).
    cut->repo_reader = NEW lcl_repo_reader( ).

    cut->check_translations( ).

    DATA(result) = cut->get_check_result( ).
  ENDMETHOD.

ENDCLASS.
