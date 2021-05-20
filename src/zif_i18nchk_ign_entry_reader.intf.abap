"! <p class="shorttext synchronized" lang="en">Reader for accessing ignored i18n check entries</p>
INTERFACE zif_i18nchk_ign_entry_reader
  PUBLIC .

  METHODS:
    "! <p class="shorttext synchronized" lang="en">Returns 'X' if the entry is ignored</p>
    get_ignored_entry
      IMPORTING
        bsp_name      TYPE o2applname
        file_path     TYPE string
        file_name     TYPE string
        message_type  TYPE zif_i18nchk_ty_global=>ty_message_type
        i18n_key      TYPE string
      RETURNING
        VALUE(result) TYPE zif_i18nchk_ty_global=>ty_i18n_ignored_entry.
ENDINTERFACE.
