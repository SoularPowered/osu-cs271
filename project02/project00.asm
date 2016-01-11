TITLE Project     (project.asm)  

; Author: Shawn S Hillyer  
; CS271-400 / Project ID: Assignment2	Date: 01/00/2016  
; Description: 


INCLUDE Irvine32.inc  


; *********************
; Constants           *
; *********************

MAX_FIB TEXTEQU <46>


; *********************
; .data: Variables    *
; *********************

.data

; Strings (Read-only)
	intro		BYTE	"Fibonacci Numbers",0
	programmer	BYTE	"by Shawn S Hillyer",0
	name_prompt	BYTE	"What’s your name?",0
	greeting	BYTE	"Hello, ",0
	
	instructions1	BYTE	"Enter the number of Fibonacci terms to be displayed",0
	instructions2	BYTE	"Give the number as an integer in the range [1 .. MAX_FIB].",0
	fib_prompt	BYTE	"How many Fibonacci terms do you want?",0
	okay_msg	BYTE	"Thanks. Printing the sequence next...",0
	err_range	BYTE	"Out of range. Enter a number in [1 .. MAX_FIB]",0

	goodbye1	BYTE	"It's pronounced fee-boh-NOT-shee!",0
	goodbye2	BYTE	"Goodbye, ",0

; Strings (User input) and related vars
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

; Print instructions for user to enter integer in the range [1..MAX_FIB inclusive]

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
	
; if nth_fib < 1 || nth_fib > MAX_FIB print error message and prompt again
	mov 	eax, nth_fib
	
	cmp 	eax, 1
	jl 	OUT_OF_RANGE

	cmp eax, MAX_FIB 
	jg 	OUT_OF_RANGE

	; else print confirmation and jump over OUT_OF_RANGE to END_USER_DATA
	mov 	eax, OFFSET okay_msg
	call	WriteString

	jmp 	END_USER_DATA

OUT_OF_RANGE:

; Print error message
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

	;  if current_term > 2, jump over first_two
	mov	eax, current_term
	cmp	eax, 2
	jg	END_FIRST_TWO

FIRST_TWO: 	; handles the base cases (n = 1 and n = 2)
	mov	this_term, 1

	; print this_term
	mov 	eax, this_term
	call	WriteDec

END_FIRST_TWO:	; executes if current_term > 2
	
	;    this_term = fib_1 + fib_2
	mov 	eax, fib_1
	add	eax, fib_2
	mov	this_term, eax

	;    fib_2 = fib_1
	mov	eax, fib_1
	mov	fib_2, eax

	;    fib_1 = this_term
	mov	eax, this_term
	mov	fib_1, eax

	;    print this_term
	mov	eax, this_term	; explicit in case I add code later

	; increment manual counters
	inc	current_term
	inc	line_count

	;  if line_count != 5, don't print a linebreak
	mov 	eax, line_count
	cmp 	eax, 5
	jne 	LINE_BREAK_END

LINE_BREAK:
	call CrLf    (newline per assignment)
	line_count = 0  (reset line counter)

LINE_BREAK_END:
	loop FIB_SEQUENCE ;  ecx--  (this is automatic)
	


; *********************
; e. farewell         *
; *********************

; Add some space and say goodbye
	call CrLf
	call CrLf

	move edx, OFFSET goodbye1
	call WriteLine
	call CrLf
	
	move edx, OFFSET goodbye2
	call WriteLine
	call CrLf

	exit	; exit to operating system  

main ENDP

; +--------------------+
; |     END MAIN       |
; +--------------------+


END main
