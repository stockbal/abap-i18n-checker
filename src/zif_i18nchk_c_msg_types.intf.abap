"! <p class="shorttext synchronized" lang="en">Message types during check</p>
INTERFACE zif_i18nchk_c_msg_types
  PUBLIC .

  CONSTANTS:
    missing_i18n_file TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'MISSING_I18_FILE',
    missing_i18n_key  TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'MISSING_KEY'.
ENDINTERFACE.
