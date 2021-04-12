*&---------------------------------------------------------------------*
*& Report z_ccm_pricing_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_susg_not_used_01.



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KONV Examples
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Test cases for KONV quickfixes
"
    TYPES: BEGIN OF ty_konv_cust. TYPES abc TYPE c. INCLUDE STRUCTURE konv. TYPES END OF ty_konv_cust.
"
TABLES: konv.
"
DATA: ls_konv       TYPE konv, ls_konv_cust TYPE ty_konv_cust,
      l_datum       TYPE dats, lt_konv_cust TYPE STANDARD TABLE OF ty_konv_cust,
      iv_where      TYPE konv, lt_konv TYPE STANDARD TABLE OF konv,
      lv_value      TYPE STANDARD TABLE OF konv, lv_konv_krech TYPE konv-krech.












"Test case #1  KONV
SELECT SINGLE * FROM konv.





















"Test case #2  KONV
SELECT SINGLE kreli FROM konv INTO CORRESPONDING FIELDS OF konv.











"Test case #3  KONV
SELECT SINGLE kreli kdatu FROM konv INTO CORRESPONDING FIELDS OF konv.











"Test case #4  KONV
SELECT SINGLE kreli FROM konv INTO CORRESPONDING FIELDS OF konv
  WHERE kdatu = l_datum.











*"Test case #5  KONV with "IN"
*select single * from konv where kreli in ( '001' ).











"Test case #6  KONV API: Only = in where clause
SELECT * FROM konv INTO TABLE lv_value WHERE knumv EQ iv_where-knumv AND kschl EQ iv_where-kschl AND kdatu EQ iv_where-kdatu AND zaehk EQ iv_where-zaehk.











*"Test case #7  KONV redirect to CDS View
*select single kreli from konv into corresponding fields of konv
*  where kdatu > l_datum.











"Test case #8 KONV Select into Table
SELECT * FROM konv INTO TABLE lt_konv WHERE knumv EQ iv_where-knumv AND kschl EQ iv_where-kschl AND kdatu EQ iv_where-kdatu AND zaehk EQ iv_where-zaehk.











*"Test case #9 KONV Select into Fields
*select kschl kdatu from konv into (iv_where-kschl, iv_where-kdatu) where knumv EQ iv_where-knumv and kschl eq iv_where-kschl and kdatu eq iv_where-kdatu and zaehk eq iv_where-zaehk.
*endselect.
*










*"Test case #10 Select Star With Endselect
*select * from konv into ls_konv.
*endselect.











"Test case #11 Select with Whitelist Token Violation
SELECT kschl FROM konv INTO TABLE lt_konv GROUP BY kschl.











"Test case #12 Forbidden Tokens
SELECT kschl FROM konv INTO TABLE lt_konv WHERE kposn > 3.











"Test case #13 Forbidden Fields
SELECT kschl kdatu FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv.











*"Test case #14 !Whitelist & Forbidden Fields
*select kschl kdatu from konv into corresponding fields of table lt_konv group by kschl kdatu.











"Test case #15 !Whitelist & Forbidden Tokens
SELECT kschl FROM konv INTO TABLE lt_konv WHERE kposn > 3 GROUP BY kschl.











*"Test case #16 Forbidden Fields & Forbidden Tokens
*select kdatu from konv into corresponding fields of table lt_konv where kposn > 3.











*"Test case #17 Select Star No Target/ No Where
*select * from konv.
*endselect.
*










*"Test case #18 Select Star No Target
*select * from konv where kposn = 3.
*endselect.











"Test case #19 Select Star No Where
SELECT * FROM konv INTO TABLE lt_konv.











"Test case #20 Select Single Star No Target/ No Where
SELECT SINGLE * FROM konv.











"Test case #21 Select Single Star No Target
SELECT SINGLE * FROM konv WHERE kposn = 3.











"Test case #22 Select Single Star No Where
SELECT SINGLE * FROM konv INTO ls_konv.











"Test case #23 Select * No Where
SELECT kschl krech FROM konv INTO TABLE lt_konv.











"Test case #24 Select * Single No Where
SELECT SINGLE kschl krech FROM konv INTO ls_konv.











"Test case #25  Select * into Table KONV APPENDING
SELECT * FROM konv APPENDING TABLE lt_konv .











*"Test case #26  Select * Up To 1 Rows into Table KONV
*select * up to 1 rows from konv into table lt_konv .











"Test case #27  Forbidden Field & Select into Table KONV
SELECT krech FROM konv INTO TABLE lt_konv_cust.











"Test case #28  Forbidden Field & Select into Table KONV APPENDING
SELECT krech FROM konv APPENDING TABLE lt_konv.











"Test case #29  Forbidden Field & Select into Table Cust APPENDING
SELECT krech FROM konv APPENDING TABLE lt_konv_cust.











"Test case #30  Forbidden Field & Select into Table KONV CORRESPONDING-FIELDS
SELECT krech FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv.











"Test case #31  Forbidden Field & Select into Table Cust CORRESPONDING-FIELDS
SELECT krech FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv_cust.











"Test case #32  Forbidden Field & Select into Table KONV APPENDING CORRESPONDING-FIELDS
SELECT krech FROM konv APPENDING CORRESPONDING FIELDS OF TABLE lt_konv.











"Test case #33  Forbidden Field & Select into Table Cust APPENDING CORRESPONDING-FIELDS
SELECT krech FROM konv APPENDING CORRESPONDING FIELDS OF TABLE lt_konv_cust.











"Test case #34  Select Single into Struc KONV
SELECT SINGLE krech FROM konv INTO ls_konv.











"Test case #35  Select Single into Struc Cust
SELECT SINGLE krech FROM konv INTO ls_konv_cust.











"Test case #36  Select * Single into Struc KONV
SELECT SINGLE * FROM konv INTO ls_konv.











"Test case #37  Select Single into Struc KONV
SELECT SINGLE krech FROM konv INTO CORRESPONDING FIELDS OF ls_konv.











"Test case #38  Select Single into Struc Cust
SELECT SINGLE krech FROM konv INTO CORRESPONDING FIELDS OF ls_konv_cust.











"Test case #39  Select * Single into Struc KONV
SELECT SINGLE * FROM konv INTO CORRESPONDING FIELDS OF ls_konv.











"Test case #40  Select * Single into Struc Cust
SELECT SINGLE * FROM konv INTO CORRESPONDING FIELDS OF ls_konv_cust.











"Test case #41  Select Single into Struc KONV
SELECT SINGLE krech FROM konv INTO ls_konv-krech.











"Test case #42  Answer to the Ultimate Question of Life, the Universe, and Everything
SELECT SINGLE krech FROM konv INTO lv_konv_krech.











"Test case #43  No quickfix possible at all because "for update" -> CDS View select would not be allowed
SELECT SINGLE FOR UPDATE krech FROM konv INTO lv_konv_krech.











"Test case #44  CDS View
SELECT SINGLE krech, kschl FROM konv INTO ( @DATA(l_krech), @DATA(l_kschl) ) WHERE kschl < '1'.
