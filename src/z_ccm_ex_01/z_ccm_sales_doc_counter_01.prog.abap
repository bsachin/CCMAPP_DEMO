*&---------------------------------------------------------------------*
*& Report z_ccm_sales_doc_counter_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_ccm_sales_doc_counter_01.


include rvvbtyp.

start-of-selection.

data it_vbak type standard table of vbak.

select vbeln vbtyp from vbak
  into corresponding fields of table it_vbak
  where vbtyp ne vbtyp_auftr.

field-symbols <vbak> type vbak.
data: lanf_counter type int4,
      ganf_counter type int4,
      ange_counter type int4,
      reto_counter type int4.

loop at it_vbak assigning <vbak>.
  if <vbak>-vbtyp eq vbtyp_lanf.
    lanf_counter = lanf_counter + 1.
  elseif <vbak>-vbtyp eq vbtyp_ganf.
    ganf_counter = ganf_counter + 1.
  elseif <vbak>-vbtyp eq vbtyp_ange.
    ange_counter = ange_counter + 1.
  elseif <vbak>-vbtyp eq vbtyp_reto.
    reto_counter = reto_counter + 1.
  endif.
endloop.


write: / 'LANF :' , lanf_counter.
write: / 'GANF :' , ganf_counter.
write: / 'ANGE :' , ange_counter.
write: / 'RETO :' , reto_counter.
