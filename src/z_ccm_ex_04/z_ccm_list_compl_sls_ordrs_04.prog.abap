*&---------------------------------------------------------------------*
*& Report z_ccm_list_compl_sls_ordrs_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_ccm_list_compl_sls_ordrs_04.

data:
  lt_vbak type standard table of vbak with default key,
  lt_vbuk type standard table of vbuk with default key.



* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*select * from vbak into table lt_vbak.

select * from vbak into table lt_vbak ORDER BY PRIMARY KEY .

* End of Quick Fix


if lt_vbak is not initial.


* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*  select * from vbuk
*      into table lt_vbuk
*      for all entries in lt_vbak
*      where vbeln = lt_vbak-vbeln
*      and gbstk = 'C'
*      .

select * from vbuk
      into table lt_vbuk
      for all entries in lt_vbak
      where vbeln = lt_vbak-vbeln
      and gbstk = 'C' ORDER BY PRIMARY KEY
      .

* End of Quick Fix


  loop at lt_vbak into data(ls_vbak).

    read table lt_vbuk with key vbeln = ls_vbak-vbeln binary search transporting no fields.

    if sy-subrc <> 0.

      delete lt_vbak.

    endif.

  endloop.

endif.

try.

    cl_salv_table=>factory(
      importing r_salv_table = data(lo_alv)
      changing  t_table      = lt_vbak ).

    lo_alv->display( ).
  catch cx_salv_error into data(lo_err).
    message lo_err type 'I' display like 'E'.

endtry.
