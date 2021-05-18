"! <p class="shorttext synchronized" lang="en">Message types during check</p>
INTERFACE zif_i18nchk_c_msg_types
  PUBLIC .

  CONSTANTS:
    missing_i18n_file             TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'missing_i18_file',
    missing_default_i18n_file     TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'missing_default_i18_file',
    missing_i18n_key              TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'missing_i18n_key',
    missing_i18n_value            TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'missing_i18n_value',
    missing_default_i18n_key      TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'missing_def_i18n_key',
    i18n_key_with_same_value      TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'i18n_key_with_same_value',
    i18n_key_with_different_value TYPE zif_i18nchk_ty_global=>ty_message_type VALUE 'i18n_key_with_different_value'.
ENDINTERFACE.
