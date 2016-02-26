TITLE Programming Assignment 6    (project06-hillyer.asm)
; =====================================================================================
; Author:                  Shawn S Hillyer
; Email:                   hillyers@oregonstate.edu
; CS271-400 / Project ID:  Programming Assignment 6
; Due Date:                03/13/2016
; =====================================================================================

; =====================================================================================
; [Problem Definition]
; + Implement and test your own ReadVal and WriteVal procedures for unsigned integers.
; + Implement macros getString and displayString. The macros may use Irvine’s ReadString 
;   to get input from the user, and WriteString to display output. [ DONE ]
;   - getString should display a prompt, then get the user’s keyboard input into a 
;     memory location [DONE]
;   - displayString should display the string stored in a specified memory location. [DONE]
;   - readVal should invoke the getString macro to get the user’s string of digits.  [DONE]
;     It should then convert the digit string to numeric, while validating the user’s 
;     input. [DONE]
;   - writeVal should convert a numeric value to a string of digits, and invoke the 
;     displayString macro to produce the output.
; + Write a small test program that gets 10 valid integers from the user and stores 
;   the numeric values in an array. The program then displays the integers, 
;   their sum, and their average.
; =====================================================================================

; =====================================================================================
; [Requirements]
;  1) User’s numeric input must be validated the hard way: Read the user's input as a 
;     string, and convert the string to numeric form. If the user enters non-digits or 
;     the number is too large for 32-bit registers, an error message should be displayed
;     and the number should be discarded. [DONE]
;  2) Conversion routines must appropriately use the lodsb and/or stosb operators. [DONE]
;  3) All procedure parameters must be passed on the system stack. [DONE]
;  4) Addresses of prompts, identifying strings, and other memory locations should be 
;     passed by address to the macros. [DONE] (Exception: my own macros don't always pass by memory)
;  5) Used registers must be saved and restored by the called procedures and macros. [DONE]
;  6) The stack must be “cleaned up” by the called procedure. [DONE]
; =====================================================================================

; =====================================================================================
; [Extra-credit options]
; [Not Implemented]	1. [1 point ]: Number each line of user input and display a 
;                          running subtotal of the user's numbers
; [Not Implemented]	2. [2 points]: Handle signed integers.
; [Not Implemented]	3. [3 points]: make your ReadVal and WriteVal procedures recursive.
; [Not Implemented]	4. [4 points]: implement procedures ReadVal and WriteVal for 
;                          floating point values, using the FPU.

INCLUDE Irvine32.inc


; *********************
; Macros              *
; *********************

; +============================================================+
; getString
; Description: Displays a prompt then get user's keyboard input 
; into a memory location stored as a string into outString	
; Receives:	@promptAddr: address of string to be printed as a prompt
;           @outStringAddr: Address of the array to store the input string into
; +------------------------------------------------------------+
getString MACRO promptAddr:REQ, outStringAddr:REQ
;; Save used registers
	push	edx
	push	ecx

; Display prompt for user
	displayString promptAddr

; Get user's keyboard input into the outString variable location
	mov		edx, outStringAddr
	mov		ecx, BUFFER_SIZE 
	call	ReadString

;; Restore registers
	pop		ecx
	pop		edx

;; +------------------------------------------------------------+	
ENDM
; +============================================================+


; +============================================================+
; displayString
; Description: Displays the string stored in specified mem location
; Receives: @stringAddr: address of string to be printed
; +------------------------------------------------------------+
displayString MACRO stringAddr:REQ
;; Save used registers
	push	edx
;; Use WriteString to display the string stored in memory address	
	mov		edx, stringAddr
	call	WriteString
;; Restore registers
	pop		edx

;; +------------------------------------------------------------+
ENDM
; +============================================================+

; Call WriteVal procedure using pRawStringOut as consistent location for processing
callWriteVal MACRO integer:REQ
	mov		eax, integer
	push	pRawStringOut
	push	eax
	call	writeval
ENDM


; Set up the stack frame pointer
mSetStackFrame MACRO
	push	ebp
	mov		ebp, esp
ENDM

; Restores a stack before returning with optional arguments to restore with ret call
mCleanStackFrame MACRO argBytes
	mov		esp, ebp ;; remove any locals from stack
	pop		ebp
	ret		argBytes
ENDM


; *********************
; Constants           *
; *********************
MAX_UNSIGNED_INT EQU 4294967295   ; maximum value that fits in 32 bit unsigned DWORD
MAX_DIGITS = 10                 ; maximum digits that a user can enter and still (possibly) be 32 bit unsigned int
DATA_ARRAY_SIZE = 10
BUFFER_SIZE = DATA_ARRAY_SIZE + 30
MAX_BUFFER_SIZE = DATA_ARRAY_SIZE + 1
ASCII_ZERO = 48
ASCII_NINE = 57


; *********************
; Variables           *
; *********************
.data

; Strings - Output
	intro			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0Dh,0Ah
					BYTE	"Written by Shawn S Hillyer",0
;	ecIntro_1		BYTE	"**EC: ",0
;	ecIntro_2		BYTE	"**EC: ",0
;	ecIntro_3		BYTE	"**EC: ",0
;	ecIntro_4		BYTE	"**EC: ",0
	pIntro			DWORD	OFFSET intro
	
	instructions	BYTE	"Please provide 10 unsigned decimal integers.",0Dh,0Ah
					BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0Dh,0Ah
					BYTE	"After you have finished inputting the raw numbers I will display a list",0Dh,0Ah
					BYTE	"of the integers, their sum, and their average value.",0
	pInstructions	DWORD	OFFSET instructions

	valuePrompt		BYTE	"Please enter an unsigned number:  ",0
	pValuePrompt	DWORD	OFFSET valuePrompt

	badInputMsg		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0Dh,0Ah
					BYTE	"Please try again:  ",0
	pBadInputMsg	DWORD	OFFSET badInputMsg

	numbersMsg		BYTE	"You entered the following numbers: ",0
	pNumbersMsg		DWORD	OFFSET numbersMsg
	sumMsg			BYTE	"The sum of these numbers is: ",0
	pSumMsg			DWORD	OFFSET sumMsg
	avgMsg			BYTE	"The average is: ",0
	pAvgMsg			DWORD	OFFSET avgMsg

	goodbye			BYTE	"Getting down low with the in and the out was fun!",0
	pGoodbye		DWORD	OFFSET goodbye

; Data Variables
	userData		DWORD	DATA_ARRAY_SIZE DUP(0)	; Array to store Unsigned Integers
	userDataSize = ($ - userData)
	pUserData		DWORD	OFFSET userData
	singleInt		DWORD	0
	rawStringIn		BYTE	BUFFER_SIZE DUP(0)
	pRawStringIn	DWORD	rawStringIn
	rawStringOut	BYTE	BUFFER_SIZE DUP(0)
	pRawStringOut	DWORD	rawStringIn
	dataSum			DWORD	0		; The sum of the userData array
	dataAvg			DWORD	0		; Average of the data stored in userData array
	
; +============================================================+

.code

; +============================================================+
main PROC
; Description:	Main program logic. Generates random numbers, prints
;   in unsorted order, then sorts and prints median and sorted order.
; Receives:		None
; Returns:		None
; Pre:			None
; Reg Changed:	Potentially all - main entrypoint
; +------------------------------------------------------------+

; Display the program title and programmer's name & Get the user's name, and greet the user.
	displayString 	pIntro
	call			CrLf
	call			CrLF

; Display instructions for the user.
	displayString 	pInstructions
	call			CrLf
	call			CrLF

; Prompt user for the 10 values and store them in an array
	push	pRawStringIn
	mov		eax, DATA_ARRAY_SIZE
	push	eax			; arrSize
	push	pUserData	; pArr
	call	getUserData
	call	CrLF

; Calculate the sum and average of the array
	push	offset	dataAvg
	push	offset dataSum
	mov		eax, DATA_ARRAY_SIZE
	push	eax
	push	pUserData
	call	sumAvgArray
	
; Print the values entered
	displayString pNumbersMsg
	mov		eax, DATA_ARRAY_SIZE
	push	eax
	push	pUserData
	call	CrLf
	call	printArray
	call	CrLf

; Print the sum
	displayString pSumMsg
	callWriteVal	dataSum
	call	CrLf

; Print the average
	displayString pAvgMsg
	callWriteVal	dataAvg
	call	CrLf

; Print FareWell message
	call	CrLf
	displayString 	pGoodbye
	call	CrLF
	call	CrLF

; exit to operating system
	exit	

; +------------------------------------------------------------+
main ENDP
; +============================================================+


; +============================================================+
ReadVal PROC
; Description:	Gets string of digits from user, then convert to
;               numeric and validate input.
; Receives:	    @pStrBuffer: buffer to store the digits into
;               @result: return by reference the numeric representation
;                 of the string
; Returns:		result (by reference)
; Pre:			None
; Reg Changed:	None
; +------------------------------------------------------------+
	pStrBuffer	EQU [ebp + 8]
	result		EQU [ebp + 12]

	mSetStackFrame
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi

; Get string from user, setup ESI to point to pStrBuffer for lodsb and ensure we're moving forward
	getString	pValuePrompt, pStrBuffer
FRESH_STRING:
	mov			ebx, 0			; use ebx as accumulator because lodsb will overwrite eax
	mov			esi, pStrBuffer
; Convert digit string to numeric while validating user's input	

CONVERT_STRING:
	lodsb	 ; load next character from pStrBuffer into al
 
;f if character is 0, the null terminator for the string, then end of string - continue
	cmp		al, 0
	jz		END_OF_STRING

; else if character's ascii value is not between ascii 0 and ascii 9, reprompt for string	
	cmp		al, ASCII_ZERO
	jb		BAD_INPUT
	cmp		al, ASCII_NINE
	ja		BAD_INPUT

; else do the conversion using algorithm and repeat loop
	sub		al, 48		; convert from ascii to numeric reprsentation
	movzx	ecx, al		; save char in safe spot and make it a DWORD at same time

; ebx = ebx * 10 + (digit) 
	mov		eax, ebx	; eax = 'x'
	mov		edx, 0
	mov		edi, 10
	mul		edi			

; If overflow, the uer's integer is too large to fit
	cmp		edx, 0
	JNZ		BAD_INPUT
	add		eax, ecx	

; Check overflow again - addition might theoretically overflow too
	jc		BAD_INPUT
	mov		ebx, eax		; ebx now as the integer as calculated so far
	jmp		CONVERT_STRING

END_OF_STRING:
; finally compare it to the max int value 
	mov		eax, MAX_UNSIGNED_INT
	cmp		ebx, eax
	jno		GOOD_INPUT

; if bad, reprompt:
BAD_INPUT:
	getString	pBadInputMsg, pStrBuffer
	call		CrLF
	jmp			FRESH_STRING

GOOD_INPUT:

; return value by reference
	mov		edi, result
	mov		[edi], ebx  ; store the result in EBX to the location pointed at by eax, which is result

; Clean up stack and return
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	mCleanStackFrame 8

; +------------------------------------------------------------+
ReadVal ENDP
; +============================================================+


; +============================================================+
WriteVal PROC
; Description:	Convert numeric value to a string of digits and
;	        invoke the displayString macro to produce output
; Algorithm is repeated division by 0, then add 48 to remainder
; Receives:		intVal - unsigned integer value to print
;               strArr - array to store the string in
; Returns:		None
; Pre:			intVal must be doubleword and unsigned
; Reg Changed:	0
; +------------------------------------------------------------+
	intVal EQU [ebp + 8]
	strArr EQU [ebp + 12]

	mSetStackFrame
	push	eax
	push	ebx
	push	edx
	push	edi


; setup esi with our storage array and set ebx as a divisor
	mov		edi, strArr
	add		edi, MAX_BUFFER_SIZE
	mov		ebx, 10
	dec		edi
	std					; will move backwards through string

; put a null terminator at end of string then move backwards one byte
	mov		edx, 0	
	mov		[edi], edx
	dec		edi

; divide intVal by 10 repeatedly
	mov		eax, intVal

NEXT_DIGIT:
	mov		edx, 0
	div		ebx
; store remainder into [edi]
	xchg	eax, edx
	add		eax, 48		; convert to ascii digit
	stosb	
	xchg	eax, edx
; if eax == 0, no more division, else loop
	cmp		eax, 0
	jnz		NEXT_DIGIT

; call displayString - pass in edi+1 which sould point to the last character inserted
	inc		edi
	displayString edi

; Clean up stack and return
	pop		edi
	pop		edx
	pop		ebx
	pop		eax
	mCleanStackFrame

; +------------------------------------------------------------+
WriteVal ENDP
; +============================================================+



; +============================================================+
getUserData PROC
; Description:	Iterates to get and store arrSize unisgned integers
;	              into the array pointed at by pNumArr
; Receives:		pNumArr: address of array to store values in
;               arrSize: size of the array to store values in
;               pStrArr: address of array to store/process keyboard input
; Returns:		Filled array (by reference / side effect)
; Pre:			None
; Reg Changed:	None
; +------------------------------------------------------------+
	pNumArr		EQU [ebp + 8]   ; pointer to array to fill with data
	arrSize		EQU [ebp + 12]  ; size of array
	pStrArr		EQU	[ebp + 16]  ; the string used to store the user's input

	mSetStackFrame
	push	eax
	push	ecx
	push	edx
	push	edi
	
; Set up loop
	mov		ecx, arrSize
	mov		edi, pNumArr

FILL_ARR:
; Call ReadVal with 2 args
	mov		edx, pStrArr
	push	offset singleInt  ; singleInt pased by ref, gets return val by ref from ReadVal
	push	edx				  ; pStrArr 
	call	ReadVal
; DEBUG:
	mov		eax, singleInt
	stosd
	loop	FILL_ARR

; Clean up stack and return
	pop		edi
	pop		edx
	pop		ecx
	pop		eax
	mCleanStackFrame 12

; +------------------------------------------------------------+
getUserData ENDP
; +============================================================+



; +============================================================+
sumAvgArray PROC
; Description:	Calculates the sum and average of an array
; Receives:		@pNumArr - pointer to an array of unsigned integers
;				arrSize - size of the array
;               @arrSum - address of DWORD to store sum in
;               @arrAvg - address of DWORD to store average
; Returns:		the sum of the array (arrSum) and average (arrAg)
; Pre:			arrSum and arrAvg argument must = 0 prior to call
; Reg Changed:	None
; +============================================================+
	pNumArr		EQU [ebp + 8]   ; array from which we read data
	arrSize		EQU [ebp + 12]  ; size of array
	arrSum		EQU [ebp + 16]  ; sum of values in array
	arrAvg		EQU [ebp + 20]	; average of values in array

; Setup Stack Frame	
	mSetStackFrame
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	edi
	push	esi	

; Set up loop
	mov		ecx, arrSize
	mov		esi, pNumArr
	mov		edi, arrSum
	
SUM_ARR:
	lodsd		; load next value in array into EAX and increment ESI
	add		[edi], eax
	loop	SUM_ARR
	
; Now calculate the average
	mov		eax, [edi]		; eax = sum, ebx = quantity
	mov		edx, 0
	mov		ebx, arrSize
	div		ebx				; divide sum/size
	mov		edi, arrAvg
	mov		[edi], eax


; Clean up stack
	pop		esi
	pop		edi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	mCleanStackFrame 16
; +------------------------------------------------------------+
sumAvgArray ENDP
; +============================================================+


; +============================================================+
printArray PROC
; Description:	Calculates the sum and average of an array
; Receives:		@pNumArr - pointer to an array of unsigned integers
;				arrSize - size of the array
; Returns:		the sum of the array (arrSum) and average (arrAg)
; Pre:			arrSum and arrAvg argument must = 0 prior to call
; Reg Changed:	None
; +============================================================+
	pNumArr		EQU [ebp + 8]   ; array from which we read data
	arrSize		EQU [ebp + 12]  ; size of array

; Setup Stack Frame	
	mSetStackFrame
	push	esi
	push	ecx	

; Set up loop
	cld
	mov		ecx, arrSize
	mov		esi, pNumArr
	
PRINT_ARR:
	lodsd
	callWriteVal	eax
	call	CrLf
	loop	PRINT_ARR

; Clean up stack
	pop		esi
	pop		ecx
	mCleanStackFrame 8
; +------------------------------------------------------------+
printArray ENDP
; +============================================================+


; +============================================================+
END main
; +============================================================+