*&---------------------------------------------------------------------*
*& Report z_ccm_dashb_transactions_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_ccm_dashb_transactions_01.

selection-screen begin of block block.

parameters : mb11 radiobutton group rbg1.
parameters : matgrp03 radiobutton group rbg1.
parameters : default radiobutton group rbg1 DEFAULT 'X'.

selection-screen end of block block.

start-of-selection.

  if mb11 = 'X'.
    call transaction 'MB11' with authority-check.

  elseif matgrp03 = 'X'.
    call transaction 'MATGRP03' with authority-check.

  elseif default = 'X'.
    write 'Default'.

  endif.
