"! <p class="shorttext synchronized" lang="en">Looks for UI5 repositories (BSP) apps</p>
CLASS zcl_i18nchk_repo_reader DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      zif_i18nchk_repo_reader.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_repo_reader IMPLEMENTATION.


  METHOD zif_i18nchk_repo_reader~read.
    SELECT ui5_app~applname AS name
      FROM o2appl AS ui5_app
      WHERE ui5_app~applclas = '/UI5/CL_UI5_BSP_APPLICATION'
        AND ui5_app~applname IN @bsp_name_range
      INTO TABLE @result.
  ENDMETHOD.


ENDCLASS.
