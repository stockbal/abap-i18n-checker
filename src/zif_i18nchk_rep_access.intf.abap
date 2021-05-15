"! <p class="shorttext synchronized" lang="en">UI5 Repository Access</p>
INTERFACE zif_i18nchk_rep_access
  PUBLIC .

  METHODS:
  "! <p class="shorttext synchronized" lang="en">Retrievs BSP description</p>
    get_bsp_description
      RETURNING
        VALUE(result) TYPE o2descr,
    "! <p class="shorttext synchronized" lang="en">Returns map entries from UI5 repository</p>
    get_ui5_app_map_entries
      RETURNING
        VALUE(result) TYPE /ui5/ui5_rep_path_map_t
      RAISING
        /ui5/cx_ui5_rep,
    "! <p class="shorttext synchronized" lang="en">Retrieves content of repository file</p>
    get_file_content
      IMPORTING
        map_entry             TYPE /ui5/ui5_rep_path_map_s
        remove_empty_lines    TYPE abap_bool DEFAULT abap_true
        remove_comments       TYPE abap_bool OPTIONAL
        comment_pattern_range TYPE zif_i18nchk_ty_global=>ty_comment_patterns OPTIONAL
        condense_lines        TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(result)         TYPE string_table.
ENDINTERFACE.
