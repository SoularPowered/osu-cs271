TITLE Project     (project.asm)

; Author: Shawn S Hillyer
; CS271-400 / Project ID                 Date: 00/00/2016
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data



; (insert variable definitions here)

.code
main PROC

push 5
push 10
pop ebx
pop eax


; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
