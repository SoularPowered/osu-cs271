TITLE Programming Assignment 1    (project01.asm)

; Author: Shawn S Hillyer	Email: hillyers@oregonstate.edu
; CS271-400 / Project ID: Programming Assignment 1                Date: 01/14/2016
; Description:
;	1. Display your name and program title on the output screen.
;	2. Display instructions for the user.
;	3. Prompt the user to enter two numbers.
;	4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;	5. Display a terminating message.
;
; Extra-credit options:
; [Implemented] 1. Repeat until the user chooses to quit. 
; [Implemented] 2. Validate the second number to be less than the first. 
; [NYI]		3. Calculate and display the quotient as a floating-point number, rounded to the nearest .001.

INCLUDE Irvine32.inc

.data

; Strings & characters for printing intro / instructions / exit message to output

	programTitle 	BYTE	"Programming Assignment 1, ",0
	myName		BYTE	"Created by Shawn Hillyer",0
	instruct_1	BYTE	"Please enter two integers. Program will calculate and display the sum, ",0
	instruct_2	BYTE	"difference, product, quotient, and remainder for you.",0
	exitMsg		BYTE	"Thank's for joining me... see you next time.",0
	promptVal_1	BYTE	"Enter the first value (must be > second value): ",0
	promptVal_2	BYTE	"Enter the second value (must be < first value): ",0
	ecIntro_1	BYTE	"**EC: Program repeats until user chooses to quit.",0
	ecIntro_2	BYTE	"**EC: Program Validates the second number to be less than the first.",0
	ecIntro_3	BYTE	"**EC: Calculate and display the quotient as a floating-point number, rounded to the nearest .001.",0
	repeatMsg	BYTE	"Enter Q to quit or C to continue.",0
	promptError	BYTE	"You must enter Q or C!",0
	valueError	BYTE	"The first value must be greater than the second value.",0
	
	quit		BYTE	'Q'	; Quit value
	continue	BYTE	'C'	; Continue value

	

; Strings and characters for printing results
	sumMsg		BYTE	"The sum is: ",0
	differenceMsg	BYTE	"The difference is: ",0
	productMsg	BYTE	"The product is: ",0
	quotientMsg	BYTE	"The integer quotient is: ",0
	remainderMsg	BYTE	"The remainder of division is: ",0



.data?

; Variables for holding the two user-input values and the results of calculations

	value_1		DWORD	?	; First value entered by user
	value_2		DWORD	?	; Second value entered by user
	sum		DWORD	?	; store the sum of value_1 + value_2
	difference	DWORD	?	; store the difference of value_1 - value_2
	product		DWORD	?	; store the product of value_1 * value_2
	quotient	DWORD	?	; store the integer quotient of value_1 / value_2
	remainder	DWORD	?	; store the remainder of value_1 / value_2
	loopResponse	BYTE	?	; store user response if they wish to quit or continue



.code
main PROC

; Change colors to white on black - default
	mov		eax,white (black * 16)	
	call	SetTextColor

; introduce program + programmer
	mov		edx, OFFSET programTitle
	call	WriteString
	mov		edx, OFFSET myName
	call	WriteString
	call	CrLf
	
	; Extra Credit 1 Implemented message
	mov		edx, OFFSET ecIntro_1
	call	WriteString
	call	CrLf
	
	; Extra Credit 2 Implemented message
	mov		edx, OFFSET ecIntro_2
	call	WriteString
	call	CrLf
	
	; Extra Credit 3 Implemented message
;	mov		edx, OFFSET ecIntro_3
;	call	WriteString
;	call	CrLf



MAINLOOP:

	call	CrLf
	call	CrLf

; get two values, value_1 and value_2, from the user

	; print instructions
		mov		edx, OFFSET instruct_1
		call	WriteString
		call	CrLf
		mov		edx, OFFSET instruct_2
		call	WriteString
		call	CrLf

	; print prompt for value_1
		mov		edx, OFFSET promptVal_1
		call	WriteString
		call	CrLf

	; get input value_1
		call	ReadDec
		mov		value_1, eax

	; print prompt for value_2
		mov		edx, OFFSET promptVal_2
		call	WriteString
		call	CrLf

	; get input value_2
		call	ReadDec
		mov 	value_2, eax
		

; **EC: 2. Validate the second number to be less than the first.
	; if value_2 > value_1, Jump to QUITPROMPT that controls main program loop
		mov 	eax, value_2
		cmp		eax, value_1
		jg		INVALID
	

; calculate the required values

	; Calculate the sum
		mov 	eax,value_1
		add 	eax,value_2
		mov 	sum,eax

	; Calculate the difference
		mov 	eax,value_1
		sub 	eax,value_2
		mov 	difference,eax

	; Calculate the product
		mov 	eax,value_1
		mul 	value_2
		mov 	product,eax

	; Calculate the integer quotient (eax is divsor, ebx is dividend)
		mov		eax, value_1	
		cdq	               	; zero-extends eax into edx
		mov 	ebx, value_2
		div 	ebx
		mov 	quotient, eax
		mov 	remainder, edx

; display the results

	; Print sum to screen with message
		mov		edx, OFFSET sumMsg
		call	WriteString
		mov		eax, sum
		call	WriteDec
		call	CrLf

	; Print difference to screen with message
		mov		edx, OFFSET differenceMsg
		call	WriteString
		mov		eax, difference
		call	WriteDec
		call	CrLf

	; Print product to screen with message
		mov		edx, OFFSET productMsg
		call	WriteString
		mov		eax, product
		call	WriteDec
		call	CrLf

	; Print quotient to screen with message
		mov		edx, OFFSET quotientMsg
		call	WriteString
		mov		eax, quotient
		call	WriteDec
		call	CrLf

	; Print remainder to screen with message
		mov		edx, OFFSET remainderMsg
		call	WriteString
		mov		eax, remainder
		call	WriteDec
		call	CrLf
		

; **EC: 1. Repeat until the user chooses to quit.

QUITPROMPT:
	; Prompt user if they wish to (Q)uit or (C)ontinue 
		mov		edx, OFFSET repeatMsg
		call	WriteString
		call 	CrLf
	
	; Get loopResponse, convert to uppercase by clearing bit 5 (Page 192 of Irvine)
		call 	ReadChar
		mov 	loopResponse, al
		and 	loopResponse, 11011111b	
	
	; Compare loopResponse to continue ('C') and jump to MAINLOOP label if matches (Page 197+ of Irvine)
		mov		al,loopResponse
		cmp		al,continue	; ZF=1,CF=0 if loopResponse==source with unsigned operands
		jz		MAINLOOP
	
	; Compare loopResponse to quit ('Q') and jump to GOODBYE label if matches (Page 197+ of Irvine)
		mov		al,loopResponse
		cmp		al,quit		
		jz		GOODBYE
		

	; Change colors to white on red - error
		mov		eax,white (red * 16)	
		call	SetTextColor

	; Print error message if Q or C is not entered and repeat prompt
		mov		edx, OFFSET promptError
		call	WriteString
		call 	CrLf

	; Change colors to white on black - default
		mov		eax,white (black * 16)	
		call	SetTextColor

	jmp		QUITPROMPT



INVALID:	; Jump here from MAINLOOP if value_2 > value_1

	; Change colors to white on red - error
		mov		eax,white (red * 16)	
		call	SetTextColor
	
	; Print error message that value_2 must be less than value_1, jump to reprompt
		mov		edx, OFFSET valueError
		call	WriteString
		call	CrLf

	; Change colors to white on black - default
		mov		eax,white (black * 16)	
		call	SetTextColor
		jmp		MAINLOOP



; say goodbye

GOODBYE:
	; print exitMsg
		mov		edx, OFFSET exitMsg
		call 	WriteString
		call 	CrLf
		
	; exit to operating system
		exit	

main ENDP

END main
