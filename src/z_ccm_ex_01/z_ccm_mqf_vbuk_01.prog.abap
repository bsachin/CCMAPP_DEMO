*&---------------------------------------------------------------------*
*& Report z_ccm_vbuk_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_mqf_vbuk_01.


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
SELECT abstk costa FROM vbuk INTO CORRESPONDING FIELDS OF vbuk
  WHERE vbeln = '0000000001'.
ENDSELECT.

" LIKP replacement case: unambiguously
SELECT SINGLE lvstk INTO lv_lvstk FROM vbuk
  WHERE vbeln = l_vbeln.

"VBRK replacement case: unambiguously
SELECT SINGLE relik INTO CORRESPONDING FIELDS OF vbuk FROM vbuk
  WHERE vbeln = l_vbeln.




" CDS-view replacement with INTO CORR...
SELECT * FROM  vbuk
  WHERE  vbeln IN ('0000000001', '0000000002')
    AND  ( kostk  NOT IN (' ', 'C')
     OR    lvstk  NOT IN (' ', 'C') ).

ENDSELECT.


ls_vbuk-vbeln = '0000000002'.
SELECT SINGLE lvstk
     INTO lv_lvstk
     FROM vbuk
    WHERE vbeln = ls_vbuk-vbeln.


APPEND '0000000001' TO lt_vbuk.
SELECT vbeln
       gbstk
    FROM vbuk
    INTO TABLE s_vbuk
    FOR ALL ENTRIES IN lt_vbuk
    WHERE vbeln EQ lt_vbuk-vbeln
    AND   gbstk IN ('0001', '0002' ).

SELECT vbeln uvall lsstk fsstk cmgst bestk lfgsk lfstk fkstk spstg
       trsta wbstk gbstk costa
         INTO TABLE s_vbuk
         FROM vbuk
         FOR ALL ENTRIES IN lt_vbuk
         WHERE vbeln EQ lt_vbuk-vbeln.

SELECT SINGLE wbstk INTO l_wbstk
                     FROM vbuk
                     WHERE vbeln = '0000000002'.

SELECT SINGLE lfstk uvpis INTO ( l_lfstk, l_uvpis )
                 FROM vbuk
                 WHERE vbeln = '0000000002'.

SELECT SINGLE lfstk uvpis INTO CORRESPONDING FIELDS OF ls_vbuk
                 FROM vbuk
                 WHERE vbeln = '0000000002'.

" VBUP


" Redirect to LIPS
SELECT SINGLE hdall kosta FROM vbup  INTO ls_vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000001'.

" Redirect to VBAP due to selected fields
SELECT SINGLE absta costa FROM vbup INTO ls_vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000001'.

" no into -> find \cp: ... \da:...
SELECT SINGLE * FROM vbup WHERE vbeln = '0000000001'
                             AND posnr = '000007'.

SELECT * FROM vbup WHERE vbeln = '0000000001'
                     AND posnr = '000007'.
ENDSELECT.
" ok
SELECT SINGLE * FROM vbup INTO ls_vbup WHERE vbeln = '0000000001'
                                         AND posnr = '000007'.
" loop processing
SELECT * FROM vbup WHERE vbeln = '0000000001' OR  vbeln = '0000000002'.
  ls_vbup = vbup.
ENDSELECT.

" API ??
SELECT * FROM vbup INTO TABLE s_vbup WHERE vbeln EQ '0000000001'
                    ORDER BY PRIMARY KEY.
" APi call
SELECT SINGLE fksta fksaa
            INTO (ls_vbup-fksta, ls_vbup-fksaa)
            FROM vbup
            WHERE vbeln = '0000000001'
              AND posnr = '000007'.
" APi call
SELECT SINGLE fksta fksaa
             INTO CORRESPONDING FIELDS OF ls_vbup
             FROM vbup
             WHERE vbeln = '0000000001'
               AND posnr = '000007'.

" no API  because of OR condition => CDS View redirection
SELECT SINGLE * FROM vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000007'
     OR posnr = '000008'.


" API Call with move corresponding into table
SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_vbup
  WHERE vbeln = '0000000001'.
