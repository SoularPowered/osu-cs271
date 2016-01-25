TITLE Programming Assignment 3    (project03.asm)

; ==========================================================================================================
; Author: Shawn S Hillyer								Email: hillyers@oregonstate.edu
; CS271-400 / Project ID: Programming Assignment 3		Due Date: 02/07/2016
; ==========================================================================================================
; [Description]  
; Write and test a MASM program to perform the following tasks:
;	1. Display the program title and programmer’s name.
;	2. Get the user’s name, and greet the user.
;	3. Display instructions for the user.
;	4. Repeatedly prompt the user to enter a number. 
;      Validate the user input to be in [-100, -1] (inclusive).
;	   Count and accumulate the valid user numbers until a non-negative number is entered. (The non-negative number is discarded.)
;	5. Calculate the (rounded integer) average of the negative numbers.
;	6. Display:
;		i. the number of negative numbers entered (Note: if no negative numbers were entered, display a special message and skip to iv.)
;		ii. the sum of negative numbers entered
;		iii. the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
;		iv. a parting message (with the user’s name)
; ==========================================================================================================
; [Requirements]
;	1. The main procedure must be modularized into commented logical sections (procedures are not required this time)
;	2. The program must be fully documented. This includes a complete header block for identification, description,
;	   etc., and a comment outline to explain each section of code.
;	3. The lower limit should be defined as a constant.
;	4. The usual requirements regarding documentation, readability, user-friendliness, etc., apply.
;	5. Submit your text code file (.asm) to Canvas by the due date.
; ==========================================================================================================
; [Important Note]
; This is an integer program. Even though it would make more sense to use floating-point computations, you are required to do this one with integers.
; [Extra-credit options]
; [Not Implemented]		1. Number the lines during user input.
; [Not Implemented]		2. Calculate and display the average as a floating-point number, rounded to the nearest .001.
; [Not Implemented]		3. Do something astoundingly creative.

INCLUDE Irvine32.inc

; *********************
; Constants           *
; *********************

LOWER_LIMIT = -100	;  smallest integer value user can enter


; *********************
; Variables           *
; *********************
.data

; Strings - Output
	intro			BYTE	"Welcome to the Integer Accumulator",0
	programmer		BYTE	"by Shawn S Hillyer",0
	ecIntro_1		BYTE	"**EC: Numbers the lines during user input..",0
	ecIntro_2		BYTE	"**EC: Calculate and display the average as a floating-point number, rounded to the nearest .001",0
	ecIntro_3		BYTE	"**EC: Does something astoundingly creative.",0
	namePrompt		BYTE	"What is your name?",0
	greeting		BYTE	"Hello, ",0
	
	instructions_1	BYTE	"I will sum negative integers in the valid range.",0
	instructions_2	BYTE	"Please enter numbers in [",0
	rangeEnd		BYTE	", -1].",0

	inputPrompt		BYTE	"Enter number: ",0


	goodbye1		BYTE	"Next time I'll try not to be so negative!",0
	goodbye2		BYTE	"Goodbye, ",0
	

; Strings - Input
	userName		BYTE	30 DUP(0)	; input buffer
	numberIn

.code

; +------------------------------------------------------------+
PrintIntroduction	PROC
; Pre:	None
; Post: Prints introduction to screen and gets user's name to
;		greet them with.
; +------------------------------------------------------------+
; Print Program Title and Programmer's Name
	mov		edx, OFFSET intro
	call 	WriteString 
	call 	CrLf

	mov		edx, OFFSET programmer
	call 	WriteString 
	call 	CrLf

; Extra Credit 1 Implemented message
;	mov		edx, OFFSET ecIntro_1
;	call	WriteString
;	call	CrLf
;	call	CrLf

; Extra Credit 2 Implemented message
;	mov		edx, OFFSET ecIntro_2
;	call	WriteString
;	call	CrLf
;	call	CrLf

; Extra Credit 3 Implemented message
;	mov		edx, OFFSET ecIntro_3
;	call	WriteString
;	call	CrLf
;	call	CrLf

; Prompt for and Get the user's name as a string
	mov		edx, OFFSET namePrompt
	call 	WriteString 
	call 	CrLf

	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString
	
; Greet the user
	mov		edx, OFFSET greeting
	call 	WriteString 
	mov		edx, OFFSET userName
	call 	WriteString 
	call 	CrLf
	call	CrLf
	
	ret
; +------------------------------------------------------------+
PrintIntroduction ENDP
; +------------------------------------------------------------+





; +------------------------------------------------------------+
PrintInstructions	PROC
; Pre:	None
; Post: Prints instructions for user on the screen
; +------------------------------------------------------------+
; Print description of what program will do
	mov		edx, OFFSET instructions_1
	call 	WriteString 
	call 	CrLf

; Print instructions
	mov		edx, OFFSET instructions_2
	call 	WriteString 
	mov		eax, LOWER_LIMIT;
	call	WriteInt
	mov		edx, OFFSET rangeEnd
	call 	WriteString 
	call 	CrLf
	call	CrLf

	ret
; +------------------------------------------------------------+
PrintInstructions ENDP
; +------------------------------------------------------------+


; +------------------------------------------------------------+
PrintFarewell	PROC
; Pre:	None
; Post: Prints a farewell message to user
; +------------------------------------------------------------+
; Add some space and say goodbye
	call 	CrLf
	call 	CrLf

	mov 	edx, OFFSET goodbye1
	call 	WriteString
	call 	CrLf
	
	mov 	edx, OFFSET goodbye2
	call 	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call 	CrLf
	call 	CrLf

	ret
; +------------------------------------------------------------+
PrintFarewell ENDP
; +------------------------------------------------------------+


main PROC

;	1. Display the program title and programmer’s name.
;	2. Get the user’s name, and greet the user.
	call	PrintIntroduction

;	3. Display instructions for the user.
	call	PrintInstructions
;	4. Repeatedly prompt the user to enter a number. 
;      Validate the user input to be in [-100, -1] (inclusive).
;	   Count and accumulate the valid user numbers until a non-negative number is entered. (The non-negative number is discarded.)
;	5. Calculate the (rounded integer) average of the negative numbers.
;	6. Display:
;		i. the number of negative numbers entered (Note: if no negative numbers were entered, display a special message and skip to iv.)
;		ii. the sum of negative numbers entered
;		iii. the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)


;		iv. a parting message (with the user’s name)
	call	PrintFarewell


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
