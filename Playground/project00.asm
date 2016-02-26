TITLE Sort & Find Median     (whatever.asm)

; Author: Jason Goldfine-Middleton
; E-mail: goldfinj@oregonstate.edu
; Course / Project ID: CS 271 Section 400 / Assignment 5             Due Date: 02/28/16
; Description: This program produces an array of random numbers, sorts it, and
;              calculates the median.

INCLUDE Irvine32.inc



.data
matrix   WORD   22 DUP(30 DUP(?))



.code


main PROC

mov   eax, SIZEOF matrix
call writedec


    exit    ; exit to operating system
main ENDP

END main