LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
ORG 00H 
LJMP MAIN
ORG 30H
MAIN:
MOV R4,#21
N1:
MOV TMOD,#11H
MOV TH1,#00H
MOV TL1,#00H
SETB TR1
Here1:JNB TF1,Repeat1
CLR TF1
CLR TR1
DJNZ R4,N1
LJMP N2
Repeat1:
CPL P0.7
MOV R2,#0EFH
MOV R3,#0A3H
LCALL DURATION
LJMP Here1

MOV R4,#21
N2:
MOV TMOD,#11H
MOV TH1,#00H
MOV TL1,#00H
SETB TR1
Here2:JNB TF1,Repeat2
CLR TF1
CLR TR1
DJNZ R4,N2
LJMP N3
Repeat2:
CPL P0.7
MOV R2,#0F1H
MOV R3,#6DH
LCALL DURATION
LJMP Here2

MOV R4,#21
N3:
MOV TMOD,#11H
MOV TH1,#00H
MOV TL1,#00H
SETB TR1
Here3:JNB TF1,Repeat3
CLR TF1
CLR TR1
DJNZ R4,N3
LJMP N4
Repeat3:
CPL P0.7
MOV R2,#0F3H
MOV R3,#0C1H
LCALL DURATION
LJMP Here3

MOV R4,#21
N4:
MOV TMOD,#11H
MOV TH1,#00H
MOV TL1,#00H
SETB TR1
Here4:JNB TF1,Repeat4
CLR TF1
CLR TR1
DJNZ R4,N4
LJMP N5
Repeat4:
CPL P0.7
MOV R2,#0F1H
MOV R3,#6DH
LCALL DURATION
LJMP Here4

MOV R4,#28
N5:
MOV TMOD,#11H
MOV TH1,#00H
MOV TL1,#00H
SETB TR1
Here5:JNB TF1,Repeat5
CLR TF1
CLR TR1
DJNZ R4,N5
CLR P0.7
LJMP N6
Repeat5:
CPL P0.7
MOV R2,#0F6H
MOV R3,#45H
LCALL DURATION
LJMP Here5

MOV R4,#14
N6:
MOV TMOD,#10H
MOV TH1,#00H
MOV TL1,#00H
SETB TR1
Here6:JNB TF1,Here6
CLR TF1
CLR TR1
DJNZ R4,N6


MOV R4,#28
N7:
MOV TMOD,#11H
MOV TH1,#00H
MOV TL1,#00H
SETB TR1
Here7:JNB TF1,Repeat7
CLR TF1
CLR TR1
DJNZ R4,N7
LJMP N8
Repeat7:
CPL P0.7
MOV R2,#0F6H
MOV R3,#45H
LCALL DURATION
LJMP Here7
MOV R4,#28
N8:
MOV TMOD,#11H
MOV TH1,#00H
MOV TL1,#00H
SETB TR1
Here8:JNB TF1,Repeat8
CLR TF1
CLR TR1
DJNZ R4,N8
Display_level_1:
acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay
	  mov a,#82h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

LJMP MAIN
Repeat8:
CPL P0.7
MOV R2,#0F5H
MOV R3,#17H
LCALL DURATION
LJMP Here8

DURATION:

MOV TH0,R2
MOV TL0,R3
SETB TR0
Here:JNB TF0,Here
CLR TR0
CLR TF0
RET

org 400h
start:
      mov P2,#00h
      mov P1,#00h
	  
      	  acall delay
	;clr p1.0
	  acall delay
	here10: sjmp here10				

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 600h
my_string1:
         DB   "ROLLING TIME", 00H







END