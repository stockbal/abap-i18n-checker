*"* use this source file for your ABAP unit test classes
CLASS ltcl_abap_unit DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      cut TYPE REF TO zcl_i18nchk_message_util.

    METHODS:
      test_method FOR TESTING.
ENDCLASS.

CLASS ltcl_abap_unit IMPLEMENTATION.

  METHOD test_method.
    DATA(text) = zcl_i18nchk_message_util=>fill_text(
      text               = 'Test test with {1} and {2}'
      placeholder_values = VALUE #( ( `one` ) ( `two` ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = text
      exp = 'Test test with one and two' ).
  ENDMETHOD.

ENDCLASS.
