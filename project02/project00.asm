TITLE Programming Assignment 2    (project02.asm)

; ==========================================================================================================
; Author: Shawn S Hillyer	Email: hillyers@oregonstate.edu
; CS271-400 / Project ID: Programming Assignment 2	Due Date: 01/14/2016
; ==========================================================================================================
; [Description]  
; Write a program to calculate Fibonacci numbers.
; 	A. Display the program title and programmer’s name. Then get the user’s name, and greet the user.
; 	B. Prompt the user to enter the number of Fibonacci terms to be displayed. 
;	   Advise the user to enter an integer in the range [1 .. 46].
; 	C. Get and validate the user input (n).
; 	D. Calculate and display all of the Fibonacci numbers up to and including the nth term. 
; 	E. The results should be displayed 5 terms per line with at least 5 spaces between terms.
; 	F. Display a parting message that includes the user’s name, and terminate the program.
; ==========================================================================================================
; [Requirements]
; 	1. The programmer’s name and the user’s name must appear in the output.
; 	2. The loop that implements data validation must be implemented as a post-test loop.
;	3. The loop that calculates the Fibonacci terms must be implemented using the MASM loop instruction.
; 	4. The main procedure must be modularized into at least the following sections 
;          (procedures are not required this time):
; 	   a. introduction	b. userInstructions	c. getUserData	d. displayFibs	e. farewell
;	5. Recursive solutions are not acceptable for this assignment. This one is about iteration.
;	6. The upper limit should be defined and used as a constant.
;	7. The usual requirements regarding documentation, readability, user-friendliness, etc., apply.
; ==========================================================================================================
; [Extra-credit options]
; [Not Implemented]	1.  Display the numbers in aligned columns.
; [Not Implemented]	2.  Do something incredible.


INCLUDE Irvine32.inc  

; *********************
; Constants           *
; *********************

MAX_FIB TEXTEQU <46>


; *********************
; .data: Variables    *
; *********************

.data

; Strings - Output
	intro		BYTE	"Fibonacci Numbers",0
	programmer	BYTE	"by Shawn S Hillyer",0
	name_prompt	BYTE	"What’s your name?",0
	greeting	BYTE	"Hello, ",0
	
	instructions1	BYTE	"Enter the number of Fibonacci terms to be displayed",0
	instructions2	BYTE	"Give the number as an integer in the range [1 .. MAX_FIB].",0
	fib_prompt	BYTE	"How many Fibonacci terms do you want?",0
	okay_msg	BYTE	"Thanks. Printing the sequence next...",0
	err_range	BYTE	"Out of range. Enter a number in [1 .. MAX_FIB]",0
	spaces		BYTE	5 DUP(" "),0

	goodbye1	BYTE	"It's pronounced fee-boh-NOT-shee!",0
	goodbye2	BYTE	"Goodbye, ",0

; Strings - Input
	user_name	BYTE 30 DUP(0)	; input buffer

; Fibonnaci variables
	fib_first	DWORD 1
	fib_second	DWORD 1
	this_term	DWORD ?
	nth_fib		DWORD ?



.code

; +--------------------+
; |       MAIN         |
; +--------------------+

main PROC

; *********************
; a. introduction     *
; *********************

; Print Program Title and Programmer's Name
	mov	edx, OFFSET intro
	call 	WriteString 
	call 	CrLf

	mov	edx, OFFSET programmer
	call 	WriteString 
	call 	CrLf


; Prompt for and Get the user's name as a string
	mov	edx, OFFSET name_prompt
	call 	WriteString 
	call 	CrLf

	mov	edx, OFFSET user_name
	mov	ecx, SIZOEF user_name
	call	ReadString
	
; Greet the user
	mov	edx, OFFSET greeting
	call 	WriteString 
	mov	edx, OFFSET user_name
	call 	WriteString 
	call 	CrLf


; *********************
; b. userInstructions *
; *********************

; Print description of what program will do
	mov	edx, OFFSET instructions1
	call 	WriteString 
	call 	CrLf

; Print instructions
	mov	edx, OFFSET instructions2
	call 	WriteString 
	call 	CrLf

; *********************
; c. getUserData      *
; *********************

START_USER_DATA:

; Get user input
	mov 	edx, OFFSET fib_prompt
	call	WriteString
	call	ReadInt
	mov	nth_fib, eax
	
; IF nth_fib < 1 || nth_fib > MAX_FIB print error message and prompt again
	mov 	eax, nth_fib
	
	cmp 	eax, 1
	jl 	OUT_OF_RANGE

	cmp 	eax, MAX_FIB 
	jg 	OUT_OF_RANGE

; ELSE print confirmation and jump over OUT_OF_RANGE to END_USER_DATA
	mov 	eax, OFFSET okay_msg
	call	WriteString

	jmp 	END_USER_DATA


OUT_OF_RANGE:

; Print error message and jump back up
	mov 	eax, OFFSET err_range
	call	WriteString
	jmp 	START_USER_DATA  	; loop through input and validation again


END_USER_DATA:



; *********************
; d. displayFibs      *
; *********************

; Set up various loop-related counters
	mov 	ecx, nth_fib		; for FIB_SEQUENCE loop
	mov 	current_term, 1		; the current term of the fib seq
	mov	fib_1, 1		; nth fibonnaci - 1 (1 prior to current term)
	mov 	fib_2, 1		; nth fibonnaci - 2 (2 prior to current term)
	mov	line_count, 0		; count of values printed on current line so far

FIB_SEQUENCE:	; repeats nth_fib times

; IF current_term > 2, jump over FIRST_TWO
	mov	eax, current_term
	cmp	eax, 2
	jg	END_FIRST_TWO

FIRST_TWO:
; Print 1 for the base cases (n = 1 and n = 2) 	
	mov	this_term, 1
	mov 	eax, this_term
	call	WriteDec

END_FIRST_TWO:
	
; this_term = fib_1 + fib_2
	mov 	eax, fib_1
	add	eax, fib_2
	mov	this_term, eax

; fib_2 = fib_1
	mov	eax, fib_1
	mov	fib_2, eax

; fib_1 = this_term
	mov	eax, this_term
	mov	fib_1, eax

; print this_term
	mov	eax, this_term		; explicit in case I add code later
	call	WriteDec

; increment manual counters
	inc	current_term
	inc	line_count

;  if line_count != 5, don't print a linebreak
	mov 	eax, line_count
	cmp 	eax, 5
	jne 	LINE_BREAK_END

LINE_BREAK:
	call 	CrLf
	mov,	line_count, 0

LINE_BREAK_END:


; Print 5 spaces
	mov 	edx, OFFSET spaces
	call	WriteString

	loop 	FIB_SEQUENCE



; *********************
; e. farewell         *
; *********************

; Add some space and say goodbye
	call 	CrLf
	call 	CrLf

	move 	edx, OFFSET goodbye1
	call 	WriteLine
	call 	CrLf
	
	move 	edx, OFFSET goodbye2
	call 	WriteLine
	call 	CrLf

	exit	; exit to operating system  

main ENDP

; +--------------------+
; |     END MAIN       |
; +--------------------+


END main
