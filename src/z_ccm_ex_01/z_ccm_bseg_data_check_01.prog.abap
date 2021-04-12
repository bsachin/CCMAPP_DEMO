*&---------------------------------------------------------------------*
*& Report z_s4h_bseg_data_check_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_bseg_data_check_01.


TYPES: BEGIN OF bseg_subset,
         bkurs TYPE bseg-bukrs,
         belnr TYPE bseg-belnr,
         gjahr TYPE bseg-gjahr,
         buzei TYPE bseg-buzei,
       END OF bseg_subset.
DATA: i_bseg_entries TYPE STANDARD TABLE OF bseg,
      i_bseg         TYPE STANDARD TABLE OF bseg, i_buzei TYPE bseg-buzei,
      i_bseg_sub     TYPE STANDARD TABLE OF bseg_subset, is_bseg TYPE bseg,
      i_bukrs        TYPE bseg-bukrs, i_belnr TYPE bseg-belnr,
      i_gjahr        TYPE bseg-gjahr,
      i_buzid        TYPE bseg-buzid, p_bukrs TYPE bseg-bukrs,
      gt_bseg        TYPE TABLE OF bseg WITH HEADER LINE.


PARAMETERS fiscyear TYPE gjahr.


SELECT * FROM bseg INTO CORRESPONDING FIELDS OF TABLE i_bseg
WHERE bukrs = i_bukrs AND
      belnr = i_belnr AND
      gjahr = fiscyear ORDER BY PRIMARY KEY.


DATA alv TYPE REF TO cl_salv_table.

cl_salv_table=>factory(
*  exporting
*    list_display   = if_salv_c_bool_sap=>false
*    r_container    =
*    container_name =
  IMPORTING
    r_salv_table   = alv
  CHANGING
    t_table        = i_bseg
).
*catch cx_salv_msg.
*catch cx_salv_msg.

alv->display( ).
