*&---------------------------------------------------------------------*
*& Report zi18nchk_checker
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zi18nchk_checker.

TRY.
    DATA(i18n_checker) = NEW zcl_i18nchk_checker(
      appname_range    = VALUE #( ( sign = 'I' option = 'EQ' low = 'EPMRAQC_PROD' ) )
      source_language  = ''
      target_languages = VALUE #( ( `en` ) ) ).
    i18n_checker->check_translations( ).
  CATCH zcx_i18nchk_error INTO DATA(error).
    WRITE: /  error->get_text( ).
ENDTRY.
