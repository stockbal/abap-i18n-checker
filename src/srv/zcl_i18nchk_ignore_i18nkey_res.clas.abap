"! <p class="shorttext synchronized" lang="en">Resource for Ignore entries for i18n keys</p>
CLASS zcl_i18nchk_ignore_i18nkey_res DEFINITION
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
ENDCLASS.



CLASS zcl_i18nchk_ignore_i18nkey_res IMPLEMENTATION.


  METHOD if_rest_resource~post.

  ENDMETHOD.


ENDCLASS.
