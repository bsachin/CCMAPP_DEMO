*&---------------------------------------------------------------------*
*& Report z_ccm_list_mara_records_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_ccm_list_mara_records_01.

class lcl_app definition create private.

  public section.
    types:
      begin of ty_material,
        matnr type c length 18,
        ersda type ersda,
        ernam type ernam,
        aenam type aenam,
      end of ty_material.
    types:
      ty_materials type standard table of ty_material with non-unique key matnr.

    class-methods create_instance
      returning
        value(result) type ref to lcl_app.

    methods:
      main.
  private section.
    methods:
      select_materials_of_2015
        returning
          value(result) type ty_materials,
      show_materials_in_alv
        changing
          materials type ty_materials.
endclass.

class lcl_app implementation.

  method create_instance.

    create object result.

  endmethod.

  method main.
    data(l_materials) = me->select_materials_of_2015( ).
    me->show_materials_in_alv( changing materials = l_materials ).
  endmethod.

  method select_materials_of_2015.
    data:
      l_material like line of result.

    select matnr, ersda, ernam, aenam from mara into table @data(lt_mara)
      where bmatn = ' '.

    loop at lt_mara assigning field-symbol(<l_mara>).
      if <l_mara>-ersda(4) = '2015'.
        l_material = <l_mara>.
        insert l_material into table result.
      endif.
    endloop.

  endmethod.

  method show_materials_in_alv.
    try.

        cl_salv_table=>factory(
          importing r_salv_table = data(lo_alv)
          changing  t_table      = materials ).

        lo_alv->display( ).
      catch cx_salv_error into data(lo_err).
        message lo_err type 'I' display like 'E'.
    endtry.
  endmethod.

endclass.

start-of-selection.

  lcl_app=>create_instance( )->main( ).
