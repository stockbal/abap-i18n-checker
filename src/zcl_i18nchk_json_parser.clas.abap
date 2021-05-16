"! <p class="shorttext synchronized" lang="en">JSON Parser</p>
CLASS zcl_i18nchk_json_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      parse
        IMPORTING
          json          TYPE string
        RETURNING
          VALUE(result) TYPE REF TO zif_i18nchk_json_file.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
       json TYPE string.
    METHODS:
      parse_internal.
ENDCLASS.



CLASS zcl_i18nchk_json_parser IMPLEMENTATION.

  METHOD parse.
    IF json IS NOT INITIAL.
      DATA(parser) = NEW zcl_i18nchk_json_parser( ).
      parser->json = json.
      parser->parse_internal( ).
    ENDIF.
  ENDMETHOD.

  METHOD parse_internal.

    DATA(reader) = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( json ) ).

    DO.
      DATA(node) = reader->read_next_node( ).
      IF node IS INITIAL.
        EXIT.
      ENDIF.

      CASE node->type.

        WHEN if_sxml_node=>co_nt_element_open.
          DATA(open_node) = CAST if_sxml_open_element( node ).
          WRITE: / `Opening ` && open_node->qname-name.
          DATA(attributes) = open_node->get_attributes( ).
          LOOP AT attributes INTO DATA(attribute).
            IF attribute->qname-name = 'name' AND attribute->value_type = if_sxml_value=>co_vt_text.
              WRITE: / |name: { attribute->get_value( ) }|.
            ENDIF.
          ENDLOOP.

        WHEN if_sxml_node=>co_nt_value.
          DATA(value_node) = CAST if_sxml_value_node( node ).
          WRITE: / |Value: { value_node->get_value( ) }|.

        WHEN if_sxml_node=>co_nt_element_close.
          DATA(closing_node) = CAST if_sxml_close_element( node ).
          WRITE: / `Closing ` && closing_node->qname-name.

        WHEN OTHERS.
      ENDCASE.

    ENDDO.

  ENDMETHOD.


ENDCLASS.
