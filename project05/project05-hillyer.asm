TITLE Programming Assignment 5    (project05-hillyer.asm)

; ==========================================================================================================
; Author: Shawn S Hillyer								Email: hillyers@oregonstate.edu
; CS271-400 / Project ID: Programming Assignment 5		Due Date: 02/28/2016
; ==========================================================================================================
; ==========================================================================================================
; [Description]  
; Write and test a MASM program to perform the following tasks:
; 1. Introduce the program. [done]
; 2. Get a user request in the range [min = 10 .. max = 200]. [done]
; 3. Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive 
;    elements of an array. [done]
; 4. Display the list of integers before sorting, 10 numbers per line. [done]
; 5. Sort the list in descending order (i.e., largest first). [done]
; 6. Calculate and display the median value, rounded to the nearest integer. [done]
; 7. Display the sorted list, 10 numbers per line. [done]
;
; ==========================================================================================================
; [Requirements]
; 1.  The title, programmer's name, and brief instructions must be displayed on the screen.
; 2.  The program must validate the user’s request.
; 3.  min, max, lo, and hi must be declared and used as global constants. Strings may be declared as global 
;     variables or constants.
; 4.  The program must be constructed using procedures. At least the following procedures are required:
;      A. main   [DONE]
;      B. introduction	[DONE]
;      C. get data {parameters: request (reference)}	[DONE]
;      D. fill array {parameters: request (value), array (reference)}	[DONE]
;      E. sort list {parameters: array (reference), request (value)}	
;           i. exchange elements (for most sorting algorithms): {parameters: array[i] (reference),
;              array[j] (reference), where i and j are the indexes of elements to be exchanged}
;      F. display median {parameters: array (reference), request (value)}	[DONE]
;      G. display list {parameters: array (reference), request (value), title (reference)}	[DONE]
; 5.  Parameters must be passed by value or by reference on the system stack as noted above.	[DONE]
; 6.  There must be just one procedure to display the list. This procedure must be called twice: once to 
;     display the unsorted list, and once to display the sorted list.  [DONE]
; 7.  Procedures (except main) should not reference .data segment variables by name. request, array, and 
;     titles for the sorted/unsorted lists should be declared in the .data segment, but procedures must use them 
;     as parameters. Procedures may use local variables when appropriate. Global constants are OK. [DONE]
; 8.  The program must use appropriate addressing modes for array elements. [DONE]
; 9.  The two lists must be identified when they are displayed (use the title parameter for the display 
;     procedure). [DONE]
; 10. The program must be fully documented. This includes a complete header block for the program and for
;     each procedure, and a comment outline to explain each section of code. [DONE]
; 11. The code and the output must be well-formatted. [DONE]
; ==========================================================================================================
; [Important Notes]
; 1. The Irvine library provides procedures for generating random numbers. Call Randomize once at the
;    beginning of the program (to set up so you don't get the same sequence every time), and call RandomRange
;    to get a pseudo-random number. (See the documentation in Lecture slides.) [DONE]
; 2. The Selection Sort is probably the easiest sorting algorithm to implement. Here is a version of the
;    descending order algorithm, where request is the number of array elements being sorted, and exchange is
;    the code to exchange two elements of array:
;
;      for(k=0; k<request-1; k++) {
;        i = k;
;        for(j=k+1; j<request; j++) {
;          if(array[j] > array[i])
;            i = j;
;          }
;        exchange(array[k], array[i]);
;      }
; 3. The median is calculated after the array is sorted. It is the "middle" element of the sorted list. If the
;    number of elements is even, the median is the average of the middle two elements (may be rounded). [DONE]
; ==========================================================================================================
; [Extra-credit options]
; [Not Implemented]	1. Display the numbers ordered by column instead of by row
; [Not Implemented]	2. Use a recursive sorting algorithm (e.g., Merge Sort, Quick Sort, Heap Sort, etc.).                          
; [Not Implemented]	3. Implement the program using floating-point numbers and the floating-point processor
; [Not Implemented]	4. Generate the numbers into a file; then read the file into the array

INCLUDE Irvine32.inc

; *********************
; Constants           *
; *********************
MIN = 10	; minimum quantity of numbers to generate
MAX = 200	; maximum quantity of numbers to generate
LO = 100	; lowest range for random numbers
HI = 999	; highest range for random numbers


; *********************
; Variables           *
; *********************
.data

; Strings - Output
	intro			BYTE	"Sorting Random Integers",0
	programmer		BYTE	"Programmed by Shawn S Hillyer",0
;	ecIntro_1		BYTE	"**EC: Displays the numbers ordered by column instead of by row.",0
;	ecIntro_2		BYTE	"**EC: Uses a recursive sorting algorithm.",0
;	ecIntro_3		BYTE	"**EC: Uses floating-point numbers and floating-point processor.",0
;	ecIntro_4		BYTE	"**EC: Generates the numbers into a file, then reads the file into the array.",0
	
	instructions_1	BYTE	"This program generates random numbers in the range [",0
	instructions_2	BYTE	" .. ",0
	instructions_3	BYTE	"],",0
	instructions_4	BYTE	"displays the original list, sorts the list, and calculates the ",0
	instructions_5	BYTE	"median value. Finally, it displays the list in descending order.",0
	rangeEnd		BYTE	" composites.",0

	valuePrompt_1	BYTE	"How many numbers should be generated? [",0
	valuePrompt_2	BYTE	" .. ",0
	valuePrompt_3	BYTE	"]: ",0
	outOfRangeMsg	BYTE	"Invalid input",0
		
	unsortedTitle	BYTE	"The unsorted random numbers:",0
	sortedTitle		BYTE	"The sorted list:",0
	medianTitle		BYTE	"The median is ",0

	goodbye1		BYTE	"I'm glad we sorted this all out. Catch you later.",0


; Numbers used in processing / formatting the data
	request			DWORD	0			; number of random values to generate, input by user
	array			DWORD	MAX DUP(?)  ; to store array of random values, to later be sorted

.code

; +------------------------------------------------------------+
main PROC
; Description:	Main program logic. Generates random numbers, prints
;   in unsorted order, then sorts and prints median and sorted order.
; Receives:		None
; Returns:		None
; Pre:			None
; Reg Changed:	Potentially all - main entrypoint
; +------------------------------------------------------------+

; seed random number generater, used by fillArray
	call	Randomize  

; Display the program title and programmer’s name & Get the user’s name, and greet the user.
	push	OFFSET programmer
	push	OFFSET intro
	call	introduction

; Display instructions for the user.
	push	OFFSET instructions_5
	push	OFFSET instructions_4
	push	OFFSET instructions_3
	push	OFFSET instructions_2
	push	OFFSET instructions_1
	call	instructions

; Prompt the user for an integer in range [min .. max] and store return value in getUserData	
	push	OFFSET outOfRangeMsg
	push	OFFSET valuePrompt_3
	push	OFFSET valuePrompt_2
	push	OFFSET valuePrompt_1
	push	OFFSET request
	call	getUserData

; Generate the random integers and store in array
	push	OFFSET array
	push	request	
	call	fillArray

; Display the list of integers before sorting, 10 numbers per line.
	push	OFFSET	unsortedTitle
	push	request
	push	OFFSET array
	call	displayList

; Sort the list in descending order
	push	request
	push	OFFSET array
	call	sortList

; Calculate and display the median value, rounded to the nearest integer
	push	OFFSET medianTitle
	push	request
	push	OFFSET array
	call	displayMedian

; Display the sorted list, 10 numbers per line
	push	OFFSET	sortedTitle
	push	request
	push	OFFSET array
	call	displayList

; Print FareWell message
	push	OFFSET goodbye1
	call	farewell

; exit to operating system
	exit	
main ENDP


; +------------------------------------------------------------+
introduction	PROC USES edx
; Description:	Prints introduction to screen
; Receives:		Offset of the introduction strings
; Returns:		None
; Pre:			None
; Reg Changed:	None
; +------------------------------------------------------------+

	push	ebp
	mov		ebp, esp

; Print Program Title and Programmer's Name
	mov		edx, [ebp + 12]		; Offset starts at 12 because of the implicit edx PUSH from USES in declaration of procedure
	call 	WriteString 
	call 	CrLf

	mov		edx, [ebp + 16]
	call 	WriteString
	call 	CrLf

; Extra Credit 1 Implemented message
;	mov		edx, [ebp + 20]
;	call	WriteString
;	call	CrLf
	
; Extra Credit 2 Implemented message
;	mov		edx, [ebp + 24]
;	call	WriteString
;	call	CrLf

; Extra Credit 3 Implemented message
;	mov		edx, edx, [ebp + 28]
;	call	WriteString
;	call	CrLf

; Extra Credit 4 Implemented message
;	mov		edx, edx, [ebp + 32]
;	call	WriteString
;	call	CrLf
	
	call 	CrLf

; Clean up stack and return
	pop		ebp
	ret		8		; make sure to modify this if add any extra credit addresses
; +------------------------------------------------------------+
introduction ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
instructions	PROC	USES	edx eax
; Description:	Print instructions for user to screen
; Receives:		Offset of strings, by reference)
; Returns:		None
; Pre:			HI and LO constants defined as integer constants
; Reg Changed:	None
; +------------------------------------------------------------+
	push	ebp
	mov		ebp, esp

; Print description of what program will do
	mov		edx, [ebp + 16]		; first parameter at offset 16 due to USES directive
	call	WriteString			; "This program generates random numbers in the range ["
	mov		eax, LO	
	call	WriteDec
	mov		edx, [ebp + 20]		
	call	WriteString			; " .. "
	mov		eax, HI
	call	WriteDec
	mov		edx, [ebp + 24]
	call	WriteString			; "],"
	call	CrLf
	mov		edx, [ebp + 28]
	call	WriteString			; "displays the original list, sorts the list, and calculates the "
	call	CrLf
	mov		edx, [ebp +32]
	call	WriteString			; "median value. Finally, it displays the list in descending order."
	call	CrLf
	call	CrLf

; Clean up stack and return
	pop		ebp
	ret		20 
; +------------------------------------------------------------+
instructions ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
farewell		PROC	USES	edx
; Description:	Prints a farewell message to user
; Receives:		Offsets of string to print farewell message
; Returns:		None
; Pre:			None
; Reg Changed:	None
; +------------------------------------------------------------+
	push	ebp
	mov		ebp,esp

; Add some space and say goodbye
	mov		edx, [ebp + 12]
	call	WriteString
	call	CrLf
	call	CrLf

; Clean up stack and return
	pop		ebp
	ret		4
; +------------------------------------------------------------+
farewell ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
getUserData	PROC	USES	eax edx
; Description:	Prompts user for int in range [MIN .. MAX]
;   until a valid value is input
; Receives:		Request {reference}
; Returns:		Request {by reference}
; Pre:			MIN and MAX positive integer constants; MIN < MAX
; Reg Changed:	None
; +------------------------------------------------------------+
	push	ebp
	mov		ebp, esp

GET_INPUT:
; Print message to user
	mov		edx, [ebp+20]
	call	WriteString
	mov		eax, MIN
	call	WriteDec
	mov		edx, [ebp+24]
	call	WriteString
	mov		eax, MAX
	call	WriteDec
	mov		edx, [ebp+28]
	call	WriteString

; Get input and validate in range [MIN .. MAX]
	mov		edi, [ebp + 16] ; destination will be &request
	call	ReadDec 
	cmp		eax, MIN
	jb		OUT_OF_RANGE
	cmp		eax, MAX
	ja		OUT_OF_RANGE
	jmp		IN_RANGE

OUT_OF_RANGE:
	mov		edx, [ebp + 32]
	call	WriteString
	call	CrLf
	jmp		GET_INPUT

IN_RANGE:
; Store result in reference variable, request
	mov		[edi], eax; ; test -- store 55 in request

; Clean up stack and return
	pop		ebp
	ret		20
; +------------------------------------------------------------+
getUserData ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
fillArray	PROC
; Description:	Fills the array with random numbers from 
; Receives:		request (value), array (reference)
; Returns:		array is populated with n=request values (by ref)
; Pre:			request must be positive; array must refer to an
;               array of at least size request
; Reg Changed:	
; +------------------------------------------------------------+
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp + 12] ; @array
	mov		ecx, [ebp + 8]  ; set ecx to value of request
	
FILL_VALS:
	mov		eax, MAX + 1 - MIN ; randomrange returns from 0 to n-1, so we need to get value and add back in later
	call	RandomRange
	add		eax, MIN	   ; add back in the offset
	mov		[edi], eax     ; store in the array
	add		edi, 4  ; increment to next element
	loop	FILL_VALS

; Clean up stack and return	
	pop		ebp
	ret		8
; +------------------------------------------------------------+
fillArray ENDP
; +------------------------------------------------------------+



; +------------------------------------------------------------+
sortList PROC USES ecx eax esi
; Description:	Sorts an array in descending order (bubble sort)
; Receives:		array (reference), request (value)
; Returns:		array is sorted
; Pre:			array must be of at least size request
; Reg Changed:	
; Reference Material Used: Bubble Sort algorithm in Irvine text
; Page 374-375. I tried to notate comments to demonstrate I understand
; how it eas implemented.
; +------------------------------------------------------------+
	arr		EQU DWORD PTR [ebp + 20]
	arrSize	EQU DWORD PTR [ebp + 24]
	
	push	ebp
	mov		ebp, esp

; Set up ECX for this style of for loop:
;	for (ecx1 = arrSize - 1; ecx > 0; ecx--)
	mov		ecx, arrSize
	dec		ecx				; cx1 = N-1
; While ( ecx1 > 0)
;   Compare array[ecx1] to every element from array[0] to array[request-1]

OUTER_LOOP:
	push	ecx				; save outer loop variable
	mov		esi, arr		; esi = @array[0]

INNER_LOOP:
; Compare array[ecx2] to array[ecx2 + 1] (note that ecx2 starts as same as ecx1 but increments and is later restored to ecx1)
	mov		eax, [esi]		; eax = array[ecx]
	cmp		[esi+4], eax

; if arr[ecx2] >= arr[ecx2 + 1], do not exchange the values
	jl		NO_SWAP				
	xchg	eax, [esi+4]	; else exchange the pair
	mov		[esi], eax		

NO_SWAP:
	add		esi, 4		
	loop	INNER_LOOP		; ecx2--
	; END Inner Loop

; restore outer loop counter
	pop		ecx			
	loop	OUTER_LOOP
	; END Outer Loop

; Clean up stack and return
	mov		esp, ebp	; remove locals from stack
	pop		ebp
	ret		8
; +------------------------------------------------------------+
sortList ENDP
; +------------------------------------------------------------+


; +------------------------------------------------------------+
exchange PROC USES eax ebx
; Description:	exchange elements of an array
; Receives:		array[i] (reference) array[j] (reference), where
;  i and j are indices of array to be exchanged
; Returns:		array[i], array[j] updated by reference (swapped)
; Pre:			i and j are within range of array[0] to array[request-1]
; Reg Changed:	None
;
;  NOT CALLED / FULLY TESTED because I used simpler sort algorithm
;
; +------------------------------------------------------------+
	arr_i EQU DWORD PTR [ebp + 16]
	arr_j EQU DWORD PTR [ebp + 20]

	push	ebp
	mov		ebp, esp

; Dereference values pointed at by arr_i / arr_j then store each in the opposite memory address
	mov		eax, arr_i		; eax = @array[i]
	mov		ebx, arr_j		; ebx = @array[j]
	mov		eax, [eax]
	mov		ebx, [ebx]		
	; put the value that was in @array[j] into array[i] and vice-versa
	mov		[arr_i], ebx		; array[i] = array[j]
	mov		[arr_j], eax		; array[j] = array[i]
	
; Clean up stack and return
	pop		ebp
	ret		8
; +------------------------------------------------------------+
exchange ENDP
; +------------------------------------------------------------+


; +------------------------------------------------------------+
displayMedian PROC
; Description:	Displays the median value in a sorted array
;	If odd, goes to middle index. If even, average of two in mid
; Receives:		array (reference), request (value)
; Returns:		None
; Pre:			Array must be in sorted order or results bogus
; Reg Changed:	eax, ebx, edx, edi
; +------------------------------------------------------------+
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp + 8]	; edi <- @array

; divide request by 2 (request is odd) or the "right" middle value (if request even)
	mov		eax, [ebp + 12]    ; eax <- request
	mov		ebx, 2		; coincidentally we can check edx to see if even, and eax if not to get the index to use
	mov		edx, 0
	div		ebx

; Multiply by 4 (DWORD is 4 bytes) and we get the correct offset. Normally we'd add one to get a midpoint but counting
; starts at zero for arrays. This handles finding the middle of an odd-sized array
	mov		ebx, 4
	mov		edx, 0
	mul		ebx
	add		edi, eax	; edi now references array[request/2]

; Check to see if the request size was even or not. TODO: Refactor to add a local to store from our earlier division
	mov		eax, [ebp + 12]    ; eax <- request
	mov		ebx, 2		
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	jnz		ODD_SIZE ; if not even, our value in edi is fine - go print it

; else array size is even -> calculate the average of [edi] and [edi - 4]
	mov		eax, [edi]
	sub		edi, 4
	add		eax, [edi]
	div		ebx			; eax now holds the average of the middle two values
; check the remainder... if != 0, then the average is x.5, so add 1 to result to round up
	cmp		edx, 0
	jz		NO_ROUND
	inc		eax
NO_ROUND:
	jmp		PRINT_RESULT

ODD_SIZE:
	mov		eax, [edi]

PRINT_RESULT:
	mov		edx, [ebp + 16]		
	call	WriteString		; "The median is: "
	call	WriteDec
	call	CrLf

; Clean up stack and return
	pop		ebp
	ret		12
; +------------------------------------------------------------+
displayMedian ENDP
; +------------------------------------------------------------+


; +------------------------------------------------------------+
displayList PROC
; Description:	Prints an array 10 values per row with a title
; Receives:		array (reference), request (value), title (reference)
; Returns:		None
; Pre:			None
; Reg Changed:	
; +------------------------------------------------------------+
	push	ebp
	mov		ebp, esp

; Local variable to count how many items printed on row so far	
	sub		esp, 4
	mov		DWORD PTR [ebp - 4], 0

; Print header
	mov		edx, [ebp + 16]
	call	WriteString
	call	CrLf

; Print the values (10 per row)
	mov		edi, [ebp + 8]
	mov		ecx, [ebp + 12]
PRINT_VALS:	
	mov		eax, [edi]
	call	WriteDec
	add		edi, 4

; Print newline if this is the 10th item
	inc		DWORD PTR [ebp - 4]
	mov		eax, DWORD PTR [ebp - 4]
	mov		ebx, 10
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	jz		PRINT_NEW_LINE
; If not the 10th item, print a tab
	mov		al, 09d	; tab
	call	WriteChar
	jmp		END_IF_ELSE

PRINT_NEW_LINE:
	call	CrLf
	mov		DWORD PTR [ebp - 4], 0

END_IF_ELSE:
	loop	PRINT_VALS

; Add some whitespace after end
	call	CrLf
	call	CrLf

; Clean up stack and return
	mov		esp, ebp	; remove locals from stack
	pop		ebp
	ret		12
; +------------------------------------------------------------+
displayList ENDP
; +------------------------------------------------------------+


END main


; The below should not compile - tempalte for functions


; +------------------------------------------------------------+
someprocess PROC
; Description:	
;	
; Receives:		
; Returns:		
; Pre:			
; Reg Changed:	
; +------------------------------------------------------------+

	
	ret
; +------------------------------------------------------------+
someprocess ENDP
; +------------------------------------------------------------+







; sortList original attempt ... got too complicated and wasn't working (I think stack was messed up?)

	k_loc EQU DWORD PTR [ebp - 4]
	i_loc EQU DWORD PTR [ebp - 8]
	j_loc EQU DWORD PTR [ebp - 12]
	array_loc EQU DWORD PTR [ebp + 8]
	request_loc EQU DWORD PTR [ebp + 12]

	push	ebp
	mov		ebp, esp
	sub		esp, 12			; make room for local variables
	mov		esi, array_loc	; esi points to the array

; for(k=0; k<request-1; k++)
	mov		k_loc, 0		; k = 0
	mov		ecx, request_loc
	dec		ecx				; ecx = request-1

FOR_OUTER_START:	
;     i = k;
	mov		eax, k_loc
	mov		i_loc, eax

;     for(j=k+1; j<request; j++) {
	mov		eax, k_loc
	inc		eax					
	mov		j_loc, eax			; j = k+1
	mov		edx, request_loc	; edx = request

FOR_INNER_START:

; if(array[j] > array[i]), i = j, otherwise do nothing
	mov		ebx, j_loc   
	shl		ebx, 2				; scale j_loc value by 4
	mov		eax, [esi + ebx]	; eax = array[j]
	mov		ebx, i_loc
	shl		ebx, 2				; scale i_loc value by 4
	mov		ebx, [esi + ebx]	; ebx = array[i]
	cmp		eax, ebx
	jng		NO_UPDATE
; array[j] > array[i], so set i = j;
	mov		eax, j_loc
	mov		i_loc, eax

NO_UPDATE:
	inc		j_loc
	cmp		j_loc, edx
	jl		FOR_INNER_START
; End of inner FOR loop

;        exchange(array[k], array[i]);	
	mov		ebx, j_loc   
	shl		ebx, 2				; scale j_loc value by 4
	mov		eax, esi
	add		eax, ebx			; TODO KEEP WITH THIS TRAIN OF THOUGHT
	push	eax					; push the address of array[k]
	mov		ebx, i_loc
	shl		ebx, 2				; scale i_loc value by 4
	mov		eax, esi			; ebx = array[i]
	add		eax, ebx
	push	eax

	call	exchange

;	pop		ecx		; restore outer loop counter

; increment k and see if k<request-1
	inc		k_loc
	cmp		k_loc, ecx
	jl		FOR_OUTER_START


; Clean up stack and return
	mov		esp, ebp	; remove locals from stack
	pop		ebp
	ret		8
