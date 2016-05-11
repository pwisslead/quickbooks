PROCEDURE ENTER_PASSWORD
   LOCAL opassword
   
   opassword = CREATEOBJECT("PASSWORDSCR")  && Pass the Program object itself
   opassword.Show()
ENDPROC

DEFINE CLASS PASSWORDSCR AS FORM
   icon = 'ams.ico'
   heIght = 170
   wiDth = 200
   caPtion = "Password"
   mdIform = .F.
   foNtsize = 8
   auTocenter = .T.
   boRderstyle = 2
   miNbutton = .F.
   maXbutton = .F.
   wiNdowtype = 1
   showtips = .t.
   
   ADD OBJECT lb_pass AS label WITH caPtion = "", toP = 10,  ;
       leFt = 10, viSible = .T., autosize =.F., fontname = 'times new roman', ;
       fontsize = 11, fontbold = .T., forecolor = rgb(0,0,128), ;
       width = 180, height = 60, wordwrap = .T., alignment = 2,backstyle = 0
      
   ADD OBJECT pass_word AS textbox
       pass_word.height = 25
       pass_word.width = 100
       pass_word.top = 90
       pass_word.left = 50
       pass_word.fontsize = 12
       pass_word.fontbold = .T.
       pass_word.passwordchar = '*'
       pass_word.format = 'K'
       pass_word.tabindex = 1
       pass_word.tabstop = .T.
   
   ADD OBJECT cmd_ok AS commandbutton
       cmd_ok.caPtion = "\<OK"
       cmd_ok.toolTipText = 'OK'
       cmd_ok.toP = 138
       cmd_ok.leFt = 60
       cmd_ok.heIght = 30
       cmd_ok.width = 80
       cmd_ok.fontsize = 12
       cmd_ok.fontbold = .t.
       cmd_ok.fontname = 'times new roman'
       cmd_ok.default = .T.
       cmd_ok.tabindex = 2
       cmd_ok.tabstop = .T.
   
   PROCEDURE LOAD
      PUBLIC TIME_TRY
      STORE 1 TO TIME_TRY
      =CAPSLOCK(.F.)
   ENDPROC
   
   PROCEDURE DESTROY
      RELEASE TIME_TRY,OPASSWORD
      =CAPSLOCK(.T.)
   ENDPROC
   
   PROCEDURE LB_PASS.INIT
      THIS.Caption = "Enter Password to Proceed with "+ALLTRIM(I_SCREEN_NAME)+""
   ENDPROC
   
   PROCEDURE PASS_WORD.GOTFOCUS
      THIS.BACKCOLOR = RGB(255,255,0)
   ENDPROC
   
   PROCEDURE CMD_OK.CLICK
      IF ALLTRIM(THISFORM.PASS_WORD.VALUE) == ALLTRIM(ISCREEN_PASSWORD)
         I_PROCEED = .T.
         RELEASE THISFORM
      ELSE
         IF TIME_TRY <= 2
            =MESSAGEBOX('Password To '+ALLTRIM(I_SCREEN_NAME)+' is Incorrect! Try Again!',16,'')
            TIME_TRY = TIME_TRY + 1
            THISFORM.PASS_WORD.SETFOCUS()
         ELSE
            =MESSAGEBOX('Password To '+ALLTRIM(I_SCREEN_NAME)+' is Incorrect! Must Exit!',16,'')
            I_PROCEED = .F.
            RELEASE THISFORM
         ENDIF
      ENDIF
   ENDPROC
   PROCEDURE QUERYUNLOAD
      IF THIS.RELEASETYPE = 1
         NODEFAULT
      ENDIF
   ENDPROC
ENDDEFINE