*&---------------------------------------------------------------------*
*& Report z_s4h_bseg_data_check_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_bseg_data_check_04.


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



* Quick Fix Replace SELECT from table BSEG by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM bseg INTO CORRESPONDING FIELDS OF TABLE i_bseg
*WHERE bukrs = i_bukrs AND
*      belnr = i_belnr AND
*      gjahr = fiscyear ORDER BY PRIMARY KEY.

DATA RLDNR_L27C0R6909 TYPE RLDNR.
CALL FUNCTION 'FAGL_GET_LEADING_LEDGER'
  IMPORTING E_RLDNR = RLDNR_L27C0R6909
  EXCEPTIONS NOT_FOUND     = 1
             MORE_THAN_ONE = 2.
IF SY-SUBRC = 0.
CALL FUNCTION 'FAGL_GET_GL_DOCUMENT'
  EXPORTING
    I_RLDNR = RLDNR_L27C0R6909
    I_BUKRS = '1234'
    I_BELNR = '1234567890'
    I_GJAHR = 2019
  IMPORTING
    ET_BSEG = I_BSEG
  EXCEPTIONS NOT_FOUND = 1.
ENDIF.
IF SY-SUBRC <> 0 OR LINES( I_BSEG ) = 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = LINES( I_BSEG ).
ENDIF.

* End of Quick Fix



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
