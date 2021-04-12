*&---------------------------------------------------------------------*
*& Report z_ccm_list_marc_records_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_ccm_list_marc_records_04.



* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*select * from marc into table @data(lt_marc)
*  where werks = '1010'.

SELECT * FROM MARC INTO TABLE @DATA(LT_MARC)
 WHERE WERKS = '1010'
 ORDER BY PRIMARY KEY .
* End of Quick Fix


try.

    cl_salv_table=>factory(
      importing r_salv_table = data(lo_alv)
      changing  t_table      = lt_marc ).

    lo_alv->display( ).
  catch cx_salv_error into data(lo_err).
    message lo_err type 'I' display like 'E'.

endtry.
