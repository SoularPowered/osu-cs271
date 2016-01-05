TITLE Programming Assignment 1    (project01.asm)

; Author: Shawn S Hillyer	Email: hillyers@oregonstate.edu
; CS271-400 / Project ID: Programming Assignment 1                Date: 01/14/2016
; Description:
;	1. Display your name and program title on the output screen.
;	2. Display instructions for the user.
;	3. Prompt the user to enter two numbers.
;	4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;	5. Display a terminating message.

INCLUDE Irvine32.inc

; (insert constant definitions here)


.data

; Strings for printing intro / instructions / exit message to output

	programTitle  BYTE	"Programming Assignment 1, ",0
	myName        BYTE	"Created by Shawn Hillyer",0
	instruct_1		BYTE	"Please enter two integers. Program will calculate and display the sum, ",0
	instruct_2		BYTE	"difference, product, quotient, and remainder for you.",0
	exitMsg				BYTE	"Thank's for joining me... see you next time.",0
	promptVal_1		BYTE	"Enter the first value (operand): ",0
	promptVal_2		BYTE	"Enter the second value (operand): ",0

; Strings and characters for printing results
	sumMsg				BYTE	"The sum is: ",0
	differenceMsg	BYTE	"The difference is: ",0
	productMsg		BYTE	"The product is: ",0
	quotientMsg		BYTE	"The integer quotient is: ",0
	remainderMsg	BYTE	"The remainder of division is: ",0


.data?		; Uninitialized data in .data? makes program smaller

; Variables for holding the two user-input values and the results of calculations
	value_1			DWORD	?	; First value entered by user
	value_2			DWORD	?	; Second value entered by user
	sum					DWORD	?	; store the sum of value_1 + value_2
	difference	DWORD	?	; store the difference of value_1 - value_2
	product			DWORD	?	; store the product of value_1 * value_2
	quotient		DWORD	?	; store the integer quotient of value_1 / value_2
	remainder		DWORD	?	; store the remainder of value_1 / value_2


.code
main PROC


; introduce program + programmer
	mov		edx, OFFSET programTitle
	call	WriteString
	mov		edx, OFFSET myName
	call	WriteString
	call	CrLf

; get the data
	; print instructions
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf

	; print promptVal1
	mov		edx, OFFSET promptVal_1
	call	WriteString
	call	CrLf

	; get input value_1

	; print promptVal2
	mov		edx, OFFSET promptVal_2
	call	WriteString
	call	CrLf

	; get input value_2


; calculate the required values

	; Calculate the sum
		MOV 	eax,value_1		; move value_1 into EAX and add value_2
		ADD 	eax,value_2
		MOV 	sum,eax			; store the result in sum

	; Calculate the difference
		MOV 	eax,value_1		; move value_1 into EAX and subtract value_2
		SUB 	eax,value_2
		MOV 	difference,eax	; store the result in difference

	; Calculate the product
		MOV 	eax,value_1		; move value_1 into EAX and subtract value_2
		; MUL eax,value_2
		MOV 	product,eax	; store the result in difference

; display the results
	; print sumMsg and sum
	mov		edx, OFFSET sumMsg
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

	; print differenceMsg and difference
	mov		edx, OFFSET differenceMsg
	call	WriteString
	mov		eax, difference
	call	WriteInt
	call	CrLf

	; print productMsg and product
	mov		edx, OFFSET productMsg
	call	WriteString
	mov		eax, product
	call	WriteInt
	call	CrLf

	; print quotientMsg and quotient
	mov		edx, OFFSET quotientMsg
	call	WriteString
	mov		eax, quotient
	call	WriteInt
	call	CrLf

	; print remainderMsg and remainder
	mov		edx, OFFSET remainderMsg
	call	WriteString
	mov		eax, remainder
	call	WriteInt
	call	CrLf

; say goodbye
	; print exitMsg
	mov		edx, OFFSET exitMsg
	call WriteString
	call 	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
