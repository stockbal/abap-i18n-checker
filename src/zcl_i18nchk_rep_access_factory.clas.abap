"! <p class="shorttext synchronized" lang="en">Default factory for creating repository access</p>
CLASS zcl_i18nchk_rep_access_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      zif_i18nchk_rep_access_factory.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_i18nchk_rep_access_factory IMPLEMENTATION.


  METHOD zif_i18nchk_rep_access_factory~create_repo_access.
    result = new zcl_i18nchk_rep_access( bsp_name = bsp_name ).
  ENDMETHOD.


ENDCLASS.
