"! <p class="shorttext synchronized" lang="en">Factory to create repository access</p>
INTERFACE zif_i18nchk_rep_access_factory
  PUBLIC .

  METHODS:
    "! <p class="shorttext synchronized" lang="en">Creates Repository access for BSP app</p>
    create_repo_access
      IMPORTING
        bsp_name      TYPE o2applname
      RETURNING
        VALUE(result) TYPE REF TO zif_i18nchk_rep_access.
ENDINTERFACE.
