*&---------------------------------------------------------------------*
*& Report z_ccm_sales_documents_00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_sales_documents_00.


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

DATA LTRL162C0R4136 TYPE TDT_VBUK.
DATA LTL162C0R8355 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL162C0R688).
  INSERT VALUE #( VBELN = LDL162C0R688->VBELN ) INTO TABLE LTL162C0R8355.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL162C0R8355
  IMPORTING
    ET_VBUK             = LTRL162C0R4136
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL162C0R4136 ) > 0.
  CLEAR S_VBUK.
  TYPES: BEGIN OF TYL162C0R9993,
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
  END OF TYL162C0R9993.
  DATA: LML162C0R2956 TYPE TYL162C0R9993,
        LWL162C0R5195 LIKE LINE OF S_VBUK.
  LOOP AT LTRL162C0R4136 REFERENCE INTO DATA(LDRL162C0R9175).
    LML162C0R2956-VBELN = LDRL162C0R9175->VBELN.
    LML162C0R2956-UVALL = LDRL162C0R9175->UVALL.
    LML162C0R2956-LSSTK = LDRL162C0R9175->LSSTK.
    LML162C0R2956-FSSTK = LDRL162C0R9175->FSSTK.
    LML162C0R2956-CMGST = LDRL162C0R9175->CMGST.
    LML162C0R2956-BESTK = LDRL162C0R9175->BESTK.
    LML162C0R2956-LFGSK = LDRL162C0R9175->LFGSK.
    LML162C0R2956-LFSTK = LDRL162C0R9175->LFSTK.
    LML162C0R2956-FKSTK = LDRL162C0R9175->FKSTK.
    LML162C0R2956-SPSTG = LDRL162C0R9175->SPSTG.
    LML162C0R2956-TRSTA = LDRL162C0R9175->TRSTA.
    LML162C0R2956-WBSTK = LDRL162C0R9175->WBSTK.
    LML162C0R2956-GBSTK = LDRL162C0R9175->GBSTK.
    LML162C0R2956-COSTA = LDRL162C0R9175->COSTA.
    LWL162C0R5195 = LML162C0R2956.
    APPEND LWL162C0R5195 TO S_VBUK.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL162C0R4136 ).
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

DATA LL193C0R7081 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL193C0R7081
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_LFSTK = LL193C0R7081-LFSTK.
  L_UVPIS = LL193C0R7081-UVPIS.
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

DATA LL207C0R145 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL207C0R145
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL207C0R3839,
    LFSTK TYPE VBUK-LFSTK,
    UVPIS TYPE VBUK-UVPIS,
  END OF TYL207C0R3839.
  DATA LML207C0R2027 TYPE TYL207C0R3839.
  LML207C0R2027-LFSTK = LL207C0R145-LFSTK.
  LML207C0R2027-UVPIS = LL207C0R145-UVPIS.
  MOVE-CORRESPONDING LML207C0R2027 TO LS_VBUK.
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

DATA LSL333C0R1415 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL333C0R1415
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUP-FKSTA = LSL333C0R1415-FKSTA.
  LS_VBUP-FKSAA = LSL333C0R1415-FKSAA.
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

DATA LSL349C0R1886 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL349C0R1886
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL349C0R8701,
    FKSTA TYPE VBUP-FKSTA,
    FKSAA TYPE VBUP-FKSAA,
  END OF TYL349C0R8701.
  DATA LML349C0R9197 TYPE TYL349C0R8701.
  LML349C0R9197-FKSTA = LSL349C0R1886-FKSTA.
  LML349C0R9197-FKSAA = LSL349C0R1886-FKSAA.
  MOVE-CORRESPONDING LML349C0R9197 TO LS_VBUP.
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

DATA LTL383C0R5359 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL383C0R5359
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL383C0R5359 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL383C0R5846,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL383C0R5846.
  DATA: LML383C0R2535 TYPE TYL383C0R5846,
        LWL383C0R2328 LIKE LINE OF LT_VBUP.
  LOOP AT LTL383C0R5359 REFERENCE INTO DATA(LDRL383C0R7319).
    LML383C0R2535-VBELN = LDRL383C0R7319->VBELN.
    LML383C0R2535-POSNR = LDRL383C0R7319->POSNR.
    MOVE-CORRESPONDING LML383C0R2535 TO LWL383C0R2328.
    APPEND LWL383C0R2328 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL383C0R5359 ).
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
DATA uvs01 TYPE char1.
*TABLES: zccm_vbuk.
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

DATA LL470C0R4895 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = L_VBELN
  IMPORTING
    ES_VBUK             = LL470C0R4895
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL470C0R2386,
    BUCHK TYPE VBUK-BUCHK,
    ABSTK TYPE VBUK-ABSTK,
    UVPAS TYPE VBUK-UVPAS,
  END OF TYL470C0R2386.
  DATA LML470C0R7934 TYPE TYL470C0R2386.
  LML470C0R7934-BUCHK = LL470C0R4895-BUCHK.
  LML470C0R7934-ABSTK = LL470C0R4895-ABSTK.
  LML470C0R7934-UVPAS = LL470C0R4895-UVPAS.
  MOVE-CORRESPONDING LML470C0R7934 TO VBUK.
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

DATA LL545C0R9276 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = L_VBELN
    I_VBOBJ             = 'L'
  IMPORTING
    ES_VBUK             = LL545C0R9276
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_WBSTK = LL545C0R9276-WBSTK.
  SY-DBCNT = 1.
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix












"Test case #10  Redirection to API call: 1 API parameter
"

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
"
"

* Quick Fix Replace SELECT from table VBUK by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM vbuk INTO TABLE @lt_result
*  FOR ALL ENTRIES IN @lt_key
*    WHERE vbeln = @lt_key-table_line.

DATA LTL607C0R4822 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL607C0R5491).
  INSERT VALUE #( VBELN = LDL607C0R5491->* ) INTO TABLE LTL607C0R4822.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL607C0R4822
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

DATA LL724C0R4274 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '00001'
  IMPORTING
    ES_VBUK             = LL724C0R4274
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUK-ABSTK = LL724C0R4274-ABSTK.
  LS_VBUK-COSTA = LL724C0R4274-COSTA.
  LS_VBUK-WBSTK = LL724C0R4274-WBSTK.
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

DATA LL738C0R9714 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL738C0R9714
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  L_LFSTK = LL738C0R9714-LFSTK.
  L_UVPIS = LL738C0R9714-UVPIS.
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

DATA LL753C0R8381 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000002'
  IMPORTING
    ES_VBUK             = LL753C0R8381
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL753C0R9821,
    LFSTK TYPE VBUK-LFSTK,
    UVPIS TYPE VBUK-UVPIS,
  END OF TYL753C0R9821.
  DATA LML753C0R520 TYPE TYL753C0R9821.
  LML753C0R520-LFSTK = LL753C0R8381-LFSTK.
  LML753C0R520-UVPIS = LL753C0R8381-UVPIS.
  MOVE-CORRESPONDING LML753C0R520 TO LS_VBUK.
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

DATA LTL822C0R4368 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL822C0R1266).
  INSERT VALUE #( VBELN = LDL822C0R1266->* ) INTO TABLE LTL822C0R4368.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL822C0R4368
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

DATA LTL850C0R9338 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL850C0R2732).
  INSERT VALUE #( VBELN = LDL850C0R2732->VBELN ) INTO TABLE LTL850C0R9338.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL850C0R9338
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

DATA LL864C0R3965 TYPE VBUK.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '01'
  IMPORTING
    ES_VBUK             = LL864C0R3965
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL864C0R7628,
    VBELN TYPE VBUK-VBELN,
    UVALL TYPE VBUK-UVALL,
  END OF TYL864C0R7628.
  DATA LML864C0R9025 TYPE TYL864C0R7628.
  LML864C0R9025-VBELN = LL864C0R3965-VBELN.
  LML864C0R9025-UVALL = LL864C0R3965-UVALL.
  LS_VBUK = LML864C0R9025.
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

DATA LTRL883C0R9030 TYPE TDT_VBUK.
DATA LTL883C0R3856 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL883C0R7520).
  INSERT VALUE #( VBELN = LDL883C0R7520->VBELN ) INTO TABLE LTL883C0R3856.
ENDLOOP.
CALL FUNCTION 'SD_VBUK_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL883C0R3856
  IMPORTING
    ET_VBUK             = LTRL883C0R9030
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL883C0R9030 ) > 0.
  LT_TARGET = LTRL883C0R9030.
  SY-DBCNT = LINES( LTRL883C0R9030 ).
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

DATA LSL1003C0R7929 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL1003C0R7929
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  LS_VBUP-FKSTA = LSL1003C0R7929-FKSTA.
  LS_VBUP-FKSAA = LSL1003C0R7929-FKSAA.
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

DATA LSL1020C0R1668 TYPE VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
    I_POSNR             = '000007'
  IMPORTING
    ES_VBUP             = LSL1020C0R1668
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0.
  TYPES: BEGIN OF TYL1020C0R3057,
    FKSTA TYPE VBUP-FKSTA,
    FKSAA TYPE VBUP-FKSAA,
  END OF TYL1020C0R3057.
  DATA LML1020C0R6815 TYPE TYL1020C0R3057.
  LML1020C0R6815-FKSTA = LSL1020C0R1668-FKSTA.
  LML1020C0R6815-FKSAA = LSL1020C0R1668-FKSAA.
  MOVE-CORRESPONDING LML1020C0R6815 TO LS_VBUP.
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

DATA LTL1098C0R9918 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL1098C0R9918
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL1098C0R9918 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL1098C0R4495,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL1098C0R4495.
  DATA: LML1098C0R8015 TYPE TYL1098C0R4495,
        LWL1098C0R9811 LIKE LINE OF LT_VBUP.
  LOOP AT LTL1098C0R9918 REFERENCE INTO DATA(LDRL1098C0R1319).
    LML1098C0R8015-VBELN = LDRL1098C0R1319->VBELN.
    LML1098C0R8015-POSNR = LDRL1098C0R1319->POSNR.
    MOVE-CORRESPONDING LML1098C0R8015 TO LWL1098C0R9811.
    APPEND LWL1098C0R9811 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL1098C0R9918 ).
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

DATA LTL1128C0R9601 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL1128C0R9601
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL1128C0R9601 ) > 0.
  TYPES: BEGIN OF TYL1128C0R4644,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL1128C0R4644.
  DATA: LML1128C0R7796 TYPE TYL1128C0R4644,
        LWL1128C0R5063 LIKE LINE OF LT_VBUP.
  LOOP AT LTL1128C0R9601 REFERENCE INTO DATA(LDRL1128C0R9562).
    LML1128C0R7796-VBELN = LDRL1128C0R9562->VBELN.
    LML1128C0R7796-POSNR = LDRL1128C0R9562->POSNR.
    MOVE-CORRESPONDING LML1128C0R7796 TO LWL1128C0R5063.
    APPEND LWL1128C0R5063 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTL1128C0R9601 ).
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

DATA LTL1142C0R6377 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL1142C0R6377
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL1142C0R6377 ) > 0.
  APPEND LINES OF LTL1142C0R6377 TO LT_VBUP.
  SY-DBCNT = LINES( LTL1142C0R6377 ).
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

DATA LTL1169C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL1169C0R9884).
  INSERT VALUE #( VBELN = LDL1169C0R9884->* ) INTO TABLE LTL1169C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL1169C0
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

DATA LTRL1183C0 TYPE VBUP_T.
DATA LTL1183C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL1183C0R9840).
  INSERT VALUE #( VBELN = LDL1183C0R9840->* ) INTO TABLE LTL1183C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL1183C0
  IMPORTING
    ET_VBUP             = LTRL1183C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL1183C0 ) > 0.
  APPEND LINES OF LTRL1183C0 TO LT_VBUP.
  SY-DBCNT = LINES( LTRL1183C0 ).
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

DATA LTRL1197C0 TYPE VBUP_T.
DATA LTL1197C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEY REFERENCE INTO DATA(LDL1197C0R4262).
  INSERT VALUE #( VBELN = LDL1197C0R4262->* ) INTO TABLE LTL1197C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL1197C0
  IMPORTING
    ET_VBUP             = LTRL1197C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL1197C0 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL1197C0R1694,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL1197C0R1694.
  DATA: LML1197C0R5135 TYPE TYL1197C0R1694,
        LWL1197C0R8267 LIKE LINE OF LT_VBUP.
  LOOP AT LTRL1197C0 REFERENCE INTO DATA(LDRL1197C0R2668).
    LML1197C0R5135-VBELN = LDRL1197C0R2668->VBELN.
    LML1197C0R5135-POSNR = LDRL1197C0R2668->POSNR.
    MOVE-CORRESPONDING LML1197C0R5135 TO LWL1197C0R8267.
    APPEND LWL1197C0R8267 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL1197C0 ).
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

DATA LTL1212C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUK REFERENCE INTO DATA(LDL1212C0R5093).
  INSERT VALUE #( VBELN = LDL1212C0R5093->VBELN ) INTO TABLE LTL1212C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL1212C0
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

DATA LTL1239C0 TYPE VBUP_KEY_TAB.
LOOP AT LT_KEYS REFERENCE INTO DATA(LDL1239C0R7847).
  INSERT VALUE #( VBELN = LDL1239C0R7847->VBELN
                  POSNR = LDL1239C0R7847->POSNR ) INTO TABLE LTL1239C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUP_KEY         = LTL1239C0
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

DATA LTRL1287C0 TYPE VBUP_T.
DATA LTL1287C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_VBUP REFERENCE INTO DATA(LDL1287C0R9532).
  INSERT VALUE #( VBELN = LDL1287C0R9532->VBELN ) INTO TABLE LTL1287C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL1287C0
  IMPORTING
    ET_VBUP             = LTRL1287C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL1287C0 ) > 0.
  CLEAR LT_VBUP.
  TYPES: BEGIN OF TYL1287C0R4664,
    MANDT TYPE VBUP-MANDT,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
    RFSTA TYPE VBUP-RFSTA,
    FKIVP TYPE VBUP-FKIVP,
  END OF TYL1287C0R4664.
  DATA: LML1287C0R7304 TYPE TYL1287C0R4664,
        LWL1287C0R8101 LIKE LINE OF LT_VBUP.
  LOOP AT LTRL1287C0 REFERENCE INTO DATA(LDRL1287C0R7230).
    LML1287C0R7304-MANDT = LDRL1287C0R7230->MANDT.
    LML1287C0R7304-VBELN = LDRL1287C0R7230->VBELN.
    LML1287C0R7304-POSNR = LDRL1287C0R7230->POSNR.
    LML1287C0R7304-RFSTA = LDRL1287C0R7230->RFSTA.
    LML1287C0R7304-FKIVP = LDRL1287C0R7230->FKIVP.
    LWL1287C0R8101 = LML1287C0R7304.
    APPEND LWL1287C0R8101 TO LT_VBUP.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL1287C0 ).
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

DATA LTRL1301C0 TYPE VBUP_T.
DATA LTL1301C0 TYPE VBUP_KEY_TAB.
LOOP AT LT_VBUP REFERENCE INTO DATA(LDL1301C0R9149).
  INSERT VALUE #( VBELN = LDL1301C0R9149->VBELN
                  POSNR = LDL1301C0R9149->POSNR ) INTO TABLE LTL1301C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUP_KEY         = LTL1301C0
  IMPORTING
    ET_VBUP             = LTRL1301C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL1301C0 ) > 0.
  APPEND LINES OF LTRL1301C0 TO LT_VBUP.
  SY-DBCNT = LINES( LTRL1301C0 ).
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

DATA LTRL1316C0 TYPE VBUP_T.
DATA LTL1316C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_KEYS REFERENCE INTO DATA(LDL1316C0R4012).
  INSERT VALUE #( VBELN = LDL1316C0R4012->VBELN ) INTO TABLE LTL1316C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL1316C0
  IMPORTING
    ET_VBUP             = LTRL1316C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL1316C0 ) > 0.
  CLEAR LT_SMALL_RESULT.
  TYPES: BEGIN OF TYL1316C0R4007,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL1316C0R4007.
  DATA: LML1316C0R4143 TYPE TYL1316C0R4007,
        LWL1316C0R2498 LIKE LINE OF LT_SMALL_RESULT.
  LOOP AT LTRL1316C0 REFERENCE INTO DATA(LDRL1316C0R6529).
    LML1316C0R4143-VBELN = LDRL1316C0R6529->VBELN.
    LML1316C0R4143-POSNR = LDRL1316C0R6529->POSNR.
    MOVE-CORRESPONDING LML1316C0R4143 TO LWL1316C0R2498.
    APPEND LWL1316C0R2498 TO LT_SMALL_RESULT.
  ENDLOOP.
  SY-DBCNT = LINES( LTRL1316C0 ).
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

DATA LTL1359C0R7487 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL1359C0R7487
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL1359C0R7487 ) > 0.
  LT_SORTED_RESULT = LTL1359C0R7487.
  SY-DBCNT = LINES( LTL1359C0R7487 ).
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

DATA LTL1374C0R3334 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL1374C0R3334
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL1374C0R3334 ) > 0.
  INSERT LINES OF LTL1374C0R3334 INTO TABLE LT_SORTED.
  SY-DBCNT = LINES( LTL1374C0R3334 ).
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

DATA LTL1389C0R5464 TYPE TABLE OF VBUP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC'
  EXPORTING
    I_VBELN             = '0000000001'
  IMPORTING
    ET_VBUP             = LTL1389C0R5464
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTL1389C0R5464 ) > 0.
  TYPES: BEGIN OF TYL1389C0R8704,
    VBELN TYPE VBUP-VBELN,
    POSNR TYPE VBUP-POSNR,
  END OF TYL1389C0R8704.
  DATA: LML1389C0R5447 TYPE TYL1389C0R8704,
        LWL1389C0R5156 LIKE LINE OF LT_SORTED4.
  LOOP AT LTL1389C0R5464 REFERENCE INTO DATA(LDRL1389C0R7519).
    LML1389C0R5447-VBELN = LDRL1389C0R7519->VBELN.
    LML1389C0R5447-POSNR = LDRL1389C0R7519->POSNR.
    MOVE-CORRESPONDING LML1389C0R5447 TO LWL1389C0R5156.
    INSERT LWL1389C0R5156 INTO TABLE LT_SORTED4.
  ENDLOOP.
  SY-DBCNT = LINES( LTL1389C0R5464 ).
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

DATA LTRL1410C0 TYPE VBUP_T.
DATA LTL1410C0 TYPE VBUK_KEY_TAB.
LOOP AT LT_1234 REFERENCE INTO DATA(LDL1410C0R2014).
  INSERT VALUE #( VBELN = LDL1410C0R2014->VBELN ) INTO TABLE LTL1410C0.
ENDLOOP.
CALL FUNCTION 'SD_VBUP_READ_FROM_DOC_MULTI'
  EXPORTING
    IT_VBUK_KEY         = LTL1410C0
  IMPORTING
    ET_VBUP             = LTRL1410C0
  EXCEPTIONS
    VBELN_NOT_FOUND     = 1
    VBTYP_NOT_SUPPORTED = 2
    VBOBJ_NOT_SUPPORTED = 3
    OTHERS              = 4.
IF SY-SUBRC = 0 AND LINES( LTRL1410C0 ) > 0.
  MOVE-CORRESPONDING LTRL1410C0 TO LT_1234 KEEPING TARGET LINES.
  SY-DBCNT = LINES( LTRL1410C0 ).
ELSE.
  SY-SUBRC = 4.
  SY-DBCNT = 0.
ENDIF.

* End of Quick Fix
