        


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; SCROLL DOWN IF YOU'RE ONLY INTERESTED IN THE ARM CODE ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;    #include <stdio.h>
;
;void dBubbleSort ( int *array , int lengthOfArray )
;{
;    int i , temp , swapped;
;    while (1)
;    {
;        swapped = 0;
;        for ( i = 0; i < lengthOfArray; i++ )
;        {
;            if ( array[i] < array[i+1] )
;            {
;                temp = array[i+1];
;                array[i+1] = array[i];
;                array[i] = temp;
;                swapped = 1;
;            }
;        }
;
;        if ( !swapped )
;        {
;            break;
;        }
;    }
;
;
;    for ( i = 0; i < lengthOfArray; i++ )
;    {
;        printf ( "%d " , array[i] ); // Final check to ensure the array is in descending order
;    }
;}
;
;int main ( int argc , char **argv )
;{
;    int numarr[] = { 25 , 10 , 13 , 9 , 44 , 15 , 6 , 2 , 36 , 42 };
;    dBubbleSort ( numarr , 10 );
;    return 0;
;}    


; The above is the C code implementation which I did earlier today
; Basic descending bubbl sort algorithm which can be found online
; The implementation for the bubble sort is as follows:

;   >Have an infinite loop
;   >Have a flag which will indicate if a value is swapped or not
;   >Do the basic i variable initialisation for a for loop which will have the length of the array as a limit for i
;   >Compare the ith and i+1th values
;   >If array[i] < array[i+1] -> swap the values then set the flag to be one
;   >Keep doing this untill the whole array has been passed through the comparisons by incrementing i
;   >Once a full pass has been done compare the swapped flag and if it is 0 (if no swaps have taken place) then break from the loop

; There are some extra things which you need to do in ARM which I have flagged with "***"
; Also in arm there is no need for a temp variable
; The ARM implementation isnt that robust since I'm using a fixed array length 
; There are probably some redundancies in my code which you can get rid of


; Good Luck with tomorrow and the rest of the exams! - Ammar   
        
        B main

array   DEFW    25 , 10 , 13 , 9 , 44 , 15 , 6 , 2 , 36 , 42 
welcome DEFB "Welcome!\n\0"
space   DEFB " , \0"

        ALIGN

main    MOV R13, #0x100000 ; We need to set where the stack starts from
        ADRL R0 , welcome
        SWI 3
        BL dBubbleSort
        ADRL R1 , array ; Need to load the values in again to print them
        MOV R2 , #10
print   LDR R0 , [R1] , #4
        SWI 4
        ADRL R0 , space
        SWI 3
        SUB R2 , R2 , #1
        CMP R2 , #0 ; A loop counter to ensure we print all 10 elements
        BNE print

        SWI 2


dBubbleSort
        STMFD R13!, { R4, R5, R6, R7, R8, R9, R10, R14 }

whileLoop   
        MOV R4 , #0; This is the swapped flag
        ADRL R5 , array
iLoop   
        MOV R6 , #0; This is the i variable
        MOV R7 , #10; ***This is the length of the array which will be decremented since we don't have C's abstractions
indent
        ADD R8 , R6 , #1; This is the i+1 variable
        LDR R9 , [R5 , R6 LSL #2]; ***Instead of adding continuous increments of 4 and using another register to hold that value to the index like this: [R5] , RX , we can just have the i variable multiplied by 4 (shift bits by 2 to the left) or 2^2 as a better way of seeing it
        CMP R6 , #9
        BEQ contILoop; So we dont get any undefined values since the i+1th value in he case of i being 9 will be 10 and we don't have a value at that index 
        LDR R10 , [R5 , R8 LSL #2]; ***The same applies here
        CMP R9 , R10
        BLT swap

contILoop
        ADD R6 , R6 , #1
        SUB R7 , R7 , #1
        CMP R7 , #0
        BGT indent

        CMP R4 , #0
        BEQ ld
        
        B whileLoop


swap    STR R9 , [R5 , R8 LSL #2]; ***This is what I meant by no need for a temp variable. We alrady have the two vlaues we compared isolated in different registers so we just need to store them at the appropriate position
        STR R10 , [R5 , R6 LSL #2]
        MOV R4 , #1
        B contILoop


ld
        LDMFD R13!, { R4, R5, R6, R7, R8, R9, R10, PC }
