*********************
*** PROGRAM START ***
*********************
PROCEDURE PROGRAM_START
   *** RUNS AT PROGRAM START RIGHT AFTER LOGING INTO PROGRAM
ENDPROC

********************
*** PROGRAM EXIT ***
********************
PROCEDURE PROGRAM_EXIT
  *** RUNS RIGHT BEFORE THE QUIT/CLEAR EVENTS IN PROGRAM EXIT
ENDPROC

*****************************
*** CUSTOM MENU PROCEDURE ***
*****************************

PROCEDURE CUSTOM_MENU_TITLE  && TOP LEVEL MENU 
   *** THERE ARE VARIABLE TO DEFINE THE TOP LEVEL MENU NAME
   *** XMENUVAR(1,1) - RETURN .T. TO MAKE MENU VISIBLE / RETURN .F. TO MAKE MENU INVISIBLE
   *** XMENUVAR(1,2) - MENU NAME
   *** XMENUVAR(1,3) - MENU MESSAGE
   
   XMENUVAR(1,1) = .T.
   XMENUVAR(1,2) = 'Options'
   XMENUVAR(1,3) = 'Options for Shipping'
   
ENDPROC

PROCEDURE CUSTOM_MENU_DEFINE  && DEFINE MENU ITEMS
   *** CREATE A CUSTOM MENU
   *** USE INTERFACE IN THE DEFINE BAR TO CREATE YOUR OWN MENU
   
   DEFINE BAR 1 OF INTERFACE PROMPT "\<Interface Setup" MESSAGE "Interface Setup"
   ON SELECTION BAR 1 OF INTERFACE DO ODBC_SETUP_SCREEN IN SETUP_MAIN WITH 'PASSWORD'
ENDPROC

*****************************
*** CUSTOM MENU PROCEDURE ***
*****************************

************************************
*** START SHIP SCREEN PROCEDURES ***
************************************

PROCEDURE SHIPSCREEN_LOAD
   *=MESSAGEBOX('SHIP SCREEN LOAD PROCEDURE')
   *** POPULATE (LOAD_SHIP = .F.) TO STOP LOADING SHIP SCREEN
ENDPROC

FUNC BUILD_STATEMENT(TABLE_ALIAS)
   ODBC_TABLE = CURVAL('TABLE', TABLE_ALIAS)
   ODBC_IO = CURVAL('IO', TABLE_ALIAS)
   STATEMENT = "SELECT"
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'IO', 'INTERFACE_PROMPT', 1)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'PKG_ID', 'PACKAGE_ID', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'INVC_NO', 'INVOICE_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'ORD_NO', 'ORDER_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'PO_NO', 'PO_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'DEPT_NO', 'DEPT_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'REF1', 'REF1', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'REF2', 'REF2', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'REF3', 'REF3', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'TRCARCODE', 'TRANSLATED_CARRIER_CODE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'TRCTRYCD', 'TRANSLATED_COUNTRY_CODE', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPWT', 'SHIP_WEIGHT', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPCUST', 'SHIPTO_CUSTOMER_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPCOMP', 'SHIPTO_COMPANY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPATTN', 'SHIPTO_ATTN', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPADDR1', 'SHIPTO_ADDR1', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPADDR2', 'SHIPTO_ADDR2', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPADDR3', 'SHIPTO_ADDR3', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPCITY', 'SHIPTO_CITY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPSTATE', 'SHIPTO_STATE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPZIP', 'SHIPTO_ZIP', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPCTRY', 'SHIPTO_COUNTRY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPCTRYCD', 'SHIPTO_COUNTRY_CODE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPPHNO', 'SHIPTO_PHONE_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPFAXNO', 'SHIPTO_FAX_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SHIPEMAIL', 'SHIPTO_EMAIL', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLMETHOD', 'BILLING_METHOD', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLCARACT', 'BILLTO_CARRIER_ACCT_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLCOMP', 'BILLTO_COMPANY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLATTN', 'BILLTO_ATTN', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLADDR1', 'BILLTO_ADDR1', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLADDR2', 'BILLTO_ADDR2', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLADDR', 'BILLTO_ADDR', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLCITY', 'BILLTO_CITY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLSTATE', 'BILLTO_STATE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLZIP', 'BILLTO_ZIP', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLCTRY', 'BILLTO_COUNTRY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLCTRYCD', 'BILLTO_COUNTRY_CODE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLPHNO', 'BILLTO_PHONE_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLFAXNO', 'BILLTO_FAX_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'BILLNO', 'BILLTO_NO', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETNAME', 'RETURNLABEL_NAME', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETATTN', 'RETURNLABEL_ATTN', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETADDR1', 'RETURNLABEL_ADDR1', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETCITY', 'RETURNLABEL_CITY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETSTATE', 'RETURNLABEL_STATE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETZIP', 'RETURNLABEL_ZIP', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETCTRY', 'RETURNLABEL_COUNTRY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETCTRYCD', 'RETURNLABEL_COUNTRY_CODE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETPHNO', 'RETURNLABEL_PHONE_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETFAXNO', 'RETURNLABEL_FAX_NO', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETADDR2', 'RETURNLABEL_ADDR2', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RETADDR3', 'RETURNLABEL_ADDR3', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'COD', 'COD', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'ADDTOCOD', 'ADDTO_COD', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'CLCTCOD', 'COLLECT_COD', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'INSUR', 'INSURANCE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SATDELIV', 'SAT_DELIVERY', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'SATPICKUP', 'SAT_PICKUP', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'DIMNSNL', 'DIMENSIONAL', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RSDNTL', 'RESIDENTIAL', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'CODAMNT', 'COD_AMOUNT', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'CODCHRG', 'COD_CHARGE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'INSURAMNT', 'INSURANCE_AMOUNT', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'INSURCHRG', 'INSURANCE_CHARGE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'CALLTGCHRG', 'CALL_TAG_CHARGE', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'DIMLENGTH', 'DIMENSIONAL_LENGTH', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'DIMWIDTH', 'DIMENSIONAL_WIDTH', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'DIMHEIGHT', 'DIMESIONAL_HEIGHT', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'DIMWEIGHT', 'DIMENSIONAL_WEIGHT', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'MISC1', 'MISC1', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'MISC2', 'MISC2', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'MISC3', 'MISC3', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'MISC4', 'MISC4', 0)
   
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RBRSTMP1', 'RUBBER_STAMP1', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RBRSTMP2', 'RUBBER_STAMP2', 0)
   STATEMENT = STATEMENT + ADD_ODBC_FIELD(TABLE_ALIAS, 'RBRSTMP3', 'RUBBER_STAMP3', 0)

   STATEMENT = STATEMENT + " FROM " + ODBC_TABLE + " WHERE " + ODBC_IO + " = "
   RETURN STATEMENT
ENDFUNC

FUNC BUILD_RETSTATEMENT(TABLE_ALIAS)

   ODBC_TABLE = CURVAL('TABLE', TABLE_ALIAS)
   IF UPPER(ALLTRIM(CURVAL('RETTYPE', TABLE_ALIAS))) == 'INSERT'
      STATEMENT = 'INSERT INTO ' + ODBC_TABLE + ' ('
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'IO', 1)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'PACKID', 0)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'TRACKNUM', 0)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'SERVCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'DISFRTCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'DISTOTCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'PUBFRTCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'PUBTOTCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'BILLWGT', 0)
      STATEMENT = STATEMENT + ADD_RETODBC_FIELD(TABLE_ALIAS, 'SHIPWGT', 0)
      STATEMENT = STATEMENT + ') VALUES('
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'IO', 1)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'PACKID', 0)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'TRACKNUM', 0)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'SERVCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'DISFRTCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'DISTOTCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'PUBFRTCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'PUBTOTCHRG', 0)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'BILLWGT', 0)
      STATEMENT = STATEMENT + ADD_RETBLANK(TABLE_ALIAS, 'SHIPWGT', 0)
      STATEMENT = STATEMENT + ')'
   ELSE
      IF UPPER(ALLTRIM(CURVAL('RETTYPE', TABLE_ALIAS))) == 'UPDATE'
         STATEMENT = 'UPDATE ' + ODBC_TABLE + ' SET '
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'PACKID', 1)
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'TRACKNUM', 0)
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'SERVCHRG', 0)
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'DISFRTCHRG', 0)
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'DISTOTCHRG', 0)
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'PUBFRTCHRG', 0)
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'PUBTOTCHRG', 0)
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'BILLWGT', 0)
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'SHIPWGT', 0)
         STATEMENT = STATEMENT + ' WHERE'
         STATEMENT = STATEMENT + ADD_UPDATEODBC_FIELD(TABLE_ALIAS, 'IO', 1)
      ELSE
         =MESSAGEBOX('Invalid interface setup file', 64, 'Invalid File')
      ENDIF
   ENDIF

   RETURN STATEMENT
ENDFUNC


PROCEDURE SHIPSCREEN_INIT
   *=MESSAGEBOX('SHIP SCREEN INIT PROCEDURE')
      
   *** ODBC VARIABLES ***
   PUBLIC ODBC_CONNECT,ODBC_HANDLE,ODBC_RETCODE
   PUBLIC ODBC_DATASOURCE,ODBC_LOGIN,ODBC_PASSWORD
   PUBLIC CUSTOM_ODBC_STATEMENT, CUSTOM_ODBC_RETSTATEMENT
   PUBLIC IO_TYPE
   
   STORE .F. TO ODBC_CONNECT
   STORE '' TO ODBC_HANDLE,ODBC_RETCODE,ODBC_TOTALOPTION
   STORE '' TO CUSTOM_ODBC_STATEMENT, CUSTOM_ODBC_RETSTATEMENT

   SETUPFILE = 'INTERFACESETUP.DBF'
   IF ! FILE(SETUPFILE)
      =MESSAGEBOX('Interface setup file not found', 64, 'File Not Found')
      RETURN
   ENDIF
   
   TABLE_ALIAS = 'SETUPTBL' 
   USE(SETUPFILE) IN 0 ALIAS(TABLE_ALIAS) SHARED
   SELECT(TABLE_ALIAS)
   
   *** ADDED 05/13/2016 SO THAT CURVAL FUNCTION WORKS
   CURSORSETPROP("buffering",2,TABLE_ALIAS)
   
   IF CURVAL('TYPE',TABLE_ALIAS) != 1
      =MESSAGEBOX('Invalid interface setup file', 64, 'Invalid File')
      RETURN
   ENDIF
   
   *** STORE ODBC VARIABLE INFO HERE ***
   ODBC_DATASOURCE = CURVAL('DSN',TABLE_ALIAS)
   ODBC_LOGIN = CURVAL('USER',TABLE_ALIAS)
   ODBC_PASSWORD = CURVAL('PASS',TABLE_ALIAS)
   
   CUSTOM_ODBC_STATEMENT = BUILD_STATEMENT(TABLE_ALIAS)

   TABLENAME = CURVAL('TABLE', TABLE_ALIAS)
   IOFIELD = CURVAL('IO', TABLE_ALIAS)
   USE IN SELECT(TABLE_ALIAS)

   DO ODBC_CONNECT IN INTERFACE

   SQLCOLUMNS(ODBC_HANDLE, TABLENAME)
   SELECT field_type FROM SQLRESULT WHERE field_name = IOFIELD INTO CURSOR IO_CUR
   IO_TYPE = IO_CUR.field_type
   
   USE IN SELECT('IO_CUR')
   USE IN SELECT('SQLRESULT')

   SETUPFILE = 'INTERFACERETURNSETUP.DBF'
   IF ! FILE(SETUPFILE)
      =MESSAGEBOX('Interface setup file not found', 64, 'File Not Found')
      RETURN
   ENDIF
  
   TABLE_ALIAS = 'SETUPTBL' 
   USE(SETUPFILE) IN 0 ALIAS(TABLE_ALIAS) SHARED
   SELECT(TABLE_ALIAS)
   
   CURSORSETPROP("buffering",2,TABLE_ALIAS)
   IF CURVAL('TYPE', TABLE_ALIAS) != 1
      =MESSAGEBOX('Invalid interface setup return file', 64, 'Invalid File')
      RETURN
   ENDIF
   
   CUSTOM_ODBC_RETSTATEMENT = BUILD_RETSTATEMENT(TABLE_ALIAS)
ENDPROC

FUNC ADD_ODBC_FIELD(TABLE_ALIAS, FIELD_NAME, SETUPASNAME, FIRSTFIELD)
   IF EMPTY(FIELD(FIELD_NAME, TABLE_ALIAS))
      RETURN ""
   ENDIF
   VALUE = CURVAL(FIELD_NAME, TABLE_ALIAS)
   IF EMPTY(ALLTRIM(VALUE))
      RETURN ""
   ENDIF
   ADDSTR = " " + VALUE + " AS " + SETUPASNAME
   IF FIRSTFIELD < 1
      ADDSTR = "," + ADDSTR
   ENDIF
   RETURN ADDSTR
ENDFUNC

FUNC ADD_UPDATEODBC_FIELD(TABLE_ALIAS, FIELD_NAME, FIRSTFIELD)
   IF EMPTY(FIELD(FIELD_NAME, TABLE_ALIAS))
      RETURN ""
   ELSE
   VALUE = CURVAL(FIELD_NAME, TABLE_ALIAS)
   IF EMPTY(ALLTRIM(VALUE))
      RETURN ""
   ENDIF
   ADDSTR = VALUE + "=%" + FIELD_NAME + "%"
   IF FIRSTFIELD < 1
      ADDSTR = "," + ADDSTR
   ENDIF
   RETURN ADDSTR
ENDFUNC

FUNC ADD_RETODBC_FIELD(TABLE_ALIAS, FIELD_NAME, FIRSTFIELD)
   IF EMPTY(FIELD(FIELD_NAME, TABLE_ALIAS))
      RETURN ""
   ELSE
   VALUE = CURVAL(FIELD_NAME, TABLE_ALIAS)
   IF EMPTY(ALLTRIM(VALUE))
      RETURN ""
   ENDIF
   ADDSTR = " " + VALUE
   IF FIRSTFIELD < 1
      ADDSTR = "," + ADDSTR
   ENDIF
   RETURN ADDSTR
ENDFUNC

FUNC ADD_RETBLANK(TABLE_ALIAS, FIELD_NAME, FIRSTFIELD)
   IF EMPTY(FIELD(FIELD_NAME, TABLE_ALIAS))
      RETURN ""
   ELSE
   VALUE = CURVAL(FIELD_NAME, TABLE_ALIAS)
   IF EMPTY(ALLTRIM(VALUE))
      RETURN ""
   ENDIF
   ADDSTR = " %" + VALUE + "%"
   IF FIRSTFIELD < 1
      ADDSTR = "," + ADDSTR
   ENDIF
   RETURN ADDSTR
ENDFUNC

PROCEDURE SHIPSCREEN_RELEASE
   *=MESSAGEBOX('SHIP SCREEN RELEASE PROCEDURE')
   
   DO ODBC_DISCONNECT IN INTERFACE
   
   *** ODBC VARIABLES ***
   RELEASE ODBC_CONNECT,ODBC_HANDLE,ODBC_RETCODE
   RELEASE ODBC_DATASOURCE,ODBC_LOGIN,ODBC_PASSWORD
   *** ODBC VARIABLES ***
ENDPROC

PROCEDURE FUNCTION_SHIFT_F12
   *** FUNCTION KEY CAPABLITY FROM SHIP SCREEN
ENDPROC
PROCEDURE FUNCTION_CTRL_F12
   *** FUNCTION KEY CAPABILITY FROM SHIP SCREEN
ENDPROC

*** TOOL BAR
PROCEDURE TOOLBAR_INTERFACE_CLICK
   IF ODBC_CONNECT = .T.
      DO ODBC_CONNECT IN INTERFACE
   ELSE
      DO ODBC_DISCONNECT IN INTERFACE
   ENDIF
ENDPROC
PROCEDURE TOOLBAR_REPRINT_CLICK
ENDPROC
PROCEDURE TOOLBAR_VOID_CLICK
ENDPROC
PROCEDURE TOOLBAR_CLEAR_CLICK
ENDPROC
PROCEDURE TOOLBAR_PROCESS_CLICK
ENDPROC
PROCEDURE TOOLBAR_EXIT_CLICK
ENDPROC

*** REPRINT SCREEN
PROCEDURE REPRINTSCREEN_REPRINT_CLICK
ENDPROC
PROCEDURE REPRINTSCREEN_EXIT_CLICK
ENDPROC

*** VOID SCREEN
PROCEDURE VOIDSCREEN_VOID_CLICK
ENDPROC
PROCEDURE VOIDSCREEN_EXIT_CLICK
ENDPROC

*** OBDC CONNECTION
PROCEDURE ODBC_CONNECT
   *** BAIL IF ALREADY CONNECTED
   IF ODBC_CONNECT = .T.
      STORE .T. TO ODBC_CONNECT
      RETURN
   ENDIF
   
   WAIT WINDOW 'Trying to Connect to ODBC DataSource '+ALLTRIM(ODBC_DATASOURCE)+' - PLEASE WAIT' NOWAIT NOCLEAR
   
   *** TRY TO CONNECT TO DATASOURCE
   DO CASE
      CASE EMPTY(ODBC_LOGIN)
         ODBC_HANDLE = SQLCONNECT(ODBC_DATASOURCE)
      CASE EMPTY(ODBC_PASSWORD)
         ODBC_HANDLE = SQLCONNECT(ODBC_DATASOURCE, ODBC_LOGIN)
      OTHERWISE
         ODBC_HANDLE = SQLCONNECT(ODBC_DATASOURCE, ODBC_LOGIN, ODBC_PASSWORD)
   ENDCASE
   
   WAIT CLEAR
   
   DO CASE
      CASE ODBC_HANDLE > 0
           STORE .T. TO ODBC_CONNECT
           WAIT WINDOW 'Connection to ODBC DataSource '+ALLTRIM(ODBC_DATASOURCE)+' - SUCCESSFUL!' TIMEOUT 1
      CASE ODBC_HANDLE = -1
           STORE .F. TO ODBC_CONNECT
           =MESSAGEBOX('Connection Level Error.',64,'ODBC Connection Status')
      CASE ODBC_HANDLE = -2
           STORE .F. TO ODBC_CONNECT
           =MESSAGEBOX('Environment Level Error.',64,'ODBC Connection Status')
   ENDCASE        
   
ENDPROC

*** ODBC DISCONNECTION
PROCEDURE ODBC_DISCONNECT
   *** BAIL IF ALREADY DISCONNECTED
   IF ODBC_CONNECT = .F.
      RETURN
   ENDIF
   
   ODBC_RETCODE = SQLDISCONNECT(ODBC_HANDLE)
   
   *** SET ODBC FLAG
   STORE .F. TO ODBC_CONNECT
   
   *** CHECK FOR ERRORS
   DO CASE
      CASE ODBC_RETCODE = 1
           WAIT WINDOW 'Disconnected from Datasource '+ALLTRIM(ODBC_DATASOURCE)+' - SUCCESSFUL!' TIMEOUT 1
      CASE ODBC_RETCODE = -1
           =Messagebox('Connection Level Error',16,'ODBC Connection Status')
      CASE ODBC_RETCODE = -2
           =Messagebox('Connection Level Error',16,'ODBC Connection Status')
   ENDCASE
   
ENDPROC

*** ODBC EXECUTE STATEMENT
PROCEDURE ODBC_EXECUTE (ODBC_STATEMENT)
   IF ODBC_CONNECT
      
      *=MESSAGEBOX(STATEMENT,64,'SQL STATEMENT')
      ODBC_RETCODE = SQLEXEC(ODBC_HANDLE,ODBC_STATEMENT)
      
      *** TELLS WHETER OR NOT SQL WAS COMPLETE
      IF ODBC_RETCODE < 1
         DO FORM ODBC_MESS  && DISPLAYS ODBC ERROR MESSAGE
      ENDIF
   ENDIF
ENDPROC

*** FIELDS
PROCEDURE IOPROMPT_GOTFOCUS  && ONLY RUNS WHEN THE INTERFACE
ENDPROC

FUNC GET_FIELD_VAL(TABLE_ALIAS, FIELD_NAME, DEFAULT_VALUE)
   IF ! EMPTY(FIELD(FIELD_NAME, TABLE_ALIAS))
      FIELDVAL = UPPER(ALLTRIM(CURVAL(FIELD_NAME, TABLE_ALIAS)))
   ELSE
      FIELDVAL = DEFAULT_VALUE
   ENDIF
   
   IF ISNULL(FIELDVAL)
      FIELDVAL = DEFAULT_VALUE
   ENDIF
   
   RETURN FIELDVAL
ENDFUNC

FUNC POPULATE_ARRAYS(TABLE_NAME)
   XIDVAR(1,2) = GET_FIELD_VAL(TABLE_NAME, 'PACKAGE_ID', XIDVAR(1,2)) && PACKAGE ID
   XIDVAR(1,3) = GET_FIELD_VAL(TABLE_NAME, 'INVOICE_NO', XIDVAR(1,3)) && INVOICE NUMBER
   XIDVAR(1,4) = GET_FIELD_VAL(TABLE_NAME, 'ORDER_NO', XIDVAR(1,4)) && ORDER NUMBER
   XIDVAR(1,5) = GET_FIELD_VAL(TABLE_NAME, 'PO_NO', XIDVAR(1,5)) && PO NUMBER
   XIDVAR(1,6) = GET_FIELD_VAL(TABLE_NAME, 'DEPT_NO', XIDVAR(1,6)) && DEPARTMENT NUMBER
   XIDVAR(1,7) = GET_FIELD_VAL(TABLE_NAME, 'REF1', XIDVAR(1,7)) && REFERENCE 1
   XIDVAR(1,8) = GET_FIELD_VAL(TABLE_NAME, 'REF2', XIDVAR(1,8)) && REFERENCE 2
   XIDVAR(1,9) = GET_FIELD_VAL(TABLE_NAME, 'REF3', XIDVAR(1,9)) && REFERENCE3
   
   XTRANSVAR(1,1) = GET_FIELD_VAL(TABLE_NAME, 'TRANSLATED_CARRIER_CODE', XTRANSVAR(1,1)) && TRANSLATED CARRIER CODE
   XTRANSVAR(1,2) = GET_FIELD_VAL(TABLE_NAME, 'TRANSLATED_COUNTRY_CODE', XTRANSVAR(1,2)) && TRANSLATED COUNTRY CODE
   
   XWGTVAR(1,2) = GET_FIELD_VAL(TABLE_NAME, 'SHIP_WEIGHT', XWGTVAR(1,2)) && SHIP WEIGHT
   
   XSHIPVAR(1,1) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_CUSTOMER_NO', XSHIPVAR(1,1)) && SHIP TO CUSTOMER NUMBER
   XSHIPVAR(1,2) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_COMPANY', XSHIPVAR(1,2)) && SHIP TO COMPANY NAME
   XSHIPVAR(1,3) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_ATTN', XSHIPVAR(1,3)) && SHIP TO ATTENTION
   XSHIPVAR(1,4) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_ADDR1', XSHIPVAR(1,4)) && SHIP TO ADDRESS 1
   XSHIPVAR(1,5) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_ADDR2', XSHIPVAR(1,5)) && SHIP TO ADDRESS 2
   XSHIPVAR(1,6) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_ADDR3', XSHIPVAR(1,6)) && SHIP TO ADDRESS 3
   XSHIPVAR(1,7) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_CITY', XSHIPVAR(1,7)) && SHIP TO CITY
   XSHIPVAR(1,8) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_STATE', XSHIPVAR(1,8)) && SHIP TO STATE
   XSHIPVAR(1,9) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_ZIP', XSHIPVAR(1,9)) && SHIP TO ZIPCODE
   XSHIPVAR(1,10) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_COUNTRY', XSHIPVAR(1,10)) && SHIP TO COUNTRY
   XSHIPVAR(1,11) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_COUNTRY_CODE', XSHIPVAR(1,11)) && SHIP TO COUNTRY CODE
   XSHIPVAR(1,12) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_PNONE_NO', XSHIPVAR(1,12)) && SHIP TO PNONE NUMBER
   XSHIPVAR(1,13) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_FAX_NO', XSHIPVAR(1,13)) && SHIP TO FAX NUMBER
   XSHIPVAR(1,14) = GET_FIELD_VAL(TABLE_NAME, 'SHIPTO_EMAIL', XSHIPVAR(1,14)) && SHIP TO EMAIL ADDRESS
   
   XBILLVAR(1,1) = GET_FIELD_VAL(TABLE_NAME, 'BILLING_METHOD', XBILLVAR(1,1)) && BILLING METHOD   -   PREPAID / THIRD PARTY / COLLECT
   
   XBILLVAR(1,2) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_CARRIER ACCT_NO', XBILLVAR(1,2)) && BILL TO CARRIER ACCOUNT NUMBER
   XBILLVAR(1,3) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_COMPANY', XBILLVAR(1,3)) && BILL TO COMPANY NAME
   XBILLVAR(1,4) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_ATTN', XBILLVAR(1,4)) && BILL TO ATTENTION
   XBILLVAR(1,5) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_ADDR1', XBILLVAR(1,5)) && BILL TO ADDRESS 1
   XBILLVAR(1,6) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_ADDR2', XBILLVAR(1,6)) && BILL TO ADDRESS 2
   XBILLVAR(1,7) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_ADDR', XBILLVAR(1,7)) && BILL TO ADDRESS 3
   XBILLVAR(1,8) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_CITY', XBILLVAR(1,8)) && BILL TO CITY
   XBILLVAR(1,9) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_STATE', XBILLVAR(1,9)) && BILL TO STATE
   XBILLVAR(1,10) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_ZIP', XBILLVAR(1,10)) && BILL TO ZIPCODE
   XBILLVAR(1,11) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_COUNTRY', XBILLVAR(1,11)) && BILL TO COUNTRY
   XBILLVAR(1,12) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_COUNTRY_CODE', XBILLVAR(1,12)) && BILL TO COUNTRY CODE
   XBILLVAR(1,13) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_PHONE_NO', XBILLVAR(1,13)) && BILL TO PHONE NUMBER
   XBILLVAR(1,14) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_FAX_NO', XBILLVAR(1,14)) &&  BILL TO FAX NUMBER
   XBILLVAR(1,15) = GET_FIELD_VAL(TABLE_NAME, 'BILLTO_NO', XBILLVAR(1,15)) && BILL TO NUMBER
   
   XRETVAR(1,1) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_NAME', XRETVAR(1,1)) && RETURN LABEL NAME     
   XRETVAR(1,2) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_ATTN', XRETVAR(1,2)) && RETURN LABEL ATTENTION
   XRETVAR(1,3) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_ADDR1', XRETVAR(1,3)) && RETURN LABEL ADDRESS 1
   XRETVAR(1,4) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_CITY', XRETVAR(1,4)) && RETURN LABEL CITY
   XRETVAR(1,5) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_STATE', XRETVAR(1,5)) && RETURN LABEL STATE
   XRETVAR(1,6) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_ZIP', XRETVAR(1,6)) && RETURN LABEL ZIPCODE
   XRETVAR(1,7) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_COUNTRY', XRETVAR(1,7)) && RETURN LABEL COUNTRY
   XRETVAR(1,8) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_COUNTRY_CODE', XRETVAR(1,8)) && RETURN LABEL COUNTRY CODE
   XRETVAR(1,9) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_PHONE_NO', XRETVAR(1,9)) && RETURN LABEL PHONE NUMBER
   XRETVAR(1,10) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_FAX_NO', XRETVAR(1,10)) && RETURN LABEL FAX NUMBER
   XRETVAR(1,11) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_ADDR_2', XRETVAR(1,11)) && RETURN LABEL ADDRESS 2
   XRETVAR(1,12) = GET_FIELD_VAL(TABLE_NAME, 'RETURNLABEL_ADDR_3', XRETVAR(1,12)) && RETURN LABEL ADDRESS 3
   
   *XSPECVAR(1,15) = GET_FIELD_VAL(TABLE_NAME, 'RESIDENTIAL', XSPECVAR(1,15)) && RESIDENTIAL - .T. = RESIDENTIAL / .F. = COMMERCIAL
   *XSPECVAR(1,8) = GET_FIELD_VAL(TABLE_NAME, 'SAT_DELIVERY', XSPECVAR(1,8)) && SATURDAY DELIVERY - .T. = SATURDAY DELIVERY / .F. = NO SATURDAY DELIVERY
   *XSPECVAR(1,9) = GET_FIELD_VAL(TABLE_NAME, 'SAT_PICKUP', XSPECVAR(1,9)) && SATURDAY PICKUP - .T. = SATURDAY PICKUP / .F. = NO SATURDAY PICKUP
   
   XSPECCHG(1,2) = GET_FIELD_VAL(TABLE_NAME, 'COD_AMOUNT', XSPECCHG(1,2)) && COD AMOUNT
   IF XSPECCHG(1,2) > 0
      XSPECVAR(1,3) = .T. && C.O.D - .T. = COD / .F. = NO COD
   ENDIF
   
   XSPECCHG(1,4) = GET_FIELD_VAL(TABLE_NAME, 'INSURANCE_AMOUNT', XSPECCHG(1,4)) && INSURANCE AMOUNT
   IF XSPECCHG(1,4) > 0
      XSPECVAR(1,6) = .T. && INSURANCE - .T. = INSURANCE / .F. = NO INSURANCE
   ENDIF
   
   XSPECCHG(1,7) = GET_FIELD_VAL(TABLE_NAME, 'DIMENSIONAL_LENGTH', XSPECCHG(1,7)) && DIMENSIONAL LENGTH
   XSPECCHG(1,8) = GET_FIELD_VAL(TABLE_NAME, 'DIMENSIONAL_WIDTH', XSPECCHG(1,8)) && DIMENSIONAL WIDTH
   XSPECCHG(1,9) = GET_FIELD_VAL(TABLE_NAME, 'DIMESIONAL_HEIGHT', XSPECCHG(1,9)) && DIMESIONAL HEIGHT
   
   IF XSPECCHG(1,7) >= 1 AND XSPECCHG(1,8) >= 1 AND XSPECCHG(1,9) >= 1
      XSPECVAR(1,13) = .T. && DIMENSIONAL - .T. = DIMENSIONAL / .F. = IS NOT DIMENSIONAL
   ENDIF

   XMISCVAR(1,1) = GET_FIELD_VAL(TABLE_NAME, 'MISC1', XMISCVAR(1,1)) && MISC1 - STORE ANY THING
   XMISCVAR(1,2) = GET_FIELD_VAL(TABLE_NAME, 'MISC2', XMISCVAR(1,2)) && MISC2 - STORE ANY THING
   XMISCVAR(1,3) = GET_FIELD_VAL(TABLE_NAME, 'MISC3', XMISCVAR(1,3)) && MISC3 - STORE ANY THING
   XMISCVAR(1,4) = GET_FIELD_VAL(TABLE_NAME, 'MISC4', XMISCVAR(1,4)) && MISC4 - STORE ANY THING
   
   XEDCVAR(1,17) = GET_FIELD_VAL(TABLE_NAME, 'RUBBER_STAMP1', XEDCVAR(1,17)) && RUBBER STAMP 1 FIELD (ENDICIA LABEL ONLY)
   XEDCVAR(1,18) = GET_FIELD_VAL(TABLE_NAME, 'RUBBER_STAMP2', XEDCVAR(1,18)) && RUBBER STAMP 2 FIELD (ENDICIA LABEL ONLY)
   XEDCVAR(1,19) = GET_FIELD_VAL(TABLE_NAME, 'RUBBER_STAMP3', XEDCVAR(1,19)) && RUBBER STAMP 3 FIELD (ENDICIA LABEL ONLY)
ENDFUNC

PROCEDURE IOPROMPT_LOSTFOCUS  && ONLY RUNS WHEN THE INTERFACE
   *** POPULATE (STOP_SHIP WITH .T.) TO STOP PROCESSING
   
   IF ODBC_CONNECT == .F.  && MAKE SURE CONNECT TO ODBC DATASOURCE
      RETURN
   ENDIF
   
   IF ALLTRIM(IO_TYPE) == 'C' 
      ODBC_STATEMENT = CUSTOM_ODBC_STATEMENT + "'"+ALLTRIM(XIDVAR(1,1))+"'"
   ELSE
      ODBC_STATEMENT = CUSTOM_ODBC_STATEMENT + ALLTRIM(XIDVAR(1,1))
   ENDIF
   
   *=MESSAGEBOX(ODBC_STATEMENT)
   
   TABLE_NAME = 'SQLRESULT' 
   DO ODBC_EXECUTE IN INTERFACE WITH ODBC_STATEMENT
   
   IF RECCOUNT() == 0
      =MESSAGEBOX('Interace # '+ALLTRIM(XIDVAR(1,1))+' is not found! Check Interace # and Reprocess Package',16,'ODBC Information...')
      STOP_SHIP = .T.
   ENDIF
   
   IF STOP_SHIP = .F.
      POPULATE_ARRAYS(TABLE_NAME)
   ENDIF
   
   IF STOP_SHIP = .F.
      *** FIGURE OUT HOW TO MAKE SURE THE ODBC ADDRESS FIELDS ARE IN THE CORRECT SCREEN FIELDS
      
      *** FIRST LOOK AND SEE IF THE COMPANY FIELD IS BLANK
      IF ISBLANK(ALLTRIM(XSHIPVAR(1,2)))  && SHIP TO COMPANY NAME
         *** LETS JUST MOVE FIELDS UP
         IF ! ISBLANK(ALLTRIM(XSHIPVAR(1,3)))  && SHIP TO ATTENTION
            XSHIPVAR(1,2) = ALLTRIM(XSHIPVAR(1,3))
         ENDIF
         IF ! ISBLANK(ALLTRIM(XSHIPVAR(1,4)))  && SHIP TO ADDRESS 1
            XSHIPVAR(1,3) = ALLTRIM(XSHIPVAR(1,4))
         ENDIF
         IF ! ISBLANK(ALLTRIM(XSHIPVAR(1,5)))  && SHIP TO ADDRESS 2
            XSHIPVAR(1,4) = ALLTRIM(XSHIPVAR(1,5))
            XSHIPVAR(1,5) = SPACE(1)
         ENDIF
         IF ! ISBLANK(ALLTRIM(XSHIPVAR(1,6)))  && SHIP TO ADDRESS 3
            XSHIPVAR(1,5) = ALLTRIM(XSHIPVAR(1,6))
            XSHIPVAR(1,6) = SPACE(1)
         ENDIF
      ENDIF
   ENDIF
   
   USE IN SELECT(TABLE_NAME)
ENDPROC

PROCEDURE PKGID_GOTFOCUS
ENDPROC
PROCEDURE PKGID_LOSTFOCUS
ENDPROC

*** START OF SHIP TO ADDRESS
PROCEDURE SHIPTOCUSTOMER_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOCUSTOMER_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOCOMPANYNAME_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOCOMPANYNAME_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOATTN_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOATTN_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOADDR1_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOADDR1_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOADDR2_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOADDR2_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOADDR3_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOADDR3_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOCITY_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOCITY_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOST_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOST_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOZIP_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOZIP_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOCOUNTRY_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOCOUNTRY_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOPHONE_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOPHONE_LOSTFOCUS
ENDPROC

PROCEDURE SHIPTOFAX_GOTFOCUS
ENDPROC
PROCEDURE SHIPTOFAX_LOSTFOCUS
ENDPROC
*** END OF SHIP TO ADDRESS PROCEDURES

*** START OF SHIP FROM ADDRESS
PROCEDURE SHIPFROMCUSTOMER_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMCUSTOMER_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMCOMPANYNAME_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMCOMPANYNAME_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMATTN_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMATTN_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMADDR1_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMADDR1_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMADDR2_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMADDR2_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMADDR3_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMADDR3_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMCITY_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMCITY_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMST_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMST_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMZIP_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMZIP_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMCOUNTRY_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMCOUNTRY_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMPHONE_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMPHONE_LOSTFOCUS
ENDPROC

PROCEDURE SHIPFROMFAX_GOTFOCUS
ENDPROC
PROCEDURE SHIPFROMFAX_LOSTFOCUS
ENDPROC
*** END OF SHIP FROM ADDRESS PROCEDURES

*** START OF SERVICE
PROCEDURE CARRIER_CLICK
ENDPROC
PROCEDURE CARRIER_GOTFOCUS
ENDPROC
PROCEDURE CARRIER_LOSTFOCUS
ENDPROC

PROCEDURE CARRIERSERVICE_CLICK
ENDPROC
PROCEDURE CARRIERSERVICE_GOTFOCUS
ENDPROC
PROCEDURE CARRIERSERVICE_LOSTFOCUS
ENDPROC

PROCEDURE PACKAGETYPE_CLICK
ENDPROC
PROCEDURE PACKAGETYPE_GOTFOCUS
ENDPROC
PROCEDURE PACKAGETYPE_LOSTFOCUS
ENDPROC

PROCEDURE BILLOPTION_CLICK
ENDPROC
PROCEDURE BILLOPTION_GOTFOCUS
ENDPROC
PROCEDURE BILLOPTION_LOSTFOCUS
ENDPROC

PROCEDURE THIRDPARTY_CMD_CLICK  && CLICK PROCEDURE TO THE THIRD PARTY COMMAND BUTTON
ENDPROC

*** THIRD PARTY BILLING ADDRESS SCREEN
PROCEDURE THIRDPARTY_INIT
ENDPROC
PROCEDURE THIRDPARTY_RELEASE
ENDPROC
PROCEDURE THIRDPARTY_OK_CLICK
ENDPROC
PROCEDURE THIRDPARTY_CANCEL_CLICK
ENDPROC
*** END OF THIRD PARTY ADDRESS SCREEN

PROCEDURE SHIPWGT_GOTFOCUS
ENDPROC
PROCEDURE SHIPWGT_LOSTFOCUS
ENDPROC

PROCEDURE RATEPKG_GOTFOCUS  && RUNS AT THE TIME OF RATING THE PACKAGE
ENDPROC
PROCEDURE RATEPKG_LOSTFOCUS
ENDPROC

*** OPTIONS

*** DETAIL

*** REFERENCE
PROCEDURE REFERENCE1_GOTFOCUS
ENDPROC
PROCEDURE REFERENCE1_LOSTFOCUS
ENDPROC
PROCEDURE REFERENCE2_GOTFOCUS
ENDPROC
PROCEDURE REFERENCE2_LOSTFOCUS
ENDPROC
PROCEDURE REFERENCE3_GOTFOCUS
ENDPROC
PROCEDURE REFERENCE3_LOSTFOCUS
ENDPROC

*** INTERNATIONAL DOCUMENTS

*** SWOG TAB
PROCEDURE PROCESS_SWOG
   *** POPULATE (XSTOP_SWOG = .T.) TO STOP SWOG PROCESS
ENDPROC
PROCEDURE DELETE_SWOG
   *** POPULATE (XSTOP_SWOG = .T.) TO STOP SWOG PROCESS
ENDPROC

*** EXTRA PROCEDURES DURING PROCESSING
PROCEDURE BEFORE_PROCESS
   *** RETURN (PARCEL_SHIP_CONTINUE = .F.) IF YOU WANT TO STOP THE SHIPMENT FROM PROCESSING
   *** NEED TO CHECK FOR DUPLICATES
*!*      IF ! ISBLANK(ALLTRIM(ISCREEN_PASSWORD))
*!*         DO CASE
*!*            CASE ALLTRIM(XCARVAR(1,2)) == 'FEDEX'
*!*                 IF FILE('FDXDAILY.DBF')
*!*                    USE FDXDAILY.DBF IN 0 SHARED
*!*                    SELECT FDXDAILY
*!*                    
*!*                    IF INTERFACE_ON = .T.
*!*                       SET ORDER TO IONUM
*!*                       SEEK ALLTRIM(XIDVAR(1,1,))
*!*                    ELSE
*!*                       SET ORDER TO PKGID
*!*                       SEEK ALLTRIM(XIDVAR(1,2))
*!*                    ENDIF
*!*                    
*!*                    IF FOUND()
*!*                       *** DUPLICATE RECORD FOUND SO DISPLAY PASSWORD MESSAGEBOX TO CONTINUE
*!*                       PUBLIC I_SCREEN_NAME,I_PROCEED
*!*                       STORE 'DUPLICATE FILE NAME' TO I_SCREEN_NAME
*!*                       STORE .T. TO I_PROCEED
*!*                       
*!*                       DO ENTER_PASSWORD IN NTIS_PASSWORD
*!*                       
*!*                       IF I_PROCEED = .T.
*!*                          STORE .T. TO PARCEL_SHIP_CONTINUE
*!*                       ELSE
*!*                          STORE .F. TO PARCEL_SHIP_CONTINUE
*!*                       ENDIF
*!*                       
*!*                       RELEASE I_SCREEN_NAME,I_PROCEED
*!*                    ENDIF
*!*                    
*!*                    IF USED('FDXDAILY')
*!*                       SELECT FDXDAILY
*!*                       USE IN FDXDAILY
*!*                    ENDIF
*!*                 ENDIF
*!*            CASE ALLTRIM(XCARVAR(1,2)) == 'USPS'
*!*                 IF FILE('USPDAILY.DBF')
*!*                    USE USPDAILY.DBF IN 0 SHARED
*!*                    SELECT USPDAILY
*!*                    
*!*                    IF INTERFACE_ON = .T.
*!*                       SET ORDER TO IONUM
*!*                       SEEK ALLTRIM(XIDVAR(1,1,))
*!*                    ELSE
*!*                       SET ORDER TO PKGID
*!*                       SEEK ALLTRIM(XIDVAR(1,2))
*!*                    ENDIF
*!*                    
*!*                    IF FOUND()
*!*                       *** DUPLICATE RECORD FOUND SO DISPLAY PASSWORD MESSAGEBOX TO CONTINUE
*!*                       PUBLIC I_SCREEN_NAME,I_PROCEED
*!*                       STORE 'DUPLICATE FILE NAME' TO I_SCREEN_NAME
*!*                       STORE .T. TO I_PROCEED
*!*                       
*!*                       DO ENTER_PASSWORD IN NTIS_PASSWORD
*!*                       
*!*                       IF I_PROCEED = .T.
*!*                          STORE .T. TO PARCEL_SHIP_CONTINUE
*!*                       ELSE
*!*                          STORE .F. TO PARCEL_SHIP_CONTINUE
*!*                       ENDIF
*!*                       
*!*                       RELEASE I_SCREEN_NAME,I_PROCEED
*!*                    ENDIF
*!*                    
*!*                    IF USED('USPDAILY')
*!*                       SELECT USPDAILY
*!*                       USE IN USPDAILY
*!*                    ENDIF
*!*                 ENDIF
*!*            CASE ALLTRIM(XCARVAR(1,2)) == 'ENDICIA'
*!*                 IF FILE('EDCDAILY.DBF')
*!*                    USE EDCDAILY.DBF IN 0 SHARED
*!*                    SELECT EDCDAILY
*!*                    
*!*                    IF INTERFACE_ON = .T.
*!*                       SET ORDER TO IONUM
*!*                       SEEK ALLTRIM(XIDVAR(1,1,))
*!*                    ELSE
*!*                       SET ORDER TO PKGID
*!*                       SEEK ALLTRIM(XIDVAR(1,2))
*!*                    ENDIF
*!*                    
*!*                    IF FOUND()
*!*                       *** DUPLICATE RECORD FOUND SO DISPLAY PASSWORD MESSAGEBOX TO CONTINUE
*!*                       PUBLIC I_SCREEN_NAME,I_PROCEED
*!*                       STORE 'DUPLICATE FILE NAME' TO I_SCREEN_NAME
*!*                       STORE .T. TO I_PROCEED
*!*                       
*!*                       DO ENTER_PASSWORD IN NTIS_PASSWORD
*!*                       
*!*                       IF I_PROCEED = .T.
*!*                          STORE .T. TO PARCEL_SHIP_CONTINUE
*!*                       ELSE
*!*                          STORE .F. TO PARCEL_SHIP_CONTINUE
*!*                       ENDIF
*!*                       
*!*                       RELEASE I_SCREEN_NAME,I_PROCEED
*!*                    ENDIF
*!*                    
*!*                    IF USED('EDCDAILY')
*!*                       SELECT EDCDAILY
*!*                       USE IN EDCDAILY
*!*                    ENDIF
*!*                 ENDIF
*!*         ENDCASE
*!*      ENDIF
ENDPROC

PROCEDURE AFTER_PROCESS
ENDPROC

PROCEDURE BEFORE_PARCEL_DATAWRITE
   IF ODBC_CONNECT = .T.  && MAKE SURE CONNECT TO ODBC DATASOURCE
      IF INTERFACE_ON  && MEANS THE INTERFACE HAS TO BE ON IN ORDER TO CHECK SHIP CODES
          
         STATEMENT = STRTRAN(CUSTOM_ODBC_RETSTATEMENT, "%IO%", XIDVAR(1,1))
         STATEMENT = STRTRAN(STATEMENT, "%PACKID%", XIDVAR(1,2))
         STATEMENT = STRTRAN(STATEMENT, "%TRACKNUM%", XNUMVAR(1,5))
         STATEMENT = STRTRAN(STATEMENT, "%SERVCHRG%", XTOTCHGVAR(1,1))
         STATEMENT = STRTRAN(STATEMENT, "%DISFRTCHRG%", XTOTCHGVAR(1,3))
         STATEMENT = STRTRAN(STATEMENT, "%DISTOTCHRG%", XTOTCHGVAR(1,4))
         STATEMENT = STRTRAN(STATEMENT, "%PUBFRTCHRG%", XTOTCHGVAR(1,5))
         STATEMENT = STRTRAN(STATEMENT, "%PUBTOTCHRG%", XTOTCHGVAR(1,6))
         STATEMENT = STRTRAN(STATEMENT, "%BILLWGT%", XWGTVAR(1,1))
         STATEMENT = STRTRAN(STATEMENT, "%SHIPWGT%", XWGTVAR(1,2))
         DO ODBC_EXECUTE IN INTERFACE WITH STATEMENT
         
         USE IN SELECT('SQLRESULT')
      ENDIF
   ENDIF
ENDPROC
PROCEDURE AFTER_PARCEL_DATAWRITE
ENDPROC

PROCEDURE BEFORE_SWOG_DATAWRITE
ENDPROC
PROCEDURE AFTER_SWOG_DATAWRITE
ENDPROC

PROCEDURE BEFORE_LTL_DATAWRITE
ENDPROC
PROCEDURE AFTER_LTL_DATAWRITE
ENDPROC

PROCEDURE BEFORE_LABELPRINT
ENDPROC
PROCEDURE AFTER_LABELPRINT
ENDPROC

**********************************
*** END SHIP SCREEN PROCEDURES ***
**********************************

*****************************
*** START OF VOID PROCESS ***
*****************************

PROCEDURE BEFORE_VOID
   *** POPULATE (STOP_VOID) WITH .T. TO STOP EXECUTION
ENDPROC

PROCEDURE AFTER_VOID
   *** POPULATE (STOP_VOID WITH .T.) TO STOP VOID PROCESS
*!*      PRIVATE V_TRACKNUM,V_INTERFACE
*!*      STORE '' TO V_TRACKNUM
*!*      STORE .F. TO V_INTERFACE
*!*      
*!*      IF USED('FDXDAILY')
*!*         SELECT FDXDAILY
*!*         V_INTERFACE = FDXDAILY.INTERFACE
*!*         V_TRACKNUM = ALLTRIM(FDXDAILY.TRACKNUM)
*!*      ENDIF
*!*      IF USED('USPDAILY')
*!*         SELECT USPDAILY
*!*         V_INTERFACE = USPDAILY.INTERFACE
*!*         V_TRACKNUM = ALLTRIM(USPDAILY.TRACKNUM)
*!*      ENDIF
*!*      IF USED('EDCDAILY')
*!*         SELECT EDCDAILY
*!*         V_INTERFACE = EDCDAILY.INTERFACE
*!*         V_TRACKNUM = ALLTRIM(EDCDAILY.TRACKNUM)
*!*      ENDIF
*!*      
*!*      IF V_INTERFACE = .T.
*!*         PRIVATE ST1
*!*         STORE '' TO ST1
*!*         
*!*         ODBC_STATEMENT = "UPDATE SNO_Shipping SET VoidInd = 1 WHERE TrackingNumber = '"+ALLTRIM(V_TRACKNUM)+"'"
*!*         
*!*         DO ODBC_EXECUTE IN INTERFACE WITH ODBC_STATEMENT
*!*         
*!*         IF USED('SQLRESULT')
*!*            SELECT SQLRESULT
*!*            USE IN SQLRESULT
*!*         ENDIF
*!*         
*!*         RELEASE STRING_DATE,ST1
*!*      ENDIF
*!*      
*!*      RELEASE V_TRACKNUM,V_INTERFACE
ENDPROC

***************************
*** END OF VOID PROCESS ***
***************************

******************************
*** START CLOSE PROCEDURES ***
******************************

PROCEDURE BEFORE_DHL_CLOSE
ENDPROC
PROCEDURE AFTER_DHL_CLOSE
ENDPROC

PROCEDURE BEFORE_FEDEX_CLOSE
ENDPROC
PROCEDURE AFTER_FEDEX_CLOSE
ENDPROC

PROCEDURE BEFORE_UPS_CLOSE
ENDPROC
PROCEDURE AFTER_UPS_CLOSE
ENDPROC

PROCEDURE BEFORE_USPS_CLOSE
ENDPROC
PROCEDURE AFTER_USPS_CLOSE
ENDPROC

PROCEDURE BEFORE_ENDICIA_CLOSE
ENDPROC
PROCEDURE AFTER_ENDICIA_CLOSE
ENDPROC

PROCEDURE BEFORE_SPEEDEE_CLOSE
ENDPROC
PROCEDURE AFTER_SPEEDEE_CLOSE
ENDPROC

PROCEDURE BEFORE_CITYDELV_CLOSE
ENDPROC
PROCEDURE AFTER_CITYDELV_CLOSE
ENDPROC

PROCEDURE BEFORE_CDL_CLOSE
ENDPROC
PROCEDURE AFTER_CDL_CLOSE
ENDPROC

PROCEDURE BEFORE_SILVER_CLOSE
ENDPROC
PROCEDURE AFTER_SILVER_CLOSE
ENDPROC

PROCEDURE BEFORE_CALOVER_CLOSE
ENDPROC
PROCEDURE AFTER_CALOVER_CLOSE
ENDPROC

PROCEDURE BEFORE_GENERIC_CLOSE
ENDPROC
PROCEDURE AFTER_GENERIC_CLOSE
ENDPROC

PROCEDURE BEFORE_NONRATED_CLOSE
ENDPROC
PROCEDURE AFTER_NONRATED_CLOSE
ENDPROC

PROCEDURE BEFORE_LOCAL_CLOSE
ENDPROC
PROCEDURE AFTER_LOCAL_CLOSE
ENDPROC

****************************
*** END CLOSE PROCEDURES ***
****************************
