"! <p class="shorttext synchronized" lang="en">Root handler of i18n check service</p>
CLASS zcl_i18nchk_rest_root DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_http_handler
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      if_rest_application~get_root_handler
        REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_rest_root IMPLEMENTATION.


  METHOD if_rest_application~get_root_handler.
    DATA(router) = NEW cl_rest_router( ).

    router->attach(
      iv_template      = '/'
      iv_handler_class = 'ZCL_I18NCHK_REST_INFO_RES' ).

    router->attach(
      iv_template      = '/checkResults'
      iv_handler_class = 'ZCL_I18NCHK_EXEC_CHK_RES' ).

    router->attach(
      iv_template      = '/ignoreKeys'
      iv_handler_class = 'ZCL_I18NCHK_IGNORE_I18NKEY_RES' ).

    router->attach(
      iv_template      = '/repoInfos'
      iv_handler_class = 'ZCL_I18NCHK_REPOINFO_RES' ).

    ro_root_handler = router.
  ENDMETHOD.


ENDCLASS.
