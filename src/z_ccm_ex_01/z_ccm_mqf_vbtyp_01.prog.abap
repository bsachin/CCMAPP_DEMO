*&---------------------------------------------------------------------*
*& Report z_ccm_vbtyp_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_mqf_vbtyp_01.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VBTYPE Examples
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

include rvvbtyp.

start-of-selection.

data xvbrp type standard table of vbrp.
data  l_vbtyp  type vbtyp.
data it_vbak type standard table of vbak.

" vbtyp_anfr(1)  value 'A',

select * from vbrp into table xvbrp
               where vbeln in ( '0000000001', '0000000002' ).
loop at xvbrp assigning field-symbol(<fs_vbrp>).
  if <fs_vbrp>-vgtyp = vbtyp_anfr.
    return.
  endif.
endloop.


select * from vbak into table it_vbak where vbtyp ne vbtyp_auftr.

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
    l_vbtyp = vbtyp_reto.
*  elseif <vbak>-vbtyp ca vbtyp_agan.    " no QF
*    continue.
  endif.
endloop.
