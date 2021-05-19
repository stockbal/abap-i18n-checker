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
    SELECT ui5_app~applname AS bsp_name,
           repo_info~git_url
      FROM o2appl AS ui5_app
        LEFT OUTER JOIN zi18nchkbspai AS repo_info
          ON ui5_app~applname = repo_info~bsp_name
      WHERE ui5_app~applclas = '/UI5/CL_UI5_BSP_APPLICATION'
        AND ui5_app~applname IN @bsp_name_range
      INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.


ENDCLASS.
