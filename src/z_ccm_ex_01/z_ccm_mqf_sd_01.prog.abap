*&---------------------------------------------------------------------*
*& Report z_ccm_sd_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_mqf_sd_01.

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
SELECT * FROM vbfa INTO TABLE y_tab ORDER BY PRIMARY KEY .

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

*" CDS-view replacement with INTO CORR...
*select * from  vbuk
*  where  vbeln in ('0000000001', '0000000002')
*    and  ( kostk  not in (' ', 'C')
*     or    lvstk  not in (' ', 'C') ).
*
*endselect.

ls_vbuk-vbeln = '0000000002'.
SELECT SINGLE lvstk
     INTO lv_lvstk
     FROM vbuk
    WHERE vbeln = ls_vbuk-vbeln.


*append '0000000001' to lt_vbuk.
*select vbeln
*       gbstk
*    from vbuk
*    into table s_vbuk
*    for all entries in lt_vbuk
*    where vbeln eq lt_vbuk-vbeln
*    and   gbstk in ('0001', '0002' ).


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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VBUP Examples
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

*select * from vbup where vbeln = '0000000001'
*                     and posnr = '000007'.
*endselect.

" ok
SELECT SINGLE * FROM vbup INTO ls_vbup WHERE vbeln = '0000000001'
                                         AND posnr = '000007'.

*" loop processing
*select * from vbup where vbeln = '0000000001' or  vbeln = '0000000002'.
*  ls_vbup = vbup.
*endselect.

*
*" API ??
*select * from vbup into table s_vbup where vbeln eq '0000000001'
*                    order by primary key.


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

*" no API  because of OR condition => CDS View redirection
*select single * from vbup
*  where vbeln = '0000000001'
*    and posnr = '000007'
*     or posnr = '000008'.


" API Call with move corresponding into table
SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_vbup
  WHERE vbeln = '0000000001'.



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VBUK Examples
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

DATA: l_abstk   TYPE char1,
      lt_result TYPE STANDARD TABLE OF vbuk.
DATA uvs01 TYPE vbuk-uvs01.
DATA: lt_key TYPE STANDARD TABLE OF char10.

"Test case #1  LIKP replacement case: unambiguously
SELECT SINGLE lvstk INTO lv_lvstk FROM vbuk
  WHERE vbeln = l_vbeln.

"Test case #2  VBAK replacement case: unambiguously
SELECT SINGLE abstk costa FROM vbuk INTO CORRESPONDING FIELDS OF vbuk
  WHERE vbeln = l_vbeln.

"Test case #3  VBRK replacement case: unambiguously
SELECT SINGLE relik INTO CORRESPONDING FIELDS OF vbuk FROM vbuk
  WHERE vbeln = l_vbeln.


"Test case #4  Field spread over multiple tables - ambiguously -> but api call
SELECT SINGLE buchk abstk uvpas FROM vbuk INTO CORRESPONDING FIELDS OF vbuk
  WHERE vbeln = l_vbeln.

"Test case #5  Redirection to API call
SELECT SINGLE * FROM vbuk WHERE vbeln EQ '0000000001'.

*"Test case #6  => CDS View
*select * from  vbuk
*  where vbeln in ( '0000000001', '0000000002' )
*    and ( kostk not in ( ' ' , 'C' )
*     or lvstk not in ( ' ' , 'C' ) ).
*
*endselect.

"Test case #7  VBAK replacement case: unambiguously
SELECT SINGLE abstk FROM vbuk INTO l_abstk
  WHERE ( vbeln = l_vbeln ).

"Test case #8  Redirection CDS View
SELECT * FROM vbuk INTO @vbuk
  WHERE vbeln = @l_vbeln.

ENDSELECT.

"Test case #9  Redirect to LIKP but(!!) where clause has to be adjusted
SELECT SINGLE wbstk INTO l_wbstk FROM vbuk
                               WHERE vbeln = l_vbeln
                               AND   vbobj = 'L'.

"Test case #10  Redirection to API call: 1 API parameter
SELECT SINGLE * FROM vbuk INTO ls_vbuk WHERE vbeln EQ '0000000001'.

"Test case #11  Redirection to API call: 2 API parameters
SELECT SINGLE * FROM vbuk INTO ls_vbuk
  WHERE vbeln = '0000000001'
    AND vbobj = 'A'.

"Test case #12  Redirection to API call: 3 API parameters
SELECT SINGLE * FROM vbuk INTO ls_vbuk
  WHERE vbeln = '0000000001'
    AND vbobj = 'A'
    AND vbtyp = 'B'.

"Test case #13  Statement with "FOR ALL ENTRIES" clause
SELECT * FROM vbuk INTO TABLE @lt_result
  FOR ALL ENTRIES IN @lt_key
    WHERE vbeln = @lt_key-table_line.

"Test case #14  Statement with "FOR ALL ENTRIES" clause but unambiguously field list
SELECT wbstk FROM vbuk INTO CORRESPONDING FIELDS OF TABLE lt_result
   FOR ALL ENTRIES IN lt_key
    WHERE vbeln = lt_key-table_line.

"Test case #15  No API QF possible because API doesn't support tables as result => redirect to CDS View
SELECT * FROM vbuk INTO TABLE @lt_result
  WHERE vbeln = '0000000001'.
"Test case #16  VBAK replacement case: unambiguously
SELECT SINGLE abstk costa FROM vbuk INTO ( ls_vbuk-abstk, ls_vbuk-costa )
  WHERE vbeln = l_vbeln.

*"Test case #17  CDS View, because API doesn't support more than one value for "VBELN"
*select single * from vbuk
*  where vbeln = '0000000001' or vbeln = '0000000002'.

"Test case #18  VBUK -> VBAK replacement case: unambiguously
SELECT abstk costa FROM vbuk INTO CORRESPONDING FIELDS OF vbuk
  WHERE vbeln = '0000000001'.
ENDSELECT.

"Test case #19  Redirection to CDS VIEW, because WHERE clause cannot be matched with VBUK-API
SELECT SINGLE * FROM vbuk INTO @ls_vbuk
  WHERE vbeln IN ( '0000000001', '0000000002' ).

"Test case #20  API Call possible. No "other field" of VBUK is used !
"
SELECT SINGLE * FROM vbuk INTO ls_vbuk
  WHERE vbeln = '00001'
   AND  vbtyp = uvs01 .

"Test case #21  Select with field list  => API Call
SELECT SINGLE abstk costa wbstk FROM vbuk INTO ( ls_vbuk-abstk, ls_vbuk-costa, ls_vbuk-wbstk )
  WHERE vbeln = '00001'.

"Test case #22  Select with field list  => API Call
SELECT SINGLE lfstk uvpis INTO ( l_lfstk, l_uvpis )
                          FROM vbuk
                          WHERE vbeln = '0000000002'.

"Test case #23  Select with field list  => API Call
SELECT SINGLE lfstk uvpis INTO CORRESPONDING FIELDS OF ls_vbuk
  FROM vbuk
    WHERE vbeln = '0000000002'.

*"Test case #24  CDS View Replacement : "INTO CORRESPONDING FIELDS" is already in place !
*select single uvk04 uvpis from vbuk into corresponding fields of vbuk.

"Test case #35  VBUK: AEDAT is a field, which was removed in S4H => No Quickfix possible
SELECT SINGLE vbeln, aedat FROM vbuk INTO ( @ls_vbuk-vbeln, @ls_vbuk-aedat ) WHERE vbeln = '01'.

"Test case #36  VBUK redirect to CDS View
*select single a~mandt from t000 as a into @data(p)
*  where not exists ( select * from vbuk where buchk = '0815' ).

"Test case #37
SELECT * FROM vbuk INTO @vbuk WHERE vbeln = @l_vbeln.
ENDSELECT.

"Test case #38    VBUK MULTI API
SELECT * FROM vbuk INTO TABLE lt_result FOR ALL ENTRIES IN lt_key
  WHERE vbeln = lt_key-table_line.

"Test case #39    VBUK
SELECT SINGLE lvstk INTO lv_lvstk FROM vbuk
  WHERE vbeln = ls_vbuk-vbeln.

"Test case #40   VBUK MULTI API : without table_line
SELECT * FROM vbuk INTO TABLE @lt_result FOR ALL ENTRIES IN @lt_vbuk
  WHERE vbeln = @lt_vbuk-vbeln.

"Test case #41   VBUK SINGLE API : without "CORRESPONDING"
SELECT SINGLE vbeln uvall FROM vbuk INTO ls_vbuk WHERE vbeln = '01'.

"Test case #42   VBUK MULTI API: Type of target table is NOT "table of VBUK"
TYPES: BEGIN OF ty_line,
         vbuk    TYPE vbuk,
         field42 TYPE char1,
       END OF ty_line.
DATA lt_target TYPE STANDARD TABLE OF ty_line.

SELECT * FROM vbuk INTO TABLE lt_target FOR ALL ENTRIES IN lt_vbuk
  WHERE vbeln = lt_vbuk-vbeln.

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
SELECT SINGLE * FROM vbup INTO ls_vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000001'.

"Test case #2  VBUP redirect to LIPS
SELECT SINGLE hdall kosta FROM vbup  INTO ls_vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000001'.

"Test case #3  VBUP redirect to VBAP due to selected fields
SELECT SINGLE absta costa FROM vbup INTO ls_vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000001'.

"Test case #4 Redirect to API Single (no into clause)
SELECT SINGLE * FROM vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000001'.

"Test case #5
SELECT SINGLE fksta fksaa
            INTO (ls_vbup-fksta, ls_vbup-fksaa)
            FROM vbup
            WHERE vbeln = '0000000001'
              AND posnr = '000007'.

*"Test case #6
SELECT SINGLE fksta fksaa
             INTO CORRESPONDING FIELDS OF ls_vbup
             FROM vbup
             WHERE vbeln = '0000000001'
               AND posnr = '000007'.

*"Test case #7  loop processing
*select * from vbup where vbeln = '0000000001' or  vbeln = '0000000002'.
*  ls_vbup = vbup.
*endselect.

"Test case #8  Single set result but "into table"
SELECT * FROM vbup INTO TABLE lt_vbup
  WHERE vbeln = '0000000001'
    AND posnr = '000007'.

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
SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_vbup
  WHERE vbeln = '0000000001'.

**"Test case #12
*select single * from vbup
*  where vbeln = '0000000001'
*    and posnr = '000007'
*     or posnr = '000008'.

"Test case #13   API Call with move corresponding appending corresponding field of table
SELECT vbeln posnr FROM vbup APPENDING CORRESPONDING FIELDS OF TABLE lt_vbup
  WHERE vbeln = '0000000001'.

"Test case #14   API Call with "appending table"
SELECT * FROM vbup APPENDING TABLE lt_vbup
  WHERE vbeln = '0000000001'.

"Test case #15  API Call with variables in new syntax style @var
SELECT SINGLE * FROM vbup WHERE vbeln = @ls_vbup-vbeln INTO @ls_vbup.

"Test case #19    VBUP MULTI API
SELECT * FROM vbup INTO TABLE lt_vbup FOR ALL ENTRIES IN lt_key
  WHERE vbeln = lt_key-table_line.

"Test case #20    VBUP MULTI API: APPENDING
SELECT * FROM vbup APPENDING TABLE lt_vbup FOR ALL ENTRIES IN lt_key
  WHERE vbeln = lt_key-table_line.


"Test case #21    VBUP MULTI API: INTO CORRESPONDING FIELDS OF TABLE
SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_vbup FOR ALL ENTRIES IN lt_key
  WHERE vbeln = lt_key-table_line.

"Test case #26   VBUP MULTI API : without table_line
DATA lt_res1 TYPE TABLE OF vbup.
SELECT * FROM vbup INTO TABLE lt_res1 FOR ALL ENTRIES IN lt_vbuk
  WHERE vbeln = lt_vbuk-vbeln.


"Test case #27 : INTO data(x)  => Not possible in FUNCTION CALL
SELECT SINGLE vbeln, posnr FROM vbup INTO ( @DATA(x), @DATA(y) ) WHERE vbeln = '0123456789'.


"Test case #31  VBUP MULTI API  with posnr as additional selection field
SELECT * FROM vbup INTO TABLE lt_vbup FOR ALL ENTRIES IN lt_keys
  WHERE vbeln = lt_keys-vbeln
    AND posnr = lt_keys-posnr.

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
SELECT mandt vbeln posnr rfsta fkivp FROM vbup INTO TABLE lt_vbup FOR ALL ENTRIES IN lt_vbup
  WHERE vbeln = lt_vbup-vbeln.


"Test case #40
SELECT * FROM vbup APPENDING TABLE lt_vbup FOR ALL ENTRIES IN lt_vbup
  WHERE vbeln = lt_vbup-vbeln
    AND posnr = lt_vbup-posnr.

"Test case #41
SELECT vbeln posnr FROM vbup INTO CORRESPONDING FIELDS OF TABLE lt_small_result FOR ALL ENTRIES IN lt_keys
  WHERE vbeln = lt_keys-vbeln.


*"Test case #42
*select vbeln posnr from vbup into corresponding fields of table lt_small_result for all entries in lt_keys
*  where vbeln = lt_keys-vbeln order by primary key.

"Test case #43 RRSTA is a removed field. No Quickfix!
SELECT SINGLE rrsta FROM vbup INTO ls_vbup-rrsta
  WHERE vbeln = '01'.

"Test case #44
DATA: lt_sorted_result TYPE SORTED TABLE OF vbup WITH UNIQUE DEFAULT KEY.
SELECT * FROM vbup INTO TABLE lt_sorted_result
  WHERE vbeln = '0000000001'.


"Test case #45
DATA: lt_sorted TYPE SORTED TABLE OF vbup WITH UNIQUE DEFAULT KEY.
SELECT * FROM vbup APPENDING TABLE lt_sorted
  WHERE vbeln = '0000000001'.


"Test case #46
DATA: lt_sorted4 TYPE SORTED TABLE OF vbup WITH UNIQUE DEFAULT KEY.
SELECT vbeln posnr FROM vbup APPENDING CORRESPONDING FIELDS OF TABLE lt_sorted4
  WHERE vbeln = '0000000001'.

"Test case #47
TYPES: BEGIN OF ty_vbup_extended,
         vbeln TYPE vbup-vbeln,
         attr1 TYPE char1,
       END OF ty_vbup_extended.

DATA lt_1234 TYPE TABLE OF ty_vbup_extended.

SELECT * FROM vbup APPENDING CORRESPONDING FIELDS OF TABLE lt_1234 FOR ALL ENTRIES IN lt_1234
  WHERE vbeln = lt_1234-vbeln.

NEW zcl_ccm_mqf_sd_l1( )->ccm_mqf_l1( ).
NEW zcl_ccm_mqf_sd_l2( )->ccm_mqf_l2( ).
NEW zcl_ccm_mqf_sd_l3( )->ccm_mqf_l3( ).
