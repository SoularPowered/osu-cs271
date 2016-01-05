TITLE Programming Assignment 1    (project01.asm)

; Author: Shawn S Hillyer	Email: hillyers@oregonstate.edu
; CS271-400 / Project ID: Programming Assignment 1                Date: 01/14/2016
; Description:
;	1. Display your name and program title on the output screen.
;	2. Display instructions for the user.
;	3. Prompt the user to enter two numbers.
;	4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;	5. Display a terminating message.
; Extra-credit options:
; 	1. Repeat until the user chooses to quit.
; 	2. Validate the second number to be less than the first.
; 	3. Calculate and display the quotient as a floating-point number, rounded to the nearest .001.

INCLUDE Irvine32.inc

.data

; Strings for printing intro / instructions / exit message to output

	programTitle 	BYTE	"Programming Assignment 1, ",0
	myName		BYTE	"Created by Shawn Hillyer",0
	instruct_1	BYTE	"Please enter two integers. Program will calculate and display the sum, ",0
	instruct_2	BYTE	"difference, product, quotient, and remainder for you.",0
	exitMsg		BYTE	"Thank's for joining me... see you next time.",0
	promptVal_1	BYTE	"Enter the first value (operand): ",0
	promptVal_2	BYTE	"Enter the second value (operand): ",0
	ecIntro_1	BYTE	"**EC: Program repeats until user chooses to quit.",0
	ecIntro_2	BYTE	"**EC: Program Validates the second number to be less than the first.",0
	ecIntro_3	BYTE	"**EC: Calculate and display the quotient as a floating-point number, rounded to the nearest .001.",0

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


.code
main PROC

; introduce program + programmer
	mov		edx, OFFSET programTitle
	call	WriteString
	mov		edx, OFFSET myName
	call	WriteString
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
		call	Readdec
		mov value_1, eax

	; print prompt for value_2
		mov		edx, OFFSET promptVal_2
		call	WriteString
		call	CrLf

	; get input value_2
		call	Readdec
		mov 	value_2, eax


; calculate the required values

	; Calculate the sum
		mov 	eax,value_1		; move value_1 into EAX and add value_2
		add 	eax,value_2
		mov 	sum,eax			; store the result in sum

	; Calculate the difference
		mov 	eax,value_1		; move value_1 into EAX and subtract value_2
		sub 	eax,value_2
		mov 	difference,eax	; store the result in difference

	; Calculate the product
		mov 	eax,value_1		; move value_1 into EAX and subtract value_2
		mul 	value_2
		mov 	product,eax	; store the result in product

	; Calculate the integer quotient
		mov 	eax, value_1		; Divisor goes in eax
		cdq	                	; "conver doubleword to quadword"
		mov 	ebx, value_2			; Dividend goes in ebx
		div 	ebx           	; Divide ebx by ebx
		mov 	quotient, eax		; quotient ends up in eax
		mov 	remainder, edx 	; Remainder ends up in edx

; display the results
	; print sumMsg and sum
		mov		edx, OFFSET sumMsg
		call	WriteString
		mov		eax, sum
		call	WriteDec
		call	CrLf

	; print differenceMsg and difference
		mov		edx, OFFSET differenceMsg
		call	WriteString
		mov		eax, difference
		call	WriteDec
		call	CrLf

	; print productMsg and product
		mov		edx, OFFSET productMsg
		call	WriteString
		mov		eax, product
		call	WriteDec
		call	CrLf

	; print quotientMsg and quotient
		mov		edx, OFFSET quotientMsg
		call	WriteString
		mov		eax, quotient
		call	WriteDec
		call	CrLf

	; print remainderMsg and remainder
		mov		edx, OFFSET remainderMsg
		call	WriteString
		mov		eax, remainder
		call	WriteDec
		call	CrLf

; say goodbye
	; print exitMsg
		mov		edx, OFFSET exitMsg
		call WriteString
		call 	CrLf

	exit	; exit to operating system
main ENDP

END main
