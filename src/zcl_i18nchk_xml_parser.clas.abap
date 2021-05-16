"! <p class="shorttext synchronized" lang="en">XML Parser</p>
CLASS zcl_i18nchk_xml_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      parse
        IMPORTING
          xml           TYPE string
        RETURNING
          VALUE(result) TYPE REF TO zif_i18nchk_xml_file.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
       xml TYPE string.
    METHODS:
      parse_internal.
ENDCLASS.



CLASS zcl_i18nchk_xml_parser IMPLEMENTATION.


  METHOD parse.
    IF xml IS NOT INITIAL.
      DATA(parser) = NEW zcl_i18nchk_xml_parser( ).
      parser->xml = xml.
      parser->parse_internal( ).
    ENDIF.
  ENDMETHOD.


  METHOD parse_internal.
    DATA: prefix       TYPE string,
          current_path TYPE string.

    DATA(reader) = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( xml ) ).

    DO.
      DATA(node) = reader->read_next_node( ).
      IF node IS INITIAL.
        EXIT.
      ENDIF.

      CASE node->type.

        WHEN if_sxml_node=>co_nt_element_open.
          DATA(open_node) = CAST if_sxml_open_element( node ).
          prefix = COND #( WHEN open_node->prefix IS NOT INITIAL THEN open_node->prefix && `:` ).
          current_path = current_path && `/` && to_lower( prefix && open_node->qname-name ).
          DATA(attributes) = open_node->get_attributes( ).
*          LOOP AT attributes INTO DATA(attribute).
*            IF attribute->qname-name = 'name' AND attribute->value_type = if_sxml_value=>co_vt_text.
*              out->write( |name: { attribute->get_value( ) }| ).
*            ENDIF.
*          ENDLOOP.

        WHEN if_sxml_node=>co_nt_value.
          DATA(value_node) = CAST if_sxml_value_node( node ).
*          IF current_path = path_to_match.
*            result = value_node->get_value( ).
*            RETURN.
*          ENDIF.

        WHEN if_sxml_node=>co_nt_element_close.
          DATA(closing_node) = CAST if_sxml_close_element( node ).
          zcl_i18nchk_xml_json_util=>remove_last_path_segment( CHANGING path = current_path ).

        WHEN OTHERS.
      ENDCASE.

    ENDDO.
  ENDMETHOD.


ENDCLASS.
