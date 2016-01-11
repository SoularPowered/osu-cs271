; *********************
; .data: Variables    *
; *********************

.data

fib_first	DWORD 1
fib_second	DWORD 1
fib_sum
fib_total

; *********************
; .code:  MAIN        *
; *********************

.code
main PROC

; *********************
; a. introduction     *
; *********************

; Print Program Title and Programmer's Name




; Get the user's name as a string




; Greet the user



; *********************
; b. userInstructions *
; *********************

; Print description of what program will do



; Print instructions for user to enter integer in the range [1..46 inclusive]



; *********************
; c. getUserData      *
; *********************


; Get user input
START_USER_DATA:   ; serves as a while loop




; if user input < 1 or > 46, loop back to get input (GET_USER_DATA:
	mov eax, nth_fib

; if nth_fib < 1, jump to TOO_LOW
	cmp eax, 1
	jl TOO_LOW

; or if input > 46, jmp to TOO_HIGH
	cmp eax, 1
	jg TOO_HIGH

; else print confirmation and jump to END_USER_DATA


	jmp END_USER_DATA

TOO_LOW:
; Print error message: input too low


	jmp START_USER_DATA  	; loop through input and validation again

TOO_HIGH:
; Print error message: input too high


	jmp START_USER_DATA  	; loop through input and validation again

END_USER_DATA:


; *********************
; d. displayFibs      *
; *********************

; if nth_fib == 1
	; print fib_first

; else if nth_fib == 2
	; print fib_first and fib_second

; else calculate and print each number

	; ecx = 46
	; current_term = 1
	; fib_1 = 1
	; fib_2 = 1
	; line_count = 0

FIB_SEQUENCE:	; while (ecx > 0) {

	;  if current_term < 3
		;  this_term = 1
		; print this_term

	;  else
		;    this_term = fib_1 + fib_2
		;    fib_2 = fib_1
		;    fib_1 = this_term
		;    print this_term

	;  current_term++
	;  line_count++
	;  if line_count == 5
		; CrLf    (newline per assignment)
		; line_count = 0  (reset line counter)

	;  then jump to FIB_SEQUENCE

	loop FIB_SEQUENCE ;  ecx--  (this is automatic, we call LOOP...)
	






; *********************
; e. farewell         *
; *********************



main ENDP
