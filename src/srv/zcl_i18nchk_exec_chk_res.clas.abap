"! <p class="shorttext synchronized" lang="en">REST Resource for executing i18n check</p>
CLASS zcl_i18nchk_exec_chk_res DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_resource
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      if_rest_resource~get
        REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF c_parameters,
        default_language TYPE string VALUE 'defLang',
        target_language  TYPE string VALUE 'trgtLang',
        bsp_name         TYPE string VALUE 'bspName',
      END OF c_parameters.
ENDCLASS.



CLASS zcl_i18nchk_exec_chk_res IMPLEMENTATION.


  METHOD if_rest_resource~get.
    DATA: bsp_names TYPE zif_i18nchk_ty_global=>ty_bsp_names.

    DATA(default_language) = mo_request->get_uri_query_parameter( iv_name = c_parameters-default_language ).
    DATA(target_languages) = mo_request->get_uri_query_parameters( iv_name = c_parameters-target_language ).
    bsp_names = VALUE #(
      FOR keyvalue IN mo_request->get_uri_query_parameters( iv_name = c_parameters-bsp_name )
      ( CONV #( keyvalue-value ) ) ).
  ENDMETHOD.


ENDCLASS.
