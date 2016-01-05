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
	instruct_1		BYTE	"Please enter two integers. Program will calculate and display the sum, "
	instruct_2		BYTE	"difference, product, quotient, and remainder for you.",0
	exitMsg				BYTE	"Thank's for joining me... see you next time.",0
	promptVal1		BYTE	"Enter the first value (operand): ",0
	promptVal2		BYTE	"Enter the second value (operand): ",0

; Strings and characters for printing results
	sumMsg				BYTE	"The sum is: ",0
	differenceMsg	BYTE	"The difference is: ",0
	productMsg		BYTE	"The product is: ",0
	quotientMsg		BYTE	"The integer quotient is: ",0
	remainderMsg	BYTE	"The remainder of division is: ",0


.data?		; Uninitialized data in .data? makes program smaller

; Variables for holding the two user-input values and the results of calculations
	value1			DWORD	?	; First value entered by user
	value2			DWORD	?	; Second value entered by user
	sum					DWORD	?	; store the sum of value1 + value2
	difference	DWORD	?	; store the difference of value1 - value2
	product			DWORD	?	; store the product of value1 * value2
	quotient		DWORD	?	; store the integer quotient of value1 / value2
	remainder		DWORD	?	; store the remainder of value1 / value2


.code
main PROC


; introduce programmer
	; print programTitle and myName
		 mov edx, OFFSET programTitle
		 call WriteString
		 mov edx, OFFSET myName
		 call WriteString
		 call CrLf

; get the data
	; print instructions

	; print promptVal1
	; prompt user for value1

	; print promptVal2
	; prompt user for value2


; calculate the required values

	; Calculate the sum
		MOV 	eax,value1		; move value1 into EAX and add value2
		ADD 	eax,value2
		MOV 	sum,eax			; store the result in sum

	; Calculate the difference
		MOV 	eax,value1		; move value1 into EAX and subtract value2
		SUB 	eax,value2
		MOV 	difference,eax	; store the result in difference

	; Calculate the product
		MOV 	eax,value1		; move value1 into EAX and subtract value2
		; MUL eax,value2
		MOV 	product,eax	; store the result in difference

; display the results
	; print sumMsg and sum

	; print differenceMsg and difference

	; print productMsg and product

	; print quotientMsg and quotient

	; print remainderMsg and remainder

; say goodbye
	; print exitMsg


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
