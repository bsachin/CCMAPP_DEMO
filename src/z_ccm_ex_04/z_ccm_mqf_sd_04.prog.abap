*&---------------------------------------------------------------------*
*& Report z_ccm_sd_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_mqf_sd_04.

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


" VBFA EXAMPLE
DATA: y_tab TYPE STANDARD TABLE OF vbfa.

* Quick Fix Replace ORDER BY PRIMARY KEY with the explicit field sequence
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbfa INTO TABLE y_tab ORDER BY PRIMARY KEY .

SELECT * FROM VBFA INTO TABLE Y_TAB ORDER BY VBELV POSNV VBELN POSNN VBTYP_N.

* End of Quick Fix


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


*" CDS-view replacement with INTO CORR...
*select * from  vbuk
*  where  vbeln in ('0000000001', '0000000002')
*    and  ( kostk  not in (' ', 'C')
*     or    lvstk  not in (' ', 'C') ).
*
*endselect.

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



*append '0000000001' to lt_vbuk.
*select vbeln
*       gbstk
*    from vbuk
*    into table s_vbuk
*    for all entries in lt_vbuk
*    where vbeln eq lt_vbuk-vbeln
*    and   gbstk in ('0001', '0002' ).



* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln uvall lsstk fsstk cmgst bestk lfgsk lfstk fkstk spstg
*       trsta wbstk gbstk costa
*         INTO TABLE s_vbuk
*         FROM vbuk
*         FOR ALL ENTRIES IN lt_vbuk
*         WHERE vbeln EQ lt_vbuk-vbeln.

DATA LTRL66C0R634 TYPE TDT_VBUK.
DATA LTL66C0R6079 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL66C0R5686).
  INSERT VALUE #( VBELN = LDL66C0R5686->VBELN ) INTO TABLE LTL66C0R6079.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL66C0R6079
  IMPORTING
    ET_VBUK             = LTRL66C0R634
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL66C0R634 ) > 0.
  CLEAR S_VBUK.
  TYPES: BEGIN OF TYL66C0R5612,
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
  END OF TYL66C0R5612.
  DATA: LML66C0R251 TYPE TYL66C0R5612,
        LWL66C0R8642 LIKE LINE OF S_VBUK.
  LOOP AT LTRL66C0R634 REFERENCE INTO DATA(LDRL66C0R8146).
    LML66C0R251-VBELN = LDRL66C0R8146->VBELN.
    LML66C0R251-UVALL = LDRL66C0R8146->UVALL.
    LML66C0R251-LSSTK = LDRL66C0R8146->LSSTK.
    LML66C0R251-FSSTK = LDRL66C0R8146->FSSTK.
    LML66C0R251-CMGST = LDRL66C0R8146->CMGST.
    LML66C0R251-BESTK = LDRL66C0R8146->BESTK.
    LML66C0R251-LFGSK = LDRL66C0R8146->LFGSK.
    LML66C0R251-LFSTK = LDRL66C0R8146->LFSTK.
    LML66C0R251-FKSTK = LDRL66C0R8146->FKSTK.
    LML66C0R251-SPSTG = LDRL66C0R8146->SPSTG.
    LML66C0R251-TRSTA = LDRL66C0R8146->TRSTA.
    LML66C0R251-WBSTK = LDRL66C0R8146->WBSTK.
    LML66C0R251-GBSTK = LDRL66C0R8146->GBSTK.
    LML66C0R251-COSTA = LDRL66C0R8146->COSTA.
    LWL66C0R8642 = LML66C0R251.
    APPEND LWL66C0R8642 TO S_VBUK.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL66C0R634 ).
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

DATA LL77C0R3588 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL77C0R3588
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_LFSTK = LL77C0R3588-LFSTK.
  L_UVPIS = LL77C0R3588-UVPIS.
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

DATA LL81C0R7775 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL81C0R7775
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL81C0R81,
    LFSTK TYPE VBUK-LFSTK,
    UVPIS TYPE VBUK-UVPIS,
  END OF TYL81C0R81.
  DATA LML81C0R1368 TYPE TYL81C0R81.
  LML81C0R1368-LFSTK = LL81C0R7775-LFSTK.
  LML81C0R1368-UVPIS = LL81C0R7775-UVPIS.
  MOVE-CORRESPONDING LML81C0R1368 TO LS_VBUK.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VBUP Examples
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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


*select * from vbup where vbeln = '0000000001'
*                     and posnr = '000007'.
*endselect.

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


*" loop processing
*select * from vbup where vbeln = '0000000001' or  vbeln = '0000000002'.
*  ls_vbup = vbup.
*endselect.

*
*" API ??
*select * from vbup into table s_vbup where vbeln eq '0000000001'
*                    order by primary key.


" APi call

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE fksta fksaa
*            INTO (ls_vbup-fksta, ls_vbup-fksaa)
*            FROM vbup
*            WHERE vbeln = '0000000001'
*              AND posnr = '000007'.

DATA LSL125C0R897 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL125C0R897
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUP-FKSTA = LSL125C0R897-FKSTA.
  LS_VBUP-FKSAA = LSL125C0R897-FKSAA.
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

DATA LSL132C0R9876 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL132C0R9876
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL132C0R3851,
    FKSTA TYPE VBUP-FKSTA,
    FKSAA TYPE VBUP-FKSAA,
  END OF TYL132C0R3851.
  DATA LML132C0R2228 TYPE TYL132C0R3851.
  LML132C0R2228-FKSTA = LSL132C0R9876-FKSTA.
  LML132C0R2228-FKSAA = LSL132C0R9876-FKSAA.
  MOVE-CORRESPONDING LML132C0R2228 TO LS_VBUP.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


*" no API  because of OR condition => CDS View redirection
*select single * from vbup
*  where vbeln = '0000000001'
*    and posnr = '000007'
*     or posnr = '000008'.


" API Call with move corresponding into table

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_vbup
*  WHERE vbeln = '0000000001'.

DATA LTL146C0R1991 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL146C0R1991
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL146C0R1991 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL146C0R4432,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL146C0R4432.
  DATA: LML146C0R9501 TYPE TYL146C0R4432,
        LWL146C0R3491 LIKE LINE OF LT_VBUP.
  LOOP AT LTL146C0R1991 REFERENCE INTO DATA(LDRL146C0R4653).
    LML146C0R9501-VBELN = LDRL146C0R4653->VBELN.
    LML146C0R9501-POSNR = LDRL146C0R4653->POSNR.
    MOVE-CORRESPONDING LML146C0R9501 TO LWL146C0R3491.
    APPEND LWL146C0R3491 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL146C0R1991 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VBUK Examples
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

DATA: l_abstk   TYPE char1,
      lt_result TYPE STANDARD TABLE OF vbuk.
DATA uvs01 TYPE vbuk-uvs01.
DATA: lt_key TYPE STANDARD TABLE OF char10.

"Test case #1  LIKP replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table LIKP
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE lvstk INTO lv_lvstk FROM vbuk
*  WHERE vbeln = l_vbeln.

SELECT SINGLE lvstk INTO lv_lvstk FROM LIKP
  WHERE vbeln = l_vbeln.

* End of Quick Fix


"Test case #2  VBAK replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table VBAK
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE abstk costa FROM vbuk INTO CORRESPONDING FIELDS OF vbuk
*  WHERE vbeln = l_vbeln.

SELECT SINGLE abstk costa FROM VBAK INTO CORRESPONDING FIELDS OF vbuk
  WHERE vbeln = l_vbeln.

* End of Quick Fix


"Test case #3  VBRK replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table VBRK
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE relik INTO CORRESPONDING FIELDS OF vbuk FROM vbuk
*  WHERE vbeln = l_vbeln.

SELECT SINGLE relik INTO CORRESPONDING FIELDS OF vbuk FROM VBRK
  WHERE vbeln = l_vbeln.

* End of Quick Fix



"Test case #4  Field spread over multiple tables - ambiguously -> but api call

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE buchk abstk uvpas FROM vbuk INTO CORRESPONDING FIELDS OF vbuk
*  WHERE vbeln = l_vbeln.

DATA LL174C0R3505 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = L_VBELN
  IMPORTING
    ES_VBUK             = LL174C0R3505
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL174C0R3189,
    BUCHK TYPE VBUK-BUCHK,
    ABSTK TYPE VBUK-ABSTK,
    UVPAS TYPE VBUK-UVPAS,
  END OF TYL174C0R3189.
  DATA LML174C0R8120 TYPE TYL174C0R3189.
  LML174C0R8120-BUCHK = LL174C0R3505-BUCHK.
  LML174C0R8120-ABSTK = LL174C0R3505-ABSTK.
  LML174C0R8120-UVPAS = LL174C0R3505-UVPAS.
  MOVE-CORRESPONDING LML174C0R8120 TO VBUK.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #5  Redirection to API call

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbuk WHERE vbeln EQ '0000000001'.

CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ES_VBUK             = VBUK
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


*"Test case #6  => CDS View
*select * from  vbuk
*  where vbeln in ( '0000000001', '0000000002' )
*    and ( kostk not in ( ' ' , 'C' )
*     or lvstk not in ( ' ' , 'C' ) ).
*
*endselect.

"Test case #7  VBAK replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table VBAK
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE abstk FROM vbuk INTO l_abstk
*  WHERE ( vbeln = l_vbeln ).

SELECT SINGLE abstk FROM VBAK INTO l_abstk
  WHERE ( vbeln = l_vbeln ).

* End of Quick Fix


"Test case #8  Redirection CDS View

* Quick Fix Replace VBUK table access with the access of compatibility view V_VBUK_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbuk INTO @vbuk
*  WHERE vbeln = @l_vbeln.

SELECT FROM V_VBUK_S4 FIELDS * WHERE VBELN = @L_VBELN INTO CORRESPONDING FIELDS OF @VBUK .
* End of Quick Fix


ENDSELECT.

"Test case #9  Redirect to LIKP but(!!) where clause has to be adjusted

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE wbstk INTO l_wbstk FROM vbuk
*                               WHERE vbeln = l_vbeln
*                               AND   vbobj = 'L'.

DATA LL199C0R1406 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = L_VBELN
    I_VBOBJ             = 'L'
  IMPORTING
    ES_VBUK             = LL199C0R1406
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_WBSTK = LL199C0R1406-WBSTK.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #10  Redirection to API call: 1 API parameter

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbuk INTO ls_vbuk WHERE vbeln EQ '0000000001'.

CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ES_VBUK             = LS_VBUK
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


"Test case #11  Redirection to API call: 2 API parameters

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbuk INTO ls_vbuk
*  WHERE vbeln = '0000000001'
*    AND vbobj = 'A'.

CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_VBOBJ             = 'A'
  IMPORTING
    ES_VBUK             = LS_VBUK
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


"Test case #12  Redirection to API call: 3 API parameters

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbuk INTO ls_vbuk
*  WHERE vbeln = '0000000001'
*    AND vbobj = 'A'
*    AND vbtyp = 'B'.

CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_VBTYP             = 'B'
    I_VBOBJ             = 'A'
  IMPORTING
    ES_VBUK             = LS_VBUK
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


"Test case #13  Statement with "FOR ALL ENTRIES" clause

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbuk INTO TABLE @lt_result
*  FOR ALL ENTRIES IN @lt_key
*    WHERE vbeln = @lt_key-table_line.

DATA LTL218C0R5237 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL218C0R7216).
  INSERT VALUE #( VBELN = LDL218C0R7216->* ) INTO TABLE LTL218C0R5237.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL218C0R5237
  IMPORTING
    ET_VBUK             = LT_RESULT
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0 OR LINES( LT_RESULT ) = 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = LINES( LT_RESULT ).
ENDIF.

* End of Quick Fix


"Test case #14  Statement with "FOR ALL ENTRIES" clause but unambiguously field list

* Quick Fix Replace VBUK table access with access of table LIKP
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT wbstk FROM vbuk INTO CORRESPONDING FIELDS OF TABLE lt_result
*   FOR ALL ENTRIES IN lt_key
*    WHERE vbeln = lt_key-table_line.

SELECT wbstk FROM LIKP INTO CORRESPONDING FIELDS OF TABLE lt_result
   FOR ALL ENTRIES IN lt_key
    WHERE vbeln = lt_key-table_line.

* End of Quick Fix


"Test case #15  No API QF possible because API doesn't support tables as result => redirect to CDS View

* Quick Fix Replace VBUK table access with the access of compatibility view V_VBUK_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbuk INTO TABLE @lt_result
*  WHERE vbeln = '0000000001'.

SELECT FROM V_VBUK_S4 FIELDS * WHERE VBELN = '0000000001' INTO CORRESPONDING FIELDS OF TABLE @LT_RESULT .
* End of Quick Fix

"Test case #16  VBAK replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table VBAK
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE abstk costa FROM vbuk INTO ( ls_vbuk-abstk, ls_vbuk-costa )
*  WHERE vbeln = l_vbeln.

SELECT SINGLE abstk costa FROM VBAK INTO ( ls_vbuk-abstk, ls_vbuk-costa )
  WHERE vbeln = l_vbeln.

* End of Quick Fix


*"Test case #17  CDS View, because API doesn't support more than one value for "VBELN"
*select single * from vbuk
*  where vbeln = '0000000001' or vbeln = '0000000002'.

"Test case #18  VBUK -> VBAK replacement case: unambiguously

* Quick Fix Replace VBUK table access with access of table VBAK
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT abstk costa FROM vbuk INTO CORRESPONDING FIELDS OF vbuk
*  WHERE vbeln = '0000000001'.

SELECT abstk costa FROM VBAK INTO CORRESPONDING FIELDS OF vbuk
  WHERE vbeln = '0000000001'.

* End of Quick Fix

ENDSELECT.

"Test case #19  Redirection to CDS VIEW, because WHERE clause cannot be matched with VBUK-API

* Quick Fix Replace VBUK table access with the access of compatibility view V_VBUK_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbuk INTO @ls_vbuk
*  WHERE vbeln IN ( '0000000001', '0000000002' ).

SELECT SINGLE FROM V_VBUK_S4 FIELDS * WHERE VBELN IN ( '0000000001' , '0000000002' ) INTO CORRESPONDING FIELDS OF @LS_VBUK .
* End of Quick Fix


"Test case #20  API Call possible. No "other field" of VBUK is used !
"

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbuk INTO ls_vbuk
*  WHERE vbeln = '00001'
*   AND  vbtyp = uvs01 .

CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '00001'
    I_VBTYP             = UVS01
  IMPORTING
    ES_VBUK             = LS_VBUK
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


"Test case #21  Select with field list  => API Call

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE abstk costa wbstk FROM vbuk INTO ( ls_vbuk-abstk, ls_vbuk-costa, ls_vbuk-wbstk )
*  WHERE vbeln = '00001'.

DATA LL254C0R6818 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '00001'
  IMPORTING
    ES_VBUK             = LL254C0R6818
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUK-ABSTK = LL254C0R6818-ABSTK.
  LS_VBUK-COSTA = LL254C0R6818-COSTA.
  LS_VBUK-WBSTK = LL254C0R6818-WBSTK.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #22  Select with field list  => API Call

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE lfstk uvpis INTO ( l_lfstk, l_uvpis )
*                          FROM vbuk
*                          WHERE vbeln = '0000000002'.

DATA LL258C0R5286 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL258C0R5286
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_LFSTK = LL258C0R5286-LFSTK.
  L_UVPIS = LL258C0R5286-UVPIS.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #23  Select with field list  => API Call

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE lfstk uvpis INTO CORRESPONDING FIELDS OF ls_vbuk
*  FROM vbuk
*    WHERE vbeln = '0000000002'.

DATA LL263C0R306 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL263C0R306
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL263C0R5947,
    LFSTK TYPE VBUK-LFSTK,
    UVPIS TYPE VBUK-UVPIS,
  END OF TYL263C0R5947.
  DATA LML263C0R3459 TYPE TYL263C0R5947.
  LML263C0R3459-LFSTK = LL263C0R306-LFSTK.
  LML263C0R3459-UVPIS = LL263C0R306-UVPIS.
  MOVE-CORRESPONDING LML263C0R3459 TO LS_VBUK.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


*"Test case #24  CDS View Replacement : "INTO CORRESPONDING FIELDS" is already in place !
*select single uvk04 uvpis from vbuk into corresponding fields of vbuk.

"Test case #35  VBUK: AEDAT is a field, which was removed in S4H => No Quickfix possible
SELECT SINGLE vbeln, aedat FROM vbuk INTO ( @ls_vbuk-vbeln, @ls_vbuk-aedat ) WHERE vbeln = '01'.

"Test case #36  VBUK redirect to CDS View
*select single a~mandt from t000 as a into @data(p)
*  where not exists ( select * from vbuk where buchk = '0815' ).

"Test case #37

* Quick Fix Replace VBUK table access with the access of compatibility view V_VBUK_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbuk INTO @vbuk WHERE vbeln = @l_vbeln.

SELECT FROM V_VBUK_S4 FIELDS * WHERE VBELN = @L_VBELN INTO CORRESPONDING FIELDS OF @VBUK .

* End of Quick Fix

ENDSELECT.

"Test case #38    VBUK MULTI API

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbuk INTO TABLE lt_result FOR ALL ENTRIES IN lt_key
*  WHERE vbeln = lt_key-table_line.

DATA LTL282C0R8977 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL282C0R4486).
  INSERT VALUE #( VBELN = LDL282C0R4486->* ) INTO TABLE LTL282C0R8977.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL282C0R8977
  IMPORTING
    ET_VBUK             = LT_RESULT
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0 OR LINES( LT_RESULT ) = 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = LINES( LT_RESULT ).
ENDIF.

* End of Quick Fix


"Test case #39    VBUK

* Quick Fix Replace VBUK table access with access of table LIKP
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE lvstk INTO lv_lvstk FROM vbuk
*  WHERE vbeln = ls_vbuk-vbeln.

SELECT SINGLE lvstk INTO lv_lvstk FROM LIKP
  WHERE vbeln = ls_vbuk-vbeln.

* End of Quick Fix


"Test case #40   VBUK MULTI API : without table_line

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbuk INTO TABLE @lt_result FOR ALL ENTRIES IN @lt_vbuk
*  WHERE vbeln = @lt_vbuk-vbeln.

DATA LTL290C0R3503 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL290C0R5830).
  INSERT VALUE #( VBELN = LDL290C0R5830->VBELN ) INTO TABLE LTL290C0R3503.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL290C0R3503
  IMPORTING
    ET_VBUK             = LT_RESULT
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0 OR LINES( LT_RESULT ) = 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = LINES( LT_RESULT ).
ENDIF.

* End of Quick Fix


"Test case #41   VBUK SINGLE API : without "CORRESPONDING"

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE vbeln uvall FROM vbuk INTO ls_vbuk WHERE vbeln = '01'.

DATA LL294C0R6581 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '01'
  IMPORTING
    ES_VBUK             = LL294C0R6581
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL294C0R9541,
    VBELN TYPE VBUK-VBELN,
    UVALL TYPE VBUK-UVALL,
  END OF TYL294C0R9541.
  DATA LML294C0R7687 TYPE TYL294C0R9541.
  LML294C0R7687-VBELN = LL294C0R6581-VBELN.
  LML294C0R7687-UVALL = LL294C0R6581-UVALL.
  LS_VBUK = LML294C0R7687.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #42   VBUK MULTI API: Type of target table is NOT "table of VBUK"
TYPES: BEGIN OF ty_line,
         vbuk    TYPE vbuk,
         field42 TYPE char1,
       END OF ty_line.
DATA lt_target TYPE STANDARD TABLE OF ty_line.


* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbuk INTO TABLE lt_target FOR ALL ENTRIES IN lt_vbuk
*  WHERE vbeln = lt_vbuk-vbeln.

DATA LTRL303C0R8780 TYPE TDT_VBUK.
DATA LTL303C0R2583 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL303C0R1485).
  INSERT VALUE #( VBELN = LDL303C0R1485->VBELN ) INTO TABLE LTL303C0R2583.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL303C0R2583
  IMPORTING
    ET_VBUK             = LTRL303C0R8780
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL303C0R8780 ) > 0.
  LT_TARGET = LTRL303C0R8780.
  SY-DBCNT = LINES( LTRL303C0R8780 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


*"Test case #43   CDS View
*select buchk abstk from vbuk into table lt_vbuk      " no " CORRESPONDING FIELDS OF"  here !!!
*  where vbeln <  '001'.



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VBUP Examples
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


TYPES: BEGIN OF ty_result,
         vbeln TYPE vbup-vbeln,
       END OF ty_result.
DATA: lt_small_result TYPE TABLE OF ty_result,
      lt_keys         TYPE STANDARD TABLE OF vbup,
      count           TYPE i.

"Test case #1   VBUP API_SINGLE

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbup INTO ls_vbup
*  WHERE vbeln = '0000000001'
*    AND posnr = '000001'.

CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000001'
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


"Test case #2  VBUP redirect to LIPS

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


"Test case #3  VBUP redirect to VBAP due to selected fields

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


"Test case #4 Redirect to API Single (no into clause)

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbup
*  WHERE vbeln = '0000000001'
*    AND posnr = '000001'.

CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000001'
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


"Test case #5

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE fksta fksaa
*            INTO (ls_vbup-fksta, ls_vbup-fksaa)
*            FROM vbup
*            WHERE vbeln = '0000000001'
*              AND posnr = '000007'.

DATA LSL345C0R4278 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL345C0R4278
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUP-FKSTA = LSL345C0R4278-FKSTA.
  LS_VBUP-FKSAA = LSL345C0R4278-FKSAA.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


*"Test case #6

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE fksta fksaa
*             INTO CORRESPONDING FIELDS OF ls_vbup
*             FROM vbup
*             WHERE vbeln = '0000000001'
*               AND posnr = '000007'.

DATA LSL352C0R2014 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL352C0R2014
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL352C0R6553,
    FKSTA TYPE VBUP-FKSTA,
    FKSAA TYPE VBUP-FKSAA,
  END OF TYL352C0R6553.
  DATA LML352C0R9061 TYPE TYL352C0R6553.
  LML352C0R9061-FKSTA = LSL352C0R2014-FKSTA.
  LML352C0R9061-FKSAA = LSL352C0R2014-FKSAA.
  MOVE-CORRESPONDING LML352C0R9061 TO LS_VBUP.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


*"Test case #7  loop processing
*select * from vbup where vbeln = '0000000001' or  vbeln = '0000000002'.
*  ls_vbup = vbup.
*endselect.

"Test case #8  Single set result but "into table"

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup INTO TABLE lt_vbup
*  WHERE vbeln = '0000000001'
*    AND posnr = '000007'.

CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ET_VBUP             = LT_VBUP
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0 OR LINES( LT_VBUP ) = 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = LINES( LT_VBUP ).
ENDIF.

* End of Quick Fix


*"Test case #9  Single multiple sets as result but "into table"
*select * from vbup into table lt_vbup
*  where vbeln = '0000000001'
*    and ( posnr = '000007' )
*     or ( posnr = '000008' ).

*"Test case #10  UP TO ONE ROWS
*select * from vbup into table lt_vbup up to 1 rows
*  where vbeln = '0000000001'
*    and posnr = '000007'.

"Test case #11  API Call with move corresponding into table

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_vbup
*  WHERE vbeln = '0000000001'.

DATA LTL380C0R746 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL380C0R746
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL380C0R746 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL380C0R2297,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL380C0R2297.
  DATA: LML380C0R8909 TYPE TYL380C0R2297,
        LWL380C0R7935 LIKE LINE OF LT_VBUP.
  LOOP AT LTL380C0R746 REFERENCE INTO DATA(LDRL380C0R153).
    LML380C0R8909-VBELN = LDRL380C0R153->VBELN.
    LML380C0R8909-POSNR = LDRL380C0R153->POSNR.
    MOVE-CORRESPONDING LML380C0R8909 TO LWL380C0R7935.
    APPEND LWL380C0R7935 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL380C0R746 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


**"Test case #12
*select single * from vbup
*  where vbeln = '0000000001'
*    and posnr = '000007'
*     or posnr = '000008'.

"Test case #13   API Call with move corresponding appending corresponding field of table

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln posnr FROM vbup APPENDING CORRESPONDING FIELDS OF TABLE lt_vbup
*  WHERE vbeln = '0000000001'.

DATA LTL390C0R740 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL390C0R740
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL390C0R740 ) > 0.
  TYPES: BEGIN OF TYL390C0R1976,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL390C0R1976.
  DATA: LML390C0R4229 TYPE TYL390C0R1976,
        LWL390C0R5028 LIKE LINE OF LT_VBUP.
  LOOP AT LTL390C0R740 REFERENCE INTO DATA(LDRL390C0R3594).
    LML390C0R4229-VBELN = LDRL390C0R3594->VBELN.
    LML390C0R4229-POSNR = LDRL390C0R3594->POSNR.
    MOVE-CORRESPONDING LML390C0R4229 TO LWL390C0R5028.
    APPEND LWL390C0R5028 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL390C0R740 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #14   API Call with "appending table"

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup APPENDING TABLE lt_vbup
*  WHERE vbeln = '0000000001'.

DATA LTL394C0R8555 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL394C0R8555
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL394C0R8555 ) > 0.
  APPEND LINES OF LTL394C0R8555 TO LT_VBUP.
  SY-DBCNT = LINES( LTL394C0R8555 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #15  API Call with variables in new syntax style @var

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM vbup WHERE vbeln = @ls_vbup-vbeln INTO @ls_vbup.

CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = LS_VBUP-VBELN
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


"Test case #19    VBUP MULTI API

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup INTO TABLE lt_vbup FOR ALL ENTRIES IN lt_key
*  WHERE vbeln = lt_key-table_line.

DATA LTL401C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL401C0R5245).
  INSERT VALUE #( VBELN = LDL401C0R5245->* ) INTO TABLE LTL401C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL401C0
  IMPORTING
    ET_VBUP             = LT_VBUP
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0 OR LINES( LT_VBUP ) = 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = LINES( LT_VBUP ).
ENDIF.

* End of Quick Fix


"Test case #20    VBUP MULTI API: APPENDING

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup APPENDING TABLE lt_vbup FOR ALL ENTRIES IN lt_key
*  WHERE vbeln = lt_key-table_line.

DATA LTRL405C0 TYPE VBUP_T.
DATA LTL405C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL405C0R5420).
  INSERT VALUE #( VBELN = LDL405C0R5420->* ) INTO TABLE LTL405C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL405C0
  IMPORTING
    ET_VBUP             = LTRL405C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL405C0 ) > 0.
  APPEND LINES OF LTRL405C0 TO LT_VBUP.
  SY-DBCNT = LINES( LTRL405C0 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix



"Test case #21    VBUP MULTI API: INTO CORRESPONDING FIELDS OF TABLE

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_vbup FOR ALL ENTRIES IN lt_key
*  WHERE vbeln = lt_key-table_line.

DATA LTRL410C0 TYPE VBUP_T.
DATA LTL410C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL410C0R5174).
  INSERT VALUE #( VBELN = LDL410C0R5174->* ) INTO TABLE LTL410C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL410C0
  IMPORTING
    ET_VBUP             = LTRL410C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL410C0 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL410C0R3552,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL410C0R3552.
  DATA: LML410C0R9042 TYPE TYL410C0R3552,
        LWL410C0R7025 LIKE LINE OF LT_VBUP.
  LOOP AT LTRL410C0 REFERENCE INTO DATA(LDRL410C0R5332).
    LML410C0R9042-VBELN = LDRL410C0R5332->VBELN.
    LML410C0R9042-POSNR = LDRL410C0R5332->POSNR.
    MOVE-CORRESPONDING LML410C0R9042 TO LWL410C0R7025.
    APPEND LWL410C0R7025 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL410C0 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #26   VBUP MULTI API : without table_line
DATA lt_res1 TYPE TABLE OF vbup.

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup INTO TABLE lt_res1 FOR ALL ENTRIES IN lt_vbuk
*  WHERE vbeln = lt_vbuk-vbeln.

DATA LTL415C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL415C0R2604).
  INSERT VALUE #( VBELN = LDL415C0R2604->VBELN ) INTO TABLE LTL415C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL415C0
  IMPORTING
    ET_VBUP             = LT_RES1
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0 OR LINES( LT_RES1 ) = 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = LINES( LT_RES1 ).
ENDIF.

* End of Quick Fix



"Test case #27 : INTO data(x)  => Not possible in FUNCTION CALL

* Quick Fix Replace VBUP table access with the access of compatibility view V_VBUP_S4
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE vbeln, posnr FROM vbup INTO ( @DATA(x), @DATA(y) ) WHERE vbeln = '0123456789'.

SELECT SINGLE FROM V_VBUP_S4 FIELDS VBELN , POSNR WHERE VBELN = '0123456789' INTO ( @DATA(X) , @DATA(Y) ) .

* End of Quick Fix



"Test case #31  VBUP MULTI API  with posnr as additional selection field

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup INTO TABLE lt_vbup FOR ALL ENTRIES IN lt_keys
*  WHERE vbeln = lt_keys-vbeln
*    AND posnr = lt_keys-posnr.

DATA LTL424C0 TYPE VBUP_KEY_TAB.
LOOP AT LT_KEYS REFERENCE INTO DATA(LDL424C0R8946).
  INSERT VALUE #( VBELN = LDL424C0R8946->VBELN
                  POSNR = LDL424C0R8946->POSNR ) INTO TABLE LTL424C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUP_KEY         = LTL424C0
  IMPORTING
    ET_VBUP             = LT_VBUP
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC <> 0 OR LINES( LT_VBUP ) = 0.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ELSE.
  SY-DBCNT = LINES( LT_VBUP ).
ENDIF.

* End of Quick Fix


**"Test case #32  CDS VIEW
*select * from vbup into table lt_vbup for all entries in lt_key
*  where vbeln = lt_key-table_line
*    and rfsta = 'A'.

*"Test case #33  VBUP redirect to CDS View
*select * from vbup into table @data(lt_vbup2) for all entries in @lt_keys
*  where vbeln = @lt_keys-vbeln
*    and posnr = @lt_keys-posnr.
*
*"Test case #34  VBUP redirect to CDS View without table target
*select count(*) from vbup into count where vbeln = '0000000001'.


"Test case #38  NO "into corresponding fields" !

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT mandt vbeln posnr rfsta fkivp FROM vbup INTO TABLE lt_vbup FOR ALL ENTRIES IN lt_vbup
*  WHERE vbeln = lt_vbup-vbeln.

DATA LTRL443C0 TYPE VBUP_T.
DATA LTL443C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUP REFERENCE INTO DATA(LDL443C0R1881).
  INSERT VALUE #( VBELN = LDL443C0R1881->VBELN ) INTO TABLE LTL443C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL443C0
  IMPORTING
    ET_VBUP             = LTRL443C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL443C0 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL443C0R8186,
    MANDT TYPE VBUP-MANDT,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
    RFSTA TYPE VBUP-RFSTA,
    FKIVP TYPE VBUP-FKIVP,
  END OF TYL443C0R8186.
  DATA: LML443C0R3998 TYPE TYL443C0R8186,
        LWL443C0R2814 LIKE LINE OF LT_VBUP.
  LOOP AT LTRL443C0 REFERENCE INTO DATA(LDRL443C0R3658).
    LML443C0R3998-MANDT = LDRL443C0R3658->MANDT.
    LML443C0R3998-VBELN = LDRL443C0R3658->VBELN.
    LML443C0R3998-POSNR = LDRL443C0R3658->POSNR.
    LML443C0R3998-RFSTA = LDRL443C0R3658->RFSTA.
    LML443C0R3998-FKIVP = LDRL443C0R3658->FKIVP.
    LWL443C0R2814 = LML443C0R3998.
    APPEND LWL443C0R2814 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL443C0 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix



"Test case #40

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup APPENDING TABLE lt_vbup FOR ALL ENTRIES IN lt_vbup
*  WHERE vbeln = lt_vbup-vbeln
*    AND posnr = lt_vbup-posnr.

DATA LTRL448C0 TYPE VBUP_T.
DATA LTL448C0 TYPE VBUP_KEY_TAB.
LOOP AT LT_VBUP REFERENCE INTO DATA(LDL448C0R4399).
  INSERT VALUE #( VBELN = LDL448C0R4399->VBELN
                  POSNR = LDL448C0R4399->POSNR ) INTO TABLE LTL448C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUP_KEY         = LTL448C0
  IMPORTING
    ET_VBUP             = LTRL448C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL448C0 ) > 0.
  APPEND LINES OF LTRL448C0 TO LT_VBUP.
  SY-DBCNT = LINES( LTRL448C0 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #41

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_small_result FOR ALL ENTRIES IN lt_keys
*  WHERE vbeln = lt_keys-vbeln.

DATA LTRL453C0 TYPE VBUP_T.
DATA LTL453C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEYS REFERENCE INTO DATA(LDL453C0R761).
  INSERT VALUE #( VBELN = LDL453C0R761->VBELN ) INTO TABLE LTL453C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL453C0
  IMPORTING
    ET_VBUP             = LTRL453C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL453C0 ) > 0.
  CLEAR LT_SMALL_RESULT.
  TYPES: BEGIN OF TYL453C0R8314,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL453C0R8314.
  DATA: LML453C0R6455 TYPE TYL453C0R8314,
        LWL453C0R7791 LIKE LINE OF LT_SMALL_RESULT.
  LOOP AT LTRL453C0 REFERENCE INTO DATA(LDRL453C0R9974).
    LML453C0R6455-VBELN = LDRL453C0R9974->VBELN.
    LML453C0R6455-POSNR = LDRL453C0R9974->POSNR.
    MOVE-CORRESPONDING LML453C0R6455 TO LWL453C0R7791.
    APPEND LWL453C0R7791 TO LT_SMALL_RESULT.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL453C0 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix



*"Test case #42
*select vbeln posnr from vbup into corresponding fields of table lt_small_result for all entries in lt_keys
*  where vbeln = lt_keys-vbeln order by primary key.

"Test case #43 RRSTA is a removed field. No Quickfix!
SELECT SINGLE rrsta FROM vbup INTO ls_vbup-rrsta
  WHERE vbeln = '01'.

"Test case #44
DATA: lt_sorted_result TYPE SORTED TABLE OF vbup WITH UNIQUE DEFAULT KEY.

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup INTO TABLE lt_sorted_result
*  WHERE vbeln = '0000000001'.

DATA LTL467C0R9799 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL467C0R9799
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL467C0R9799 ) > 0.
  LT_SORTED_RESULT = LTL467C0R9799.
  SY-DBCNT = LINES( LTL467C0R9799 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix



"Test case #45
DATA: lt_sorted TYPE SORTED TABLE OF vbup WITH UNIQUE DEFAULT KEY.

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup APPENDING TABLE lt_sorted
*  WHERE vbeln = '0000000001'.

DATA LTL473C0R7 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL473C0R7
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL473C0R7 ) > 0.
  INSERT LINES OF LTL473C0R7 INTO TABLE LT_SORTED.
  SY-DBCNT = LINES( LTL473C0R7 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix



"Test case #46
DATA: lt_sorted4 TYPE SORTED TABLE OF vbup WITH UNIQUE DEFAULT KEY.

* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT vbeln posnr FROM vbup APPENDING CORRESPONDING FIELDS OF TABLE lt_sorted4
*  WHERE vbeln = '0000000001'.

DATA LTL479C0R1913 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL479C0R1913
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL479C0R1913 ) > 0.
  TYPES: BEGIN OF TYL479C0R1296,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL479C0R1296.
  DATA: LML479C0R9323 TYPE TYL479C0R1296,
        LWL479C0R8784 LIKE LINE OF LT_SORTED4.
  LOOP AT LTL479C0R1913 REFERENCE INTO DATA(LDRL479C0R9134).
    LML479C0R9323-VBELN = LDRL479C0R9134->VBELN.
    LML479C0R9323-POSNR = LDRL479C0R9134->POSNR.
    MOVE-CORRESPONDING LML479C0R9323 TO LWL479C0R8784.
    INSERT LWL479C0R8784 INTO TABLE LT_SORTED4.
  ENDLOOP.
  SY-DBCNT = LINES( LTL479C0R1913 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


"Test case #47
TYPES: BEGIN OF ty_vbup_extended,
         vbeln TYPE vbup-vbeln,
         attr1 TYPE char1,
       END OF ty_vbup_extended.

DATA lt_1234 TYPE TABLE OF ty_vbup_extended.


* Quick Fix Replace SELECT from table VBUP by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbup APPENDING CORRESPONDING FIELDS OF TABLE lt_1234 FOR ALL ENTRIES IN lt_1234
*  WHERE vbeln = lt_1234-vbeln.

DATA LTRL490C0 TYPE VBUP_T.
DATA LTL490C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_1234 REFERENCE INTO DATA(LDL490C0R344).
  INSERT VALUE #( VBELN = LDL490C0R344->VBELN ) INTO TABLE LTL490C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL490C0
  IMPORTING
    ET_VBUP             = LTRL490C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL490C0 ) > 0.
  MOVE-CORRESPONDING LTRL490C0 TO LT_1234 KEEPING TARGET LINES.
  SY-DBCNT = LINES( LTRL490C0 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix


NEW zcl_ccm_mqf_sd_l1( )->ccm_mqf_l1( ).
NEW zcl_ccm_mqf_sd_l2( )->ccm_mqf_l2( ).
NEW zcl_ccm_mqf_sd_l3( )->ccm_mqf_l3( ).
