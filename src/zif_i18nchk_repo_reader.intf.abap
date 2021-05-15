"! <p class="shorttext synchronized" lang="en">Looks for UI5 repositories (BSP) apps</p>
INTERFACE zif_i18nchk_repo_reader
  PUBLIC .

  METHODS:
    "! <p class="shorttext synchronized" lang="en">Reads BSP names from DB</p>
    read
      IMPORTING
        bsp_name_range TYPE zif_i18nchk_ty_global=>ty_bsp_range
      RETURNING
        VALUE(result)  TYPE zif_i18nchk_ty_global=>ty_bsp_names.

ENDINTERFACE.
