TITLE Programming Assignment 4    (project04-hillyer.asm)

; ==========================================================================================================
; Author: Shawn S Hillyer								Email: hillyers@oregonstate.edu
; CS271-400 / Project ID: Programming Assignment 4		Due Date: 02/14/2016
; ==========================================================================================================
; ==========================================================================================================
; [Description]  
; Write a program to calculate composite numbers. First, the user is instructed to enter the number of
; composites to be displayed, and is prompted to enter an integer in the range [1 .. 400]. The user enters a
; number, n, and the program verifies that 1 <= n <= 400. If n is out of range, the user is re-prompted until
; s/he enters a value in the specified range. The program then calculates and displays all of the composite
; numbers up to and including the nth composite. The results should be displayed 10 composites per line with
; at least 3 spaces between the numbers.
;
; ==========================================================================================================
; [Requirements]
;	1. The programmer’s name must appear in the output.
;	2. The counting loop (1 to n) must be implemented using the MASM loop instruction.
;   3. The main procedure must consist (mostly) of procedure calls. It should be a readable “list” of what 
;      the program will do.
;   4. Each procedure will implement a section of the program logic, i.e., each procedure will specify how 
;      the logic of its section is implemented. The program must be modularized into at least the following
;      procedures and sub-procedures :
;		* introduction		x
;		* getUserData		x
;		* validate			x
;		* showComposites	x
;		* isComposite		x
;		* farewell			x
;   5. The upper limit should be defined and used as a constant.
;   6. Data validation is required. If the user enters a number outside the range [1 .. 400] an error 
;      message should be displayed and the user should be prompted to re-enter the number of composites.
;   7. The usual requirements regarding documentation, readability, user-friendliness, etc., apply.
; ==========================================================================================================
; [Important Notes]
;   1. For this program, you may use global variables instead of passing parameters. This is a one-time 
;      relaxation of the standards so that you can get accustomed to using procedures.
;   2. A number k is composite if it can be factored into a product of smaller integers. Every integer 
;      greater than one is either prime or composite. Note that this implies that
;        a. 1 is not composite.
;        b. The number must be positive.
;   3. There are several ways to make your isComposite procedure efficient. (I recommend discussing this 
;      in your groups!)
;
; [Extra-credit options]
; [Not Implemented]		1. Align the output columns.
; [Not Implemented]		2. Display more composites, but show them one page at a time. The user can “Press any key to continue …” to view the next page. Since length of the numbers will increase, it’s OK to display fewer numbers per line.
; [Not Implemented]		3. One way to make the program more efficient is to check against only prime divisors, which requires saving all of the primes found so far (numbers that fail the composite test). It’s easy in a high-level language, but you will have to look ahead in the textbook to figure out how to do it in assembly language.

INCLUDE Irvine32.inc

; *********************
; Constants           *
; *********************

UPPER_LIMIT = 400		; largest integer value user can enter
TAB = 9

; *********************
; Variables           *
; *********************
.data

; Strings - Output
	intro			BYTE	"Welcome to the Composite Numbers",0
	programmer		BYTE	"Programmed by Shawn S Hillyer",0
;	ecIntro_1		BYTE	"**EC: Aligns the output columns.",0
;	ecIntro_2		BYTE	"**EC: Displays more composites, but show them one page at a time.",0
;	ecIntro_3		BYTE	"**EC: Checks against only prime divisors.",0
	
	instructions_1	BYTE	"Enter the number of composite numbers you would like to see.",0
	instructions_2	BYTE	"I'll accept orders for up to ",0
	rangeEnd		BYTE	" composites.",0

	valuePrompt_1	BYTE	"Enter the number of composites to display [1 .. ",0
	valuePrompt_2	BYTE	"]: ",0
	outOfRangMsg	BYTE	"Out of range.",0
		
	goodbye1		BYTE	"Transforming back in to Optimus Prime... goodbye! Autobots, assemble(y)!",0
	goodbye2		BYTE	"Brought to you by ",0


; Numbers used in processing the data
	numberInput		DWORD	0			; the user's input number
	currentInteger	DWORD	1			; the current integer we are checking / printing
	valToCheck		DWORD	0			; a value we are checking if composite / prime
	primalityCtr	DWORD	0			; used in isComposite process

; Booleans. 0 == false, 1 == true
	isValid			BYTE	0			
	isComp			BYTE	0
.code


; +------------------------------------------------------------+
main PROC
; Description:	Control process. Calls introduction, instructions,
;   getUserData, showComposites, and Farewell per assignment desciption
; Receives:		None
; Returns:		None
; Pre:			UPPER_LIMIT should be at most 32bit positive int
; Reg Changed:	Potentially all - main entrypoint
; +------------------------------------------------------------+

; Display the program title and programmer’s name & Get the user’s name, and greet the user.
	call	introduction

; Display instructions for the user.
	call	instructions

; Prompt the user to enter a number in range [1 .. 400], subroutine validates input while not valid
	call	getUserData

; Print the composite numbers from [1 .. inputNumber]
	call showComposites

; Print FareWell message
	call	farewell

; exit to operating system
	exit	
main ENDP

; +------------------------------------------------------------+
introduction	PROC
; Description:	Prints introduction to screen and gets user's name to
;				greet them with.
;
; Receives:		
; Returns:		
; Pre:			None
; Reg Changed:	
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
	
; Extra Credit 2 Implemented message
;	mov		edx, OFFSET ecIntro_2
;	call	WriteString
;	call	CrLf

; Extra Credit 3 Implemented message
;	mov		edx, OFFSET ecIntro_3
;	call	WriteString
;	call	CrLf
	
	call 	CrLf
	ret
; +------------------------------------------------------------+
introduction ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
instructions	PROC
; Description:	
;
; Receives:		
; Returns:		
; Pre:			None
; Reg Changed:	
; +------------------------------------------------------------+

; Print description of what program will do
	mov		edx, OFFSET instructions_1
	call 	WriteString 
	call 	CrLf

; Print instructions
	mov		edx, OFFSET instructions_2
	call 	WriteString 
	mov		eax, UPPER_LIMIT;
	call	WriteDec
	mov		edx, OFFSET rangeEnd
	call 	WriteString 
	call 	CrLf
	call	CrLf

	ret
; +------------------------------------------------------------+
instructions ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
farewell	PROC
; Description:	
;
; Receives:		
; Returns:		
; Pre:			None
; Reg Changed:	
; +------------------------------------------------------------+

; Add some space and say goodbye
	call 	CrLf
	call 	CrLf

	mov 	edx, OFFSET goodbye1
	call 	WriteString
	call 	CrLf
	
	mov 	edx, OFFSET goodbye2
	call 	WriteString
	mov		edx, OFFSET programmer
	call	WriteString
	call 	CrLf
	call 	CrLf

	ret
; +------------------------------------------------------------+
farewell ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
getUserData	PROC
; Description:	Prompts user for int in range [1 .. UPPER_LIMIT]
;   until a valid value is input
; Receives:		
; Returns:		global numberInput = int in range [1 .. UPPER_LIMIT]
; Pre:			None
; Reg Changed:	eax, edx
; +------------------------------------------------------------+

; Unconditionally jump over error message on first pass
	jmp		PROMPT_USER

; Print error message if input out of range
REPROMPT_USER:
	mov		edx, OFFSET outOfRangMsg
	call	WriteString
	call	CrLf
	
PROMPT_USER:
	mov		edx, OFFSET valuePrompt_1
	call	WriteString
	mov		eax, UPPER_LIMIT
	call	WriteDec
	mov		edx, OFFSET valuePrompt_2
	call	WriteString


; Read an integer and then validate that it is in range using subroutine
	call	ReadDec
	call	validate	; this will set isValid to 0 (false) or non-zero (true)
	
; if global isValid == 0 (false), jump to top of loop
	cmp		isValid, 0
	je		REPROMPT_USER

	mov		numberInput, eax

	ret
; +------------------------------------------------------------+
getUserData ENDP
; +------------------------------------------------------------+


; +------------------------------------------------------------+
validate	PROC
; Description:	
;
; Receives:		eax register
; Returns:		global isValid == 0 if in range [1 .. UPPER_LIMIT]
;               == 1 if not in range [1 .. UPPER_LIMIT]
; Pre:			None
; Reg Changed:	
; +------------------------------------------------------------+

; If user input < +1, set isValid to false
	cmp		eax, 1
	jb		NOT_VALID

; If user input > +UPPER_LIMIT, set isValid to false
	cmp		eax, UPPER_LIMIT
	ja		NOT_VALID

; Else set isValid to true
	mov		isValid, 1
	jmp		VALIDATE_RETURN

NOT_VALID:
	mov		isValid, 0

VALIDATE_RETURN:
	ret
; +------------------------------------------------------------+
validate ENDP
; +------------------------------------------------------------+


; +------------------------------------------------------------+
showComposites PROC
; Description:	
;
; Receives:		
; Returns:		
; Pre:			None
; Reg Changed:	eax, ecx, al
; +------------------------------------------------------------+
	
; Set loop counter to numberInput and print out all composites
	mov		ecx, numberInput
	mov		currentInteger, 1	; explicitly setting internal counter

PRINT_COMPOSITES_LOOP:
	mov		eax, currentInteger
	call	isComposite
	cmp		isComp, 0
	je		NO_PRINT

	mov		eax, currentInteger
	call	WriteDec
	mov		al, TAB
	call	WriteChar

NO_PRINT:
	inc		currentInteger	; move to the next number
	loop	PRINT_COMPOSITES_LOOP

	ret
; +------------------------------------------------------------+
showComposites ENDP
; +------------------------------------------------------------+


; +------------------------------------------------------------+
isComposite PROC
; Description:	
;
; Receives:		eax register of value to check for composite-ness
; Returns:		
; Pre:			None
; Reg Changed:	eax, ebx, edx
; +------------------------------------------------------------+
	push	ecx				; save outer loop counter
	mov		valToCheck, eax	; hold the value from eax so we can reuse it in calculations

; if eax is 1, 2 or 3, then it is not composite
	cmp		valToCheck, 3
	jbe		ISCOMP_FALSE

; else if n is even or divisible by 3, it is composite
	; check if even	
	mov		eax, valToCheck
	mov		edx, 0
	mov		ebx, 2  
	div		ebx
	cmp		edx, 0
	je		ISCOMP_TRUE

	; check if divisible by 3
	mov		eax, valToCheck
	mov		edx, 0
	mov		ebx, 3  
	div		ebx
	cmp		edx, 0
	je		ISCOMP_TRUE

; else check if it is divisible by any integer from i = 3 to square root of valToCheck
; (Using this pseudocode from https://en.wikipedia.org/wiki/Primality_test) : 
; Let primalityCtr = 5
	mov		primalityCtr, 5

; while (primalityCtr * primalityCtr) <= valToCheck
PRIMAL_LOOP:
	mov		eax, primalityCtr
	mul		primalityCtr
	cmp		eax, valToCheck
	ja		ISCOMP_FALSE
	
; if valToCheck mod primalityCtr == 0, return true 
	mov		eax, valToCheck
	mov		edx, 0
	mov		ebx, primalityCtr
	div		ebx
	cmp		edx, 0
	je		ISCOMP_TRUE

; or if valToCheck mod (primalityCtr + 2) == 0, return true
	mov		eax, valToCheck
	mov		edx, 0
	mov		ebx, primalityCtr
	add		ebx, 2
	div		ebx
	cmp		edx, 0
	je		ISCOMP_TRUE

	; primalityCtr = primalityCtr + 6
	add		primalityCtr, 6
	loop	PRIMAL_LOOP  ; end 'while', jump back to while test

; if not, return false
	jmp		ISCOMP_FALSE

; If is a composite, set to return value = true
ISCOMP_TRUE:
	mov		isComp, 1
	jmp		ISCOMPOSITE_RETURN

; If is not composite, set return value = false
ISCOMP_FALSE:
	mov		isComp, 0
	jmp		ISCOMPOSITE_RETURN

ISCOMPOSITE_RETURN:
	pop		ecx		; restore outer loop counter
	ret
; +------------------------------------------------------------+
isComposite ENDP
; +------------------------------------------------------------+

END main





; The below should not compile


; +------------------------------------------------------------+
someprocess PROC
; Description:	
;
; Receives:		
; Returns:		
; Pre:			None
; Reg Changed:	
; +------------------------------------------------------------+

	
	ret
; +------------------------------------------------------------+
someprocess ENDP
; +------------------------------------------------------------+
