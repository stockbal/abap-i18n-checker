"! <p class="shorttext synchronized" lang="en">Resource for handling addition repository information</p>
CLASS zcl_i18nchk_repoinfo_res DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_resource
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      if_rest_resource~post
        REDEFINITION,
      if_rest_resource~delete
        REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES BEGIN OF ty_bsp_info.
    INCLUDE TYPE zi18nchkbspai.
    TYPES END OF ty_bsp_info.

ENDCLASS.



CLASS zcl_i18nchk_repoinfo_res IMPLEMENTATION.


  METHOD if_rest_resource~delete.

  ENDMETHOD.


  METHOD if_rest_resource~post.
    DATA: bsp_info TYPE ty_bsp_info.

    DATA(bin_data) = mo_request->get_entity( )->get_binary_data( ).
    IF bin_data IS INITIAL.
      mo_response->set_status( 500 ).
      mo_response->set_reason( 'No content supplied' ).
      RETURN.
    ENDIF.

    /ui2/cl_json=>deserialize(
      EXPORTING jsonx            = bin_data
                pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING  data             = bsp_info ).

    IF bsp_info IS INITIAL.
      RETURN.
    ENDIF.

    MODIFY zi18nchkbspai FROM bsp_info.
    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      mo_response->set_status( 500 ).
      mo_response->set_reason( 'Saving repository information failed' ).
    ENDIF.
  ENDMETHOD.


ENDCLASS.
