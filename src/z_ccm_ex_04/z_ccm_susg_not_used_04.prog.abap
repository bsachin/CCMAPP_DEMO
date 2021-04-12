*&---------------------------------------------------------------------*
*& Report z_ccm_pricing_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_ccm_susg_not_used_04.



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

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL37C0R9801) ).
  KONV = ETL37C0R9801[ 1 ].
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix






















"Test case #2  KONV

* Quick Fix Replace KONV table access with access of table PRCD_ELEMENTS
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE kreli FROM konv INTO CORRESPONDING FIELDS OF konv.

SELECT SINGLE kreli FROM PRCD_ELEMENTS INTO CORRESPONDING FIELDS OF konv.

* End of Quick Fix












"Test case #3  KONV

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE kreli kdatu FROM konv INTO CORRESPONDING FIELDS OF konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL73C0R9550) ).
  TYPES: BEGIN OF TYL73C0R323,
    KRELI TYPE KONV-KRELI,
    KDATU TYPE KONV-KDATU,
  END OF TYL73C0R323.
  DATA LML73C0R9455 TYPE TYL73C0R323.
  LML73C0R9455-KRELI = ETL73C0R9550[ 1 ]-KRELI.
  LML73C0R9455-KDATU = ETL73C0R9550[ 1 ]-KDATU.
  MOVE-CORRESPONDING LML73C0R9455 TO KONV.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #4  KONV

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE kreli FROM konv INTO CORRESPONDING FIELDS OF konv
*  WHERE kdatu = l_datum.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 ( fieldname = 'KDATU' value = L_DATUM )
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL86C0R4086) ).
  TYPES: BEGIN OF TYL86C0R8030,
    KRELI TYPE KONV-KRELI,
  END OF TYL86C0R8030.
  DATA LML86C0R7821 TYPE TYL86C0R8030.
  LML86C0R7821-KRELI = ETL86C0R4086[ 1 ]-KRELI.
  MOVE-CORRESPONDING LML86C0R7821 TO KONV.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.
* End of Quick Fix












*"Test case #5  KONV with "IN"
*select single * from konv where kreli in ( '001' ).











"Test case #6  KONV API: Only = in where clause

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM konv INTO TABLE lv_value WHERE knumv EQ iv_where-knumv AND kschl EQ iv_where-kschl AND kdatu EQ iv_where-kdatu AND zaehk EQ iv_where-zaehk.

SELECT * FROM konv INTO TABLE lv_value WHERE knumv EQ iv_where-knumv AND kschl EQ iv_where-kschl AND kdatu EQ iv_where-kdatu AND zaehk EQ iv_where-zaehk ORDER BY PRIMARY KEY .

* End of Quick Fix












*"Test case #7  KONV redirect to CDS View
*select single kreli from konv into corresponding fields of konv
*  where kdatu > l_datum.











"Test case #8 KONV Select into Table

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM konv INTO TABLE lt_konv WHERE knumv EQ iv_where-knumv AND kschl EQ iv_where-kschl AND kdatu EQ iv_where-kdatu AND zaehk EQ iv_where-zaehk.

SELECT * FROM konv INTO TABLE lt_konv WHERE knumv EQ iv_where-knumv AND kschl EQ iv_where-kschl AND kdatu EQ iv_where-kdatu AND zaehk EQ iv_where-zaehk ORDER BY PRIMARY KEY .

* End of Quick Fix












*"Test case #9 KONV Select into Fields
*select kschl kdatu from konv into (iv_where-kschl, iv_where-kdatu) where knumv EQ iv_where-knumv and kschl eq iv_where-kschl and kdatu eq iv_where-kdatu and zaehk eq iv_where-zaehk.
*endselect.
*










*"Test case #10 Select Star With Endselect
*select * from konv into ls_konv.
*endselect.











"Test case #11 Select with Whitelist Token Violation

* Quick Fix Replace KONV table access with access of table PRCD_ELEMENTS
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT kschl FROM konv INTO TABLE lt_konv GROUP BY kschl.

SELECT kschl FROM PRCD_ELEMENTS INTO TABLE lt_konv GROUP BY kschl.

* End of Quick Fix












"Test case #12 Forbidden Tokens

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT kschl FROM konv INTO TABLE lt_konv WHERE kposn > 3.

SELECT kschl FROM konv INTO TABLE lt_konv WHERE kposn > 3 ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #13 Forbidden Fields

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT kschl kdatu FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv.

SELECT kschl kdatu FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv ORDER BY PRIMARY KEY .

* End of Quick Fix












*"Test case #14 !Whitelist & Forbidden Fields
*select kschl kdatu from konv into corresponding fields of table lt_konv group by kschl kdatu.











"Test case #15 !Whitelist & Forbidden Tokens

* Quick Fix Replace KONV table access with access of table PRCD_ELEMENTS
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT kschl FROM konv INTO TABLE lt_konv WHERE kposn > 3 GROUP BY kschl.

SELECT kschl FROM PRCD_ELEMENTS INTO TABLE lt_konv WHERE kposn > 3 GROUP BY kschl.

* End of Quick Fix












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

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM konv INTO TABLE lt_konv.

SELECT * FROM konv INTO TABLE lt_konv ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #20 Select Single Star No Target/ No Where

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL300C0R3647) ).
  KONV = ETL300C0R3647[ 1 ].
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #21 Select Single Star No Target

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM konv WHERE kposn = 3.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 ( fieldname = 'KPOSN' value = 3 )
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL313C0R9516) ).
  KONV = ETL313C0R9516[ 1 ].
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #22 Select Single Star No Where

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM konv INTO ls_konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL326C0R3791) ).
  LS_KONV = ETL326C0R3791[ 1 ].
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #23 Select * No Where

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT kschl krech FROM konv INTO TABLE lt_konv.

SELECT kschl krech FROM konv INTO TABLE lt_konv ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #24 Select * Single No Where

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE kschl krech FROM konv INTO ls_konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL352C0R3165) ).
  TYPES: BEGIN OF TYL352C0R6414,
    KSCHL TYPE KONV-KSCHL,
    KRECH TYPE KONV-KRECH,
  END OF TYL352C0R6414.
  DATA LML352C0R9539 TYPE TYL352C0R6414.
  LML352C0R9539-KSCHL = ETL352C0R3165[ 1 ]-KSCHL.
  LML352C0R9539-KRECH = ETL352C0R3165[ 1 ]-KRECH.
  LS_KONV = LML352C0R9539.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #25  Select * into Table KONV APPENDING

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT * FROM konv APPENDING TABLE lt_konv .

SELECT * FROM konv APPENDING TABLE lt_konv ORDER BY PRIMARY KEY .

* End of Quick Fix












*"Test case #26  Select * Up To 1 Rows into Table KONV
*select * up to 1 rows from konv into table lt_konv .











"Test case #27  Forbidden Field & Select into Table KONV

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT krech FROM konv INTO TABLE lt_konv_cust.

SELECT krech FROM konv INTO TABLE lt_konv_cust ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #28  Forbidden Field & Select into Table KONV APPENDING

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT krech FROM konv APPENDING TABLE lt_konv.

SELECT krech FROM konv APPENDING TABLE lt_konv ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #29  Forbidden Field & Select into Table Cust APPENDING

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT krech FROM konv APPENDING TABLE lt_konv_cust.

SELECT krech FROM konv APPENDING TABLE lt_konv_cust ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #30  Forbidden Field & Select into Table KONV CORRESPONDING-FIELDS

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT krech FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv.

SELECT krech FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #31  Forbidden Field & Select into Table Cust CORRESPONDING-FIELDS

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT krech FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv_cust.

SELECT krech FROM konv INTO CORRESPONDING FIELDS OF TABLE lt_konv_cust ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #32  Forbidden Field & Select into Table KONV APPENDING CORRESPONDING-FIELDS

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT krech FROM konv APPENDING CORRESPONDING FIELDS OF TABLE lt_konv.

SELECT krech FROM konv APPENDING CORRESPONDING FIELDS OF TABLE lt_konv ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #33  Forbidden Field & Select into Table Cust APPENDING CORRESPONDING-FIELDS

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT krech FROM konv APPENDING CORRESPONDING FIELDS OF TABLE lt_konv_cust.

SELECT krech FROM konv APPENDING CORRESPONDING FIELDS OF TABLE lt_konv_cust ORDER BY PRIMARY KEY .

* End of Quick Fix












"Test case #34  Select Single into Struc KONV

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE krech FROM konv INTO ls_konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL482C0R7785) ).
  LS_KONV = ETL482C0R7785[ 1 ]-KRECH.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #35  Select Single into Struc Cust

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE krech FROM konv INTO ls_konv_cust.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL495C0R6253) ).
  LS_KONV_CUST = ETL495C0R6253[ 1 ]-KRECH.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #36  Select * Single into Struc KONV

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM konv INTO ls_konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL508C0R9625) ).
  LS_KONV = ETL508C0R9625[ 1 ].
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #37  Select Single into Struc KONV

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE krech FROM konv INTO CORRESPONDING FIELDS OF ls_konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL521C0R6087) ).
  TYPES: BEGIN OF TYL521C0R8586,
    KRECH TYPE KONV-KRECH,
  END OF TYL521C0R8586.
  DATA LML521C0R6243 TYPE TYL521C0R8586.
  LML521C0R6243-KRECH = ETL521C0R6087[ 1 ]-KRECH.
  MOVE-CORRESPONDING LML521C0R6243 TO LS_KONV.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #38  Select Single into Struc Cust

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE krech FROM konv INTO CORRESPONDING FIELDS OF ls_konv_cust.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL534C0R5642) ).
  TYPES: BEGIN OF TYL534C0R1520,
    KRECH TYPE KONV-KRECH,
  END OF TYL534C0R1520.
  DATA LML534C0R6789 TYPE TYL534C0R1520.
  LML534C0R6789-KRECH = ETL534C0R5642[ 1 ]-KRECH.
  MOVE-CORRESPONDING LML534C0R6789 TO LS_KONV_CUST.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #39  Select * Single into Struc KONV

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM konv INTO CORRESPONDING FIELDS OF ls_konv.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL547C0R9039) ).
  LS_KONV = ETL547C0R9039[ 1 ].
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #40  Select * Single into Struc Cust

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE * FROM konv INTO CORRESPONDING FIELDS OF ls_konv_cust.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL560C0R2382) ).
  MOVE-CORRESPONDING ETL560C0R2382[ 1 ] TO LS_KONV_CUST.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #41  Select Single into Struc KONV

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE krech FROM konv INTO ls_konv-krech.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL573C0R7390) ).
  LS_KONV-KRECH = ETL573C0R7390[ 1 ]-KRECH.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #42  Answer to the Ultimate Question of Life, the Universe, and Everything

* Quick Fix Replace SELECT from table KONV by API Call
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE krech FROM konv INTO lv_konv_krech.

TRY.

CL_PRC_RESULT_FACTORY=>GET_INSTANCE( )->GET_PRC_RESULT( )->GET_PRICE_ELEMENT_DB(
  EXPORTING IT_SELECTION_ATTRIBUTE = VALUE #(
 )
  IMPORTING ET_PRC_ELEMENT_CLASSIC_FORMAT = DATA(ETL586C0R8048) ).
  LV_KONV_KRECH = ETL586C0R8048[ 1 ]-KRECH.
CATCH CX_PRC_RESULT CX_SY_ITAB_LINE_NOT_FOUND .
  SY-SUBRC = 4.
ENDTRY.

* End of Quick Fix












"Test case #43  No quickfix possible at all because "for update" -> CDS View select would not be allowed
SELECT SINGLE FOR UPDATE krech FROM konv INTO lv_konv_krech.











"Test case #44  CDS View

* Quick Fix Replace KONV table access with the access of compatibility view V_KONV
* Transport S4HK901457 CodeJam
* Replaced Code:
*SELECT SINGLE krech, kschl FROM konv INTO ( @DATA(l_krech), @DATA(l_kschl) ) WHERE kschl < '1'.

SELECT SINGLE FROM V_KONV FIELDS KRECH , KSCHL WHERE KSCHL < '1' INTO ( @DATA(L_KRECH) , @DATA(L_KSCHL) ) .

* End of Quick Fix
