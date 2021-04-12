*&---------------------------------------------------------------------*
*& Report z_ccm_material_exists_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_material_exists_01.


TYPES: BEGIN OF material_type,
         material     TYPE matnr,
         availability TYPE flag,
       END OF material_type.

"! Material Object
CLASS lcl_material DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_material,
             material     TYPE char18,
             availability TYPE flag,
           END OF ty_material.
    METHODS constructor
      IMPORTING
        i_material TYPE any OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA material TYPE ty_material.
    METHODS do_it
      IMPORTING
        i_material TYPE any.
ENDCLASS.

CLASS lcl_material IMPLEMENTATION.
  METHOD constructor.
    me->material = i_material.

    DATA it_mara TYPE STANDARD TABLE OF mara.
    DATA wa_mara TYPE mara.

    SELECT * FROM mara INTO TABLE it_mara WHERE matnr = i_material.

    READ TABLE it_mara INTO wa_mara INDEX 1.

    IF sy-subrc = 0.
      do_it( i_material ).
    ELSE.
      EXIT.
    ENDIF.
  ENDMETHOD.

  METHOD do_it.
  ENDMETHOD.

ENDCLASS.


**********************************************************

START-OF-SELECTION.

  PARAMETERS mat_num TYPE matnr.

  DATA material TYPE material_type.
  DATA material_tmp TYPE lcl_material=>ty_material.

  material-material = mat_num.

  material = material_tmp .

  DATA material_object TYPE REF TO lcl_material.

  material_object = NEW lcl_material(
      i_material = material_tmp
  ).

  WRITE material-material.
