// to run a 16x2 LCD with AVR microcontroller atmega328p using assembly language
// same pin configuration as in lcd.c file

.equ LCD_DATA_PORT = PORTB		; D0-D7 of LCD
.equ RS = PD0					; RS
.equ RW = PD1					;RW
.equ E = PD2					;E

START:
	ldi r16, 0xff	
	out DDRB, r16	;	setting pins to output D0-D7
	out DDRD, r16	;	RS,RW,E

	cbi PORTD, RS	;	RS
	cbi PORTD, RW	;	RW
	cbi PORTD, E  ;	E

	rcall INIT_LCD

	ldi r16, 'H'	; 'H'
	rcall WRITE_DATA
	ldi r16, 'E'	; 'E'
	rcall WRITE_DATA
	ldi r16, 'L'	; 'L'
	rcall WRITE_DATA
	ldi r16, 'L'	; 'L'
	rcall WRITE_DATA
	ldi r16, 'O'	; 'O'
	rcall WRITE_DATA

	rcall DELAY_1S

	rcall BACKSPACE
	rcall ENTER

	rcall DELAY_1S

	rcall ENTER
	rcall DELAY_1S

	rcall ENTER
	

	rjmp END

INIT_LCD:
	cbi PORTD, RS	;	RS
	cbi PORTD, RW	;	RW

	ldi r16, 0B00111000	;	Function Set -> 8 bit mode, 2 line mode, font size
	out LCD_DATA_PORT, r16
	rcall TGGL_E		; Toggle E to send command
	rcall DELAY			; Delay to process led		; this need to be changed to check busy flag and then proceed function

	ldi r16,  0x01		; clear screen
	out LCD_DATA_PORT, r16
	rcall TGGL_E
	rcall DELAY


	ldi r16, 0B00001110	; Display Setting -> Display On, Cursor On, Cursor Blink Off
	out LCD_DATA_PORT, r16
	rcall TGGL_E
	rcall DELAY

	ldi r16, 0B00000110	; Entry Mode Set -> Inc Cursor On, Display Shift Off 
	out LCD_DATA_PORT, r16
	rcall TGGL_E
	rcall DELAY
	ret

READ_ADD:	
	ldi r16,0x00		; pinMode -> PortB, Input
	out DDRB, r16

	cbi PORTD, RS
	sbi PORTD, RW

	sbi PORTD, E

	rcall DELAY_MS


	in r25, PINB
	cbi PORTD, E
	rcall DELAY_MS

	ldi r16,0xff		; pinMode -> PortB, OUTPUT
	out DDRB, r16
	sbi PORTD,PD5
	ret

MOVE_CURSOR_L:
	rcall READ_ADD
	cbi PORTD,RS		; RS On to write data
	cbi PORTD, RW		; RW off
	lsl r25
	sec
	ror r25
	dec r25
	out LCD_DATA_PORT,r25
	rcall TGGL_E
	rcall DELAY_BF
	ret
BACKSPACE:
	rcall MOVE_CURSOR_L
	ldi r16, 0x10 
	rcall WRITE_DATA
	rcall MOVE_CURSOR_L
	ret
ENTER:
	rcall READ_ADD
	andi r25,0x40
	breq DOWN_LINE
	rjmp UP_LINE
DOWN_LINE:
	ldi r16, 0xC0
	rjmp AFTER_LINE
UP_LINE:
	ldi r16,0x80
AFTER_LINE:
	cbi PORTD,RS		; RS On to write data
	cbi PORTD, RW		; RW off
	out LCD_DATA_PORT,r16
	rcall TGGL_E
	rcall DELAY_BF
	ret
WRITE_DATA:		; load data to r16
	sbi PORTD,RS		; RS On to write data
	cbi PORTD, RW		; RW off
	out LCD_DATA_PORT,r16
	rcall TGGL_E
	rcall DELAY_BF
	ret

TGGL_E:
	sbi PORTD, E
	cbi PORTD, E
	ret


DELAY_MS:
	ldi r17, 0x30			; wait to settle data
	INNER_MS:
		dec r17
		brne INNER_MS
		ret
; Delay till BUSY FLAG of LCD is on
DELAY_BF:
	ldi r16,0x00		; pinMode -> PortB, Input
	out DDRB, r16

CHECK_BF:
	cbi PORTD, RS
	sbi PORTD, RW

	sbi PORTD, E

	rcall DELAY_MS


	in r16, PINB

	cbi PORTD, E

	sbrc r16, PB7		; Check BF has been reset otherwise loop again
	rjmp CHECK_BF


	ldi r16,0xff		; Reset PortB to OUTPUT
	out DDRB, r16
	ret

; Small Delay 
DELAY:
   ldi r18, 0xff
MIDDLE:
   ldi r17, 0xff
INNER:
	nop
   dec r17
   brne INNER

   dec r18
   brne MIDDLE

ret

DELAY_1s:
    ldi r19, 0x20
OUTER_1S:
    ldi r18, 0xff
MIDDLE_1S:
    ldi r17, 0xff
INNER_1S:
	nop
    dec r17
    brne INNER_1S

    dec r18
    brne MIDDLE_1S

    dec r19
    brne OUTER_1S

    ret

	



END:					; HALT
	rjmp END