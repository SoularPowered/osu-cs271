TITLE Programming Assignment 3    (project03-hillyer.asm)

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
; [Implemented]			1. Number the lines during user input.
; [Implemented]			2. Calculate and display the average as a floating-point number, rounded to the nearest .001.
; [Not Implemented]		3. Do something astoundingly creative.

INCLUDE Irvine32.inc

; *********************
; Constants           *
; *********************

LOWER_LIMIT = -100		; smallest integer value user can enter
UPPER_LIMIT = -1		; largest integer value user can enter


; *********************
; Variables           *
; *********************
.data

; Strings - Output
	intro			BYTE	"Welcome to the Integer Accumulator",0
	programmer		BYTE	"by Shawn S Hillyer",0
	ecIntro_1		BYTE	"**EC: Numbers the lines during user input.",0
	ecIntro_2		BYTE	"**EC: Calculate and display the average as a floating-point number, rounded to the nearest .001",0
;	ecIntro_3		BYTE	"**EC: Does something astoundingly creative.",0
	namePrompt		BYTE	"What is your name?",0
	greeting		BYTE	"Hello, ",0
	
	instructions_1	BYTE	"I will sum negative integers in the valid range.",0
	instructions_2	BYTE	"Please enter numbers in [",0
	rangeEnd		BYTE	", -1].",0

	inputLabel		BYTE	"Entry #",0
	inputPrompt		BYTE	": Enter number and press enter: ",0
	noneInput		BYTE	"No values entered, you're making this too easy...",0
	tooLowMsg		BYTE	"That value is too low.",0
	
	qtyEnteredMsg_1	BYTE	"You entered ",0
	qtyEnteredMsg_2	BYTE	" valid numbers.",0
	sumMsg			BYTE	"The sum of your valid numbers is ",0
	averageMsg		BYTE	"The rounded average is ",0
	decimalStr		BYTE	".",0

	goodbye1		BYTE	"Next time I'll try not to be so 'negative'!",0
	goodbye2		BYTE	"Come again, ",0
	

; Strings - Input
	userName		BYTE	30 DUP(0)	; input buffer to store user's name


; Numbers used in processing the data
	numberInput		SDWORD	0			; the user's input number
	quantityEntered	DWORD	0			; How many (valid) negative numbers were entered
	sum				SDWORD	0			; The summation of all valid numbers entered
	average			SDWORD	0			; The average of all the values entered (sum / quantityEntered)
	avgDecimals		DWORD	4 DUP(0)	; the three decimal places for the average + 4th to calculate rounding
	avgDecimalsSize = ($ - avgDecimals)	/ 4	
	currentEntry	DWORD	1			; The current entry user is attempting to input

.code


; +------------------------------------------------------------+
main PROC
; Pre: None
; Post: See file header for description of program.
; +------------------------------------------------------------+

; Display the program title and programmer’s name & Get the user’s name, and greet the user.
	call	PrintIntroduction

; Display instructions for the user.
	call	PrintInstructions

; Repeatedly prompt the user to enter a number. 
; Validates the user input to be in [-100, -1] (inclusive).
; Counts and accumulates the valid user numbers until a non-negative number is entered. (The non-negative number is discarded.)

	call	SumIntegers

; if quantityEntered > 0, jump PROCESS_DATA, else we print special message and jump to FAREWELL
	cmp		quantityEntered,0
	jne		PROCESS_DATA

NONE_ENTERED:
	mov		edx, OFFSET noneInput
	call	WriteString
	call	CrLf
	jmp		FAREWELL

; Calculate the (rounded integer) average of the negative numbers.
PROCESS_DATA:
	; Move the arguments for CalculateAverage into registers
	mov		eax, sum
	mov		ebx, quantityEntered
	call	CalculateAverage


; Display results: i. the number of negative numbers entered, ii. the sum of negative numbers entered, 
; iii. the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
	mov		ebx, sum
	mov		eax, average
	mov		edx, quantityEntered
	call	PrintSummary

; FareWell message (with the user’s name)
FAREWELL:
	call	PrintFarewell


	exit	; exit to operating system
main ENDP

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

; Prompt for and Get the user's name as a string
	call 	CrLf
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



; +------------------------------------------------------------+
SumIntegers	PROC
; Pre:	None
; Post: Repeatedly prompt the user to enter a numbers
; Post: sum will hold the sum of all numbers in the valid range
; Post: quantityEntered will hold the number of value sentered
; +------------------------------------------------------------+

; Repeatedly prompt the user to enter a number. 
READ_VALUE:

; Extra Credit: Labels each entry with the current valid entry attempt
	mov		edx, OFFSET inputLabel
	call	WriteString
	mov		eax, currentEntry
	call	WriteDec

; Print the rest of prompt and prompt for input
	mov		numberInput, eax
	mov		edx, OFFSET inputPrompt
	call	WriteString
	call	ReadInt
	mov		numberInput, eax

; if numberInput is lower than LOWER_LIMIT, print error message and prompt again
	cmp		numberInput, LOWER_LIMIT
	jge		NOT_TOO_LOW
TOO_LOW:
	mov		edx, OFFSET tooLowMsg
	call	WriteString
	call	CrLf
	jmp		READ_VALUE

; else if input is >= 0, jump to end of function
NOT_TOO_LOW:
	cmp		numberInput, 0
	jns		END_SUM			; Check the signed flag and see if the value is negative or not

; else value is in range (inclusive) of [LOWER_LIMIT .. UPPER_LIMIT] so increment counter and add to sum, repeat
	mov		eax, sum
	add		eax, numberInput
	mov		sum, eax
	inc		quantityEntered
	inc		currentEntry
	jmp		READ_VALUE

END_SUM:	
	ret
; +------------------------------------------------------------+
SumIntegers ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
CalculateAverage PROC
; Pre:	EAX holds the sum of the values being averaged
; Pre:	EBX holds the quantity of values to average
; Pre:	EBX (quantity) > 0
; Post: average holds the integer average
; Post: avgDecimals array holds the next 4 decimal points of the calculation
; +------------------------------------------------------------+
	push	ebx

; Average (EAX) = Sum (EDX:EAX) / Quantity (EBX)
	cdq					; extend EAX into EDX
	idiv	ebx
	mov		average, eax

; Setup for decimal calculation loop
	mov		esi, 0
	mov		ecx, avgDecimalsSize
	neg		edx	; edx is negative we want to work with positive for rest of algorithm

CALC_DECIMALS:

; Multiply the remainder by 10 then divide that by the quantityEntered
	mov		eax, edx
	mov		ebx, 10
	mul		ebx		; eax is already extended

; EDX:EAX contains the Remainder * 10, now divide by original divisor in stack
	pop		ebx
	push	ebx		; re-save qantityEntered value
	div		ebx		; (remainder * 10) / quantityEntered
	mov		avgDecimals[esi], eax
	add		esi, 4
	loop	CALC_DECIMALS

	pop		ebx		; clear the last push off stack

; Determine if we need to round up by comparing the 4th decimal to 5
	cmp		avgDecimals[esi], 5
	jb		NO_ROUND

; If the 4th decimal is greater than or equal to 5, round up the 3rd
	mov		esi, 0
	add		esi, 2 * 4		; third element * 4 bytes each
	inc		avgDecimals[esi]

NO_ROUND:

	ret
; +------------------------------------------------------------+
CalculateAverage ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
PrintSummary PROC
; Pre:	EAX must hold the average
; Pre:	EBX must hold the sum
; Pre:	EDX must hold the quantity of values entered
; Post: Sum, average, and quantity entered will be displayed on screen
; +------------------------------------------------------------+

; Print the number of valid numbers entered
	mov 	edx, OFFSET qtyEnteredMsg_1
	call 	WriteString
	mov		eax, quantityEntered
	call	WriteDec
	mov 	edx, OFFSET qtyEnteredMsg_2
	call 	WriteString
	call 	CrLf
	call 	CrLf

; Print the sum of the numbers
	mov		edx, OFFSET	sumMsg
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call 	CrLf

; Print the average of the numbers
	mov		edx, OFFSET averageMsg
	call	WriteString
	mov		eax, average
	call	WriteInt
	mov		edx, OFFSET decimalStr
	call	WriteString

	mov		ecx, 3	; we will print the first three decimals
	mov		esi, OFFSET avgDecimals
DECIMAL_PRINT:
	mov		eax, [esi]
	call	WriteDec
	add		esi, 4

	loop	DECIMAL_PRINT

	ret
; +------------------------------------------------------------+
PrintSummary ENDP
; +------------------------------------------------------------+

END main





; The below should not compile
; this is the non-extra-credit version of the average calculation


; +------------------------------------------------------------+
CalculateAverage PROC
; Pre:	EAX holds the sum of the values being averaged
; Pre:	EBX holds the quantity of values to average
; Pre:	EBX (quantity) > 0
; Post: EAX will hold the average, rounded to nearest integer, of values entered
; +------------------------------------------------------------+
	push	ebx

; Average (EAX) = Sum (EDX:EAX) / Quantity (EBX)
	cdq					; extend EAX into EDX
	idiv	ebx

; if [ (2 * remainder) >= quantity ], then we'd get a decimal of .5 or higher, so need to round
	neg		edx			; the remainder is negative -- we want to work with a positive value for this comparison
	mov		ebx, edx
	add		edx, ebx	; this doubles the remainder
	pop		ebx			; get the original count back	
	cmp		edx, ebx
	jb		NO_ROUNDING	; if (remainder * 2 < quantityEntered), don't round
	dec		eax			; else deccrement to closest integer. -20.5 through -20.9, for exmaple, should round to -21. -20.4 should stay as -20
NO_ROUNDING:
	
	ret
; +------------------------------------------------------------+
CalculateAverage ENDP
; +------------------------------------------------------------+
