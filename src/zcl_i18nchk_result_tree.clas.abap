"! <p class="shorttext synchronized" lang="en">Tree output for check result</p>
CLASS zcl_i18nchk_result_tree DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Creates new tree output</p>
      constructor
        IMPORTING
          check_results TYPE zif_i18nchk_ty_global=>ty_check_results,
      "! <p class="shorttext synchronized" lang="en">Displays the tree in the default screen</p>
      display.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
          check_results TYPE zif_i18nchk_ty_global=>ty_check_results.
ENDCLASS.



CLASS zcl_i18nchk_result_tree IMPLEMENTATION.


  METHOD constructor.
    me->check_results = check_results.
  ENDMETHOD.


  METHOD display.

  ENDMETHOD.


ENDCLASS.
