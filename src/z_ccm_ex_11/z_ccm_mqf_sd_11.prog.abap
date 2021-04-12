*&---------------------------------------------------------------------*
*& Report z_ccm_sd_11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_mqf_sd_11.

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

DATA LTRL66C0R5154 TYPE TDT_VBUK.
DATA LTL66C0R8030 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL66C0R5982).
  INSERT VALUE #( VBELN = LDL66C0R5982->VBELN ) INTO TABLE LTL66C0R8030.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL66C0R8030
  IMPORTING
    ET_VBUK             = LTRL66C0R5154
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL66C0R5154 ) > 0.
  CLEAR S_VBUK.
  TYPES: BEGIN OF TYL66C0R120,
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
  END OF TYL66C0R120.
  DATA: LML66C0R8748 TYPE TYL66C0R120,
        LWL66C0R8620 LIKE LINE OF S_VBUK.
  LOOP AT LTRL66C0R5154 REFERENCE INTO DATA(LDRL66C0R6870).
    LML66C0R8748-VBELN = LDRL66C0R6870->VBELN.
    LML66C0R8748-UVALL = LDRL66C0R6870->UVALL.
    LML66C0R8748-LSSTK = LDRL66C0R6870->LSSTK.
    LML66C0R8748-FSSTK = LDRL66C0R6870->FSSTK.
    LML66C0R8748-CMGST = LDRL66C0R6870->CMGST.
    LML66C0R8748-BESTK = LDRL66C0R6870->BESTK.
    LML66C0R8748-LFGSK = LDRL66C0R6870->LFGSK.
    LML66C0R8748-LFSTK = LDRL66C0R6870->LFSTK.
    LML66C0R8748-FKSTK = LDRL66C0R6870->FKSTK.
    LML66C0R8748-SPSTG = LDRL66C0R6870->SPSTG.
    LML66C0R8748-TRSTA = LDRL66C0R6870->TRSTA.
    LML66C0R8748-WBSTK = LDRL66C0R6870->WBSTK.
    LML66C0R8748-GBSTK = LDRL66C0R6870->GBSTK.
    LML66C0R8748-COSTA = LDRL66C0R6870->COSTA.
    LWL66C0R8620 = LML66C0R8748.
    APPEND LWL66C0R8620 TO S_VBUK.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL66C0R5154 ).
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

DATA LL77C0R5223 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL77C0R5223
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_LFSTK = LL77C0R5223-LFSTK.
  L_UVPIS = LL77C0R5223-UVPIS.
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

DATA LL81C0R3292 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL81C0R3292
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL81C0R7823,
    LFSTK TYPE VBUK-LFSTK,
    UVPIS TYPE VBUK-UVPIS,
  END OF TYL81C0R7823.
  DATA LML81C0R8275 TYPE TYL81C0R7823.
  LML81C0R8275-LFSTK = LL81C0R3292-LFSTK.
  LML81C0R8275-UVPIS = LL81C0R3292-UVPIS.
  MOVE-CORRESPONDING LML81C0R8275 TO LS_VBUK.
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

DATA LSL125C0R6980 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL125C0R6980
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUP-FKSTA = LSL125C0R6980-FKSTA.
  LS_VBUP-FKSAA = LSL125C0R6980-FKSAA.
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

DATA LSL132C0R8641 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL132C0R8641
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL132C0R2143,
    FKSTA TYPE VBUP-FKSTA,
    FKSAA TYPE VBUP-FKSAA,
  END OF TYL132C0R2143.
  DATA LML132C0R4515 TYPE TYL132C0R2143.
  LML132C0R4515-FKSTA = LSL132C0R8641-FKSTA.
  LML132C0R4515-FKSAA = LSL132C0R8641-FKSAA.
  MOVE-CORRESPONDING LML132C0R4515 TO LS_VBUP.
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

DATA LTL146C0R9224 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL146C0R9224
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL146C0R9224 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL146C0R8232,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL146C0R8232.
  DATA: LML146C0R9687 TYPE TYL146C0R8232,
        LWL146C0R7149 LIKE LINE OF LT_VBUP.
  LOOP AT LTL146C0R9224 REFERENCE INTO DATA(LDRL146C0R1226).
    LML146C0R9687-VBELN = LDRL146C0R1226->VBELN.
    LML146C0R9687-POSNR = LDRL146C0R1226->POSNR.
    MOVE-CORRESPONDING LML146C0R9687 TO LWL146C0R7149.
    APPEND LWL146C0R7149 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL146C0R9224 ).
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

DATA LL174C0R5038 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = L_VBELN
  IMPORTING
    ES_VBUK             = LL174C0R5038
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL174C0R5368,
    BUCHK TYPE VBUK-BUCHK,
    ABSTK TYPE VBUK-ABSTK,
    UVPAS TYPE VBUK-UVPAS,
  END OF TYL174C0R5368.
  DATA LML174C0R6115 TYPE TYL174C0R5368.
  LML174C0R6115-BUCHK = LL174C0R5038-BUCHK.
  LML174C0R6115-ABSTK = LL174C0R5038-ABSTK.
  LML174C0R6115-UVPAS = LL174C0R5038-UVPAS.
  MOVE-CORRESPONDING LML174C0R6115 TO VBUK.
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

DATA LL199C0R8527 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = L_VBELN
    I_VBOBJ             = 'L'
  IMPORTING
    ES_VBUK             = LL199C0R8527
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_WBSTK = LL199C0R8527-WBSTK.
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

DATA LTL218C0R291 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL218C0R2996).
  INSERT VALUE #( VBELN = LDL218C0R2996->* ) INTO TABLE LTL218C0R291.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL218C0R291
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

DATA LL254C0R2243 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '00001'
  IMPORTING
    ES_VBUK             = LL254C0R2243
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUK-ABSTK = LL254C0R2243-ABSTK.
  LS_VBUK-COSTA = LL254C0R2243-COSTA.
  LS_VBUK-WBSTK = LL254C0R2243-WBSTK.
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

DATA LL258C0R5504 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL258C0R5504
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_LFSTK = LL258C0R5504-LFSTK.
  L_UVPIS = LL258C0R5504-UVPIS.
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

DATA LL263C0R8925 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL263C0R8925
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL263C0R9495,
    LFSTK TYPE VBUK-LFSTK,
    UVPIS TYPE VBUK-UVPIS,
  END OF TYL263C0R9495.
  DATA LML263C0R7036 TYPE TYL263C0R9495.
  LML263C0R7036-LFSTK = LL263C0R8925-LFSTK.
  LML263C0R7036-UVPIS = LL263C0R8925-UVPIS.
  MOVE-CORRESPONDING LML263C0R7036 TO LS_VBUK.
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

DATA LTL282C0R3774 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL282C0R3926).
  INSERT VALUE #( VBELN = LDL282C0R3926->* ) INTO TABLE LTL282C0R3774.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL282C0R3774
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

DATA LTL290C0R3425 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL290C0R7903).
  INSERT VALUE #( VBELN = LDL290C0R7903->VBELN ) INTO TABLE LTL290C0R3425.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL290C0R3425
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

DATA LL294C0R5683 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '01'
  IMPORTING
    ES_VBUK             = LL294C0R5683
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL294C0R9500,
    VBELN TYPE VBUK-VBELN,
    UVALL TYPE VBUK-UVALL,
  END OF TYL294C0R9500.
  DATA LML294C0R5330 TYPE TYL294C0R9500.
  LML294C0R5330-VBELN = LL294C0R5683-VBELN.
  LML294C0R5330-UVALL = LL294C0R5683-UVALL.
  LS_VBUK = LML294C0R5330.
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

DATA LTRL303C0R968 TYPE TDT_VBUK.
DATA LTL303C0R6338 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL303C0R8420).
  INSERT VALUE #( VBELN = LDL303C0R8420->VBELN ) INTO TABLE LTL303C0R6338.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL303C0R6338
  IMPORTING
    ET_VBUK             = LTRL303C0R968
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL303C0R968 ) > 0.
  LT_TARGET = LTRL303C0R968.
  SY-DBCNT = LINES( LTRL303C0R968 ).
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

DATA LSL345C0R7141 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL345C0R7141
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUP-FKSTA = LSL345C0R7141-FKSTA.
  LS_VBUP-FKSAA = LSL345C0R7141-FKSAA.
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

DATA LSL352C0R807 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL352C0R807
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL352C0R4499,
    FKSTA TYPE VBUP-FKSTA,
    FKSAA TYPE VBUP-FKSAA,
  END OF TYL352C0R4499.
  DATA LML352C0R1007 TYPE TYL352C0R4499.
  LML352C0R1007-FKSTA = LSL352C0R807-FKSTA.
  LML352C0R1007-FKSAA = LSL352C0R807-FKSAA.
  MOVE-CORRESPONDING LML352C0R1007 TO LS_VBUP.
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

DATA LTL380C0R1916 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL380C0R1916
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL380C0R1916 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL380C0R7147,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL380C0R7147.
  DATA: LML380C0R9072 TYPE TYL380C0R7147,
        LWL380C0R2257 LIKE LINE OF LT_VBUP.
  LOOP AT LTL380C0R1916 REFERENCE INTO DATA(LDRL380C0R4234).
    LML380C0R9072-VBELN = LDRL380C0R4234->VBELN.
    LML380C0R9072-POSNR = LDRL380C0R4234->POSNR.
    MOVE-CORRESPONDING LML380C0R9072 TO LWL380C0R2257.
    APPEND LWL380C0R2257 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL380C0R1916 ).
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

DATA LTL390C0R1041 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL390C0R1041
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL390C0R1041 ) > 0.
  TYPES: BEGIN OF TYL390C0R166,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL390C0R166.
  DATA: LML390C0R9418 TYPE TYL390C0R166,
        LWL390C0R4301 LIKE LINE OF LT_VBUP.
  LOOP AT LTL390C0R1041 REFERENCE INTO DATA(LDRL390C0R3682).
    LML390C0R9418-VBELN = LDRL390C0R3682->VBELN.
    LML390C0R9418-POSNR = LDRL390C0R3682->POSNR.
    MOVE-CORRESPONDING LML390C0R9418 TO LWL390C0R4301.
    APPEND LWL390C0R4301 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL390C0R1041 ).
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

DATA LTL394C0R3336 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL394C0R3336
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL394C0R3336 ) > 0.
  APPEND LINES OF LTL394C0R3336 TO LT_VBUP.
  SY-DBCNT = LINES( LTL394C0R3336 ).
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
LOOP AT LT_KEY REFERENCE INTO DATA(LDL401C0R3976).
  INSERT VALUE #( VBELN = LDL401C0R3976->* ) INTO TABLE LTL401C0.
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
LOOP AT LT_KEY REFERENCE INTO DATA(LDL405C0R5680).
  INSERT VALUE #( VBELN = LDL405C0R5680->* ) INTO TABLE LTL405C0.
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
LOOP AT LT_KEY REFERENCE INTO DATA(LDL410C0R6902).
  INSERT VALUE #( VBELN = LDL410C0R6902->* ) INTO TABLE LTL410C0.
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
  TYPES: BEGIN OF TYL410C0R1927,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL410C0R1927.
  DATA: LML410C0R5449 TYPE TYL410C0R1927,
        LWL410C0R9939 LIKE LINE OF LT_VBUP.
  LOOP AT LTRL410C0 REFERENCE INTO DATA(LDRL410C0R7237).
    LML410C0R5449-VBELN = LDRL410C0R7237->VBELN.
    LML410C0R5449-POSNR = LDRL410C0R7237->POSNR.
    MOVE-CORRESPONDING LML410C0R5449 TO LWL410C0R9939.
    APPEND LWL410C0R9939 TO LT_VBUP.
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
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL415C0R2197).
  INSERT VALUE #( VBELN = LDL415C0R2197->VBELN ) INTO TABLE LTL415C0.
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
LOOP AT LT_KEYS REFERENCE INTO DATA(LDL424C0R40).
  INSERT VALUE #( VBELN = LDL424C0R40->VBELN
                  POSNR = LDL424C0R40->POSNR ) INTO TABLE LTL424C0.
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
LOOP AT LT_VBUP REFERENCE INTO DATA(LDL443C0R9145).
  INSERT VALUE #( VBELN = LDL443C0R9145->VBELN ) INTO TABLE LTL443C0.
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
  TYPES: BEGIN OF TYL443C0R1670,
    MANDT TYPE VBUP-MANDT,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
    RFSTA TYPE VBUP-RFSTA,
    FKIVP TYPE VBUP-FKIVP,
  END OF TYL443C0R1670.
  DATA: LML443C0R6959 TYPE TYL443C0R1670,
        LWL443C0R5666 LIKE LINE OF LT_VBUP.
  LOOP AT LTRL443C0 REFERENCE INTO DATA(LDRL443C0R4750).
    LML443C0R6959-MANDT = LDRL443C0R4750->MANDT.
    LML443C0R6959-VBELN = LDRL443C0R4750->VBELN.
    LML443C0R6959-POSNR = LDRL443C0R4750->POSNR.
    LML443C0R6959-RFSTA = LDRL443C0R4750->RFSTA.
    LML443C0R6959-FKIVP = LDRL443C0R4750->FKIVP.
    LWL443C0R5666 = LML443C0R6959.
    APPEND LWL443C0R5666 TO LT_VBUP.
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
LOOP AT LT_VBUP REFERENCE INTO DATA(LDL448C0R2903).
  INSERT VALUE #( VBELN = LDL448C0R2903->VBELN
                  POSNR = LDL448C0R2903->POSNR ) INTO TABLE LTL448C0.
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
LOOP AT LT_KEYS REFERENCE INTO DATA(LDL453C0R7916).
  INSERT VALUE #( VBELN = LDL453C0R7916->VBELN ) INTO TABLE LTL453C0.
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
  TYPES: BEGIN OF TYL453C0R2357,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL453C0R2357.
  DATA: LML453C0R9912 TYPE TYL453C0R2357,
        LWL453C0R6056 LIKE LINE OF LT_SMALL_RESULT.
  LOOP AT LTRL453C0 REFERENCE INTO DATA(LDRL453C0R3920).
    LML453C0R9912-VBELN = LDRL453C0R3920->VBELN.
    LML453C0R9912-POSNR = LDRL453C0R3920->POSNR.
    MOVE-CORRESPONDING LML453C0R9912 TO LWL453C0R6056.
    APPEND LWL453C0R6056 TO LT_SMALL_RESULT.
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

DATA LTL467C0R108 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL467C0R108
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL467C0R108 ) > 0.
  LT_SORTED_RESULT = LTL467C0R108.
  SY-DBCNT = LINES( LTL467C0R108 ).
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

DATA LTL473C0R5374 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL473C0R5374
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL473C0R5374 ) > 0.
  INSERT LINES OF LTL473C0R5374 INTO TABLE LT_SORTED.
  SY-DBCNT = LINES( LTL473C0R5374 ).
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

DATA LTL479C0R4915 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL479C0R4915
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL479C0R4915 ) > 0.
  TYPES: BEGIN OF TYL479C0R8848,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL479C0R8848.
  DATA: LML479C0R3600 TYPE TYL479C0R8848,
        LWL479C0R2288 LIKE LINE OF LT_SORTED4.
  LOOP AT LTL479C0R4915 REFERENCE INTO DATA(LDRL479C0R9482).
    LML479C0R3600-VBELN = LDRL479C0R9482->VBELN.
    LML479C0R3600-POSNR = LDRL479C0R9482->POSNR.
    MOVE-CORRESPONDING LML479C0R3600 TO LWL479C0R2288.
    INSERT LWL479C0R2288 INTO TABLE LT_SORTED4.
  ENDLOOP.
  SY-DBCNT = LINES( LTL479C0R4915 ).
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
LOOP AT LT_1234 REFERENCE INTO DATA(LDL490C0R9514).
  INSERT VALUE #( VBELN = LDL490C0R9514->VBELN ) INTO TABLE LTL490C0.
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
