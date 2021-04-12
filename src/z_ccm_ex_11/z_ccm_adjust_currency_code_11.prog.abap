*&---------------------------------------------------------------------*
*& Report z_ccm_adjust_currency_code_11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_ccm_adjust_currency_code_11.

tables: konv.

parameters: i_knumv like konv-knumv,
            i_kposn like konv-kposn,
            i_stunr like konv-stunr,
            i_zaehk like konv-zaehk.

selection-screen skip.

parameters: i_waersn like konv-waers obligatory default 'EUR'.


* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*select single * from konv where knumv = i_knumv
*                            and kposn = i_kposn
*                            and stunr = i_stunr
*                            and zaehk = i_zaehk.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 ( fieldname = 'KNUMV' value = I_KNUMV )
 ( fieldname = 'KPOSN' value = I_KPOSN )
 ( fieldname = 'STUNR' value = I_STUNR )
 ( fieldname = 'ZAEHK' value = I_ZAEHK )
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL19C0R6235) ).
  KONV = ETL19C0R6235[ 1 ].
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.
* End of Quick Fix


if sy-subrc = 0.
  update konv set waers = i_waersn
          where knumv = i_knumv
            and kposn = i_kposn
            and stunr = i_stunr
            and zaehk = i_zaehk.
  write: / 'Old Currency :', konv-waers.
else.
  write: / 'No entry in KONV table'.
endif.
