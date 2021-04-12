*&---------------------------------------------------------------------*
*& Report z_ccm_vbuk_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_mqf_vbuk_04.


TABLES: vbuk, vbup.

DATA ls_vbuk  TYPE vbuk.
DATA ls_vbup  TYPE vbup.
DATA s_vbup   TYPE STANDARD TABLE OF vbup.
DATA s_vbuk   TYPE STANDARD TABLE OF vbuk.
DATA lt_vbuk   TYPE STANDARD TABLE OF vbuk.
DATA lt_vbup  TYPE STANDARD TABLE OF vbup.
DATA lv_lvstk TYPE vbuk-lvstk.
DATA l_wbstk  TYPE vbuk-wbstk.
DATA l_vbeln  TYPE vbuk-vbeln.
DATA: l_lfstk TYPE vbuk-lfstk,
      l_uvpis TYPE vbuk-uvpis.

" VBUK
" vbuk -> VBAK replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table VBAK
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT abstk costa FROM vbuk INTO CORRESPONDING FIELDS OF vbuk
*  WHERE vbeln = '0000000001'.

SELECT abstk costa FROM VBAK INTO CORRESPONDING FIELDS OF vbuk
  WHERE vbeln = '0000000001'.

* End of Quick Fix

ENDSELECT.

" LIKP replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table LIKP
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE lvstk INTO lv_lvstk FROM vbuk
*  WHERE vbeln = l_vbeln.

SELECT SINGLE lvstk INTO lv_lvstk FROM LIKP
  WHERE vbeln = l_vbeln.

* End of Quick Fix


"VBRK replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table VBRK
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE relik INTO CORRESPONDING FIELDS OF vbuk FROM vbuk
*  WHERE vbeln = l_vbeln.

SELECT SINGLE relik INTO CORRESPONDING FIELDS OF vbuk FROM VBRK
  WHERE vbeln = l_vbeln.

* End of Quick Fix





" CDS-view replacement with INTO CORR...

* Quick Fix Replace VBUK table access with the access of compatibility view V_VBUK_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM  vbuk
*  WHERE  vbeln IN ('0000000001', '0000000002')
*    AND  ( kostk  NOT IN (' ', 'C')
*     OR    lvstk  NOT IN (' ', 'C') ).

SELECT FROM V_VBUK_S4 FIELDS * WHERE VBELN IN ( '0000000001' , '0000000002' ) AND ( KOSTK NOT IN ( ' ' , 'C' ) OR LVSTK NOT IN ( ' ' , 'C' ) ) INTO CORRESPONDING FIELDS OF @VBUK .
* End of Quick Fix


ENDSELECT.


ls_vbuk-vbeln = '0000000002'.

* Quick Fix Replace VBUK table access with access of table LIKP
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE lvstk
*     INTO lv_lvstk
*     FROM vbuk
*    WHERE vbeln = ls_vbuk-vbeln.

SELECT SINGLE lvstk
     INTO lv_lvstk
     FROM LIKP
    WHERE vbeln = ls_vbuk-vbeln.

* End of Quick Fix



APPEND '0000000001' TO lt_vbuk.

* Quick Fix Replace VBUK table access with the access of compatibility view V_VBUK_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln
*       gbstk
*    FROM vbuk
*    INTO TABLE s_vbuk
*    FOR ALL ENTRIES IN lt_vbuk
*    WHERE vbeln EQ lt_vbuk-vbeln
*    AND   gbstk IN ('0001', '0002' ).

SELECT FROM V_VBUK_S4 FIELDS VBELN , GBSTK FOR ALL ENTRIES IN @LT_VBUK WHERE VBELN EQ @LT_VBUK-VBELN AND GBSTK IN ( '0001' , '0002' ) INTO TABLE @S_VBUK .
* End of Quick Fix



* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln uvall lsstk fsstk cmgst bestk lfgsk lfstk fkstk spstg
*       trsta wbstk gbstk costa
*         INTO TABLE s_vbuk
*         FROM vbuk
*         FOR ALL ENTRIES IN lt_vbuk
*         WHERE vbeln EQ lt_vbuk-vbeln.

DATA LTRL65C0R5588 TYPE TDT_VBUK.
DATA LTL65C0R4759 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL65C0R9181).
  INSERT VALUE #( VBELN = LDL65C0R9181->VBELN ) INTO TABLE LTL65C0R4759.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL65C0R4759
  IMPORTING
    ET_VBUK             = LTRL65C0R5588
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL65C0R5588 ) > 0.
  CLEAR S_VBUK.
  TYPES: BEGIN OF TYL65C0R2487,
    VBELN TYPE VBUK-VBELN,
    UVALL TYPE VBUK-UVALL,
    LSSTK TYPE VBUK-LSSTK,
    FSSTK TYPE VBUK-FSSTK,
    CMGST TYPE VBUK-CMGST,
    BESTK TYPE VBUK-BESTK,
    LFGSK TYPE VBUK-LFGSK,
    LFSTK TYPE VBUK-LFSTK,
    FKSTK TYPE VBUK-FKSTK,
    SPSTG TYPE VBUK-SPSTG,
    TRSTA TYPE VBUK-TRSTA,
    WBSTK TYPE VBUK-WBSTK,
    GBSTK TYPE VBUK-GBSTK,
    COSTA TYPE VBUK-COSTA,
  END OF TYL65C0R2487.
  DATA: LML65C0R3831 TYPE TYL65C0R2487,
        LWL65C0R6845 LIKE LINE OF S_VBUK.
  LOOP AT LTRL65C0R5588 REFERENCE INTO DATA(LDRL65C0R1669).
    LML65C0R3831-VBELN = LDRL65C0R1669->VBELN.
    LML65C0R3831-UVALL = LDRL65C0R1669->UVALL.
    LML65C0R3831-LSSTK = LDRL65C0R1669->LSSTK.
    LML65C0R3831-FSSTK = LDRL65C0R1669->FSSTK.
    LML65C0R3831-CMGST = LDRL65C0R1669->CMGST.
    LML65C0R3831-BESTK = LDRL65C0R1669->BESTK.
    LML65C0R3831-LFGSK = LDRL65C0R1669->LFGSK.
    LML65C0R3831-LFSTK = LDRL65C0R1669->LFSTK.
    LML65C0R3831-FKSTK = LDRL65C0R1669->FKSTK.
    LML65C0R3831-SPSTG = LDRL65C0R1669->SPSTG.
    LML65C0R3831-TRSTA = LDRL65C0R1669->TRSTA.
    LML65C0R3831-WBSTK = LDRL65C0R1669->WBSTK.
    LML65C0R3831-GBSTK = LDRL65C0R1669->GBSTK.
    LML65C0R3831-COSTA = LDRL65C0R1669->COSTA.
    LWL65C0R6845 = LML65C0R3831.
    APPEND LWL65C0R6845 TO S_VBUK.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL65C0R5588 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix



* Quick Fix Replace VBUK table access with access of table LIKP
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE wbstk INTO l_wbstk
*                     FROM vbuk
*                     WHERE vbeln = '0000000002'.

SELECT SINGLE wbstk INTO l_wbstk
                     FROM LIKP
                     WHERE vbeln = '0000000002'.

* End of Quick Fix



* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE lfstk uvpis INTO ( l_lfstk, l_uvpis )
*                 FROM vbuk
*                 WHERE vbeln = '0000000002'.

DATA LL76C0R725 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL76C0R725
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_LFSTK = LL76C0R725-LFSTK.
  L_UVPIS = LL76C0R725-UVPIS.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix



* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE lfstk uvpis INTO CORRESPONDING FIELDS OF ls_vbuk
*                 FROM vbuk
*                 WHERE vbeln = '0000000002'.

DATA LL80C0R2240 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL80C0R2240
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL80C0R417,
    LFSTK TYPE VBUK-LFSTK,
    UVPIS TYPE VBUK-UVPIS,
  END OF TYL80C0R417.
  DATA LML80C0R388 TYPE TYL80C0R417.
  LML80C0R388-LFSTK = LL80C0R2240-LFSTK.
  LML80C0R388-UVPIS = LL80C0R2240-UVPIS.
  MOVE-CORRESPONDING LML80C0R388 TO LS_VBUK.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


" VBUP


" Redirect to LIPS

* Quick Fix Replace VBUP table access with access of table LIPS
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE hdall kosta FROM vbup  INTO ls_vbup
*  WHERE vbeln = '0000000001'
*    AND posnr = '000001'.

SELECT SINGLE hdall kosta FROM LIPS INTO ls_vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000001'.

* End of Quick Fix


" Redirect to VBAP due to selected fields

* Quick Fix Replace VBUP table access with access of table VBAP
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE absta costa FROM vbup INTO ls_vbup
*  WHERE vbeln = '0000000001'
*    AND posnr = '000001'.

SELECT SINGLE absta costa FROM VBAP INTO ls_vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000001'.

* End of Quick Fix


" no into -> find \cp: ... \da:...

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbup WHERE vbeln = '0000000001'
*                             AND posnr = '000007'.

CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = VBUP
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = 1.
ENDIF.

* End of Quick Fix



* Quick Fix Replace VBUP table access with the access of compatibility view V_VBUP_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup WHERE vbeln = '0000000001'
*                     AND posnr = '000007'.

SELECT FROM V_VBUP_S4 FIELDS * WHERE VBELN = '0000000001' AND POSNR = '000007' INTO CORRESPONDING FIELDS OF @VBUP .
* End of Quick Fix

ENDSELECT.
" ok

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbup INTO ls_vbup WHERE vbeln = '0000000001'
*                                         AND posnr = '000007'.

CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LS_VBUP
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = 1.
ENDIF.

* End of Quick Fix

" loop processing

* Quick Fix Replace VBUP table access with the access of compatibility view V_VBUP_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup WHERE vbeln = '0000000001' OR  vbeln = '0000000002'.

SELECT FROM V_VBUP_S4 FIELDS * WHERE VBELN = '0000000001' OR VBELN = '0000000002' INTO CORRESPONDING FIELDS OF @VBUP .

* End of Quick Fix

  ls_vbup = vbup.
ENDSELECT.

" API ??

* Quick Fix Replace VBUP table access with the access of compatibility view V_VBUP_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup INTO TABLE s_vbup WHERE vbeln EQ '0000000001'
*                    ORDER BY PRIMARY KEY.

SELECT FROM V_VBUP_S4 FIELDS * WHERE VBELN EQ '0000000001' ORDER BY PRIMARY KEY INTO CORRESPONDING FIELDS OF TABLE @S_VBUP .
* End of Quick Fix

" APi call

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE fksta fksaa
*            INTO (ls_vbup-fksta, ls_vbup-fksaa)
*            FROM vbup
*            WHERE vbeln = '0000000001'
*              AND posnr = '000007'.

DATA LSL116C0R8480 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL116C0R8480
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUP-FKSTA = LSL116C0R8480-FKSTA.
  LS_VBUP-FKSAA = LSL116C0R8480-FKSAA.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix

" APi call

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE fksta fksaa
*             INTO CORRESPONDING FIELDS OF ls_vbup
*             FROM vbup
*             WHERE vbeln = '0000000001'
*               AND posnr = '000007'.

DATA LSL122C0R9514 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL122C0R9514
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL122C0R297,
    FKSTA TYPE VBUP-FKSTA,
    FKSAA TYPE VBUP-FKSAA,
  END OF TYL122C0R297.
  DATA LML122C0R7434 TYPE TYL122C0R297.
  LML122C0R7434-FKSTA = LSL122C0R9514-FKSTA.
  LML122C0R7434-FKSAA = LSL122C0R9514-FKSAA.
  MOVE-CORRESPONDING LML122C0R7434 TO LS_VBUP.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


" no API  because of OR condition => CDS View redirection

* Quick Fix Replace VBUP table access with the access of compatibility view V_VBUP_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbup
*  WHERE vbeln = '0000000001'
*    AND posnr = '000007'
*     OR posnr = '000008'.

SELECT SINGLE FROM V_VBUP_S4 FIELDS * WHERE VBELN = '0000000001' AND POSNR = '000007' OR POSNR = '000008' INTO CORRESPONDING FIELDS OF @VBUP .
* End of Quick Fix



" API Call with move corresponding into table

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_vbup
*  WHERE vbeln = '0000000001'.

DATA LTL136C0R1230 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL136C0R1230
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL136C0R1230 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL136C0R9122,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL136C0R9122.
  DATA: LML136C0R1471 TYPE TYL136C0R9122,
        LWL136C0R8371 LIKE LINE OF LT_VBUP.
  LOOP AT LTL136C0R1230 REFERENCE INTO DATA(LDRL136C0R5186).
    LML136C0R1471-VBELN = LDRL136C0R5186->VBELN.
    LML136C0R1471-POSNR = LDRL136C0R5186->POSNR.
    MOVE-CORRESPONDING LML136C0R1471 TO LWL136C0R8371.
    APPEND LWL136C0R8371 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL136C0R1230 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix
