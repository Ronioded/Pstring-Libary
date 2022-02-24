    # 318798782 Roni Oded
        .data
s1:  .string    "first pstring length: %d, second pstring length: %d\n"
s2:  .string    "old char: %c, new char: %c, first string: %s, second string: %s\n" 
s3:  .string    "length: %d, string: %s\n"
s4:  .string    "length: %d, string: %s\n"
s5:  .string    "compare result: %d\n"
s6:  .string    "invalid option!\n"
c:   .string    " %c"
d:   .string    " %d"


 .text
	.section	.rodata
.align 8
.L:
    .quad   .L1           # Case 50: go to the block .L1
    .quad   .Ld           # Case 51: go to the block .Ld which represent the default on the switch case.
    .quad   .L2           # Case 52: go to the block .L2
    .quad   .L3           # Case 53: go to the block .L3
    .quad   .L4           # Case 54: go to the block .L4
    .quad   .L5           # Case 55: go to the block .L5
    .quad   .Ld           # Case 56: go to the block .Ld which represent the default on the switch case.
    .quad   .Ld           # Case 57: go to the block .Ld which represent the default on the switch case.
    .quad   .Ld           # Case 58: go to the block .Ld which represent the default on the switch case.
    .quad   .Ld           # Case 59: go to the block .Ld which represent the default on the switch case.
    .quad   .L1           # Case 60: go to the block .L1
 .text
        .globl	run_func
    	.type	run_func, @function  

# void run_func(int selection, Pstring* p1, Pstring* p2).
# selection in %edi, p1 in %rsi, p2 in %rdx.
run_func:
    pushq   %rbp            # Save %rbp value.
    movq    %rsp,  %rbp     # Save %rsp value.
    
    # Save callee-saved registers.
    pushq   %r13
    pushq   %r14
    
    xorl    %eax,  %eax     # Initializing %rax to 0.
    
    # Save arguments on other registers.
    movl    %edi,  %ebx     # Save selection in %ebx.
    subl    $50,   %ebx     # Sub selection by 50 in order to start the switch case from 0 instead of 50.
    movq    %rsi,  %r13     # Save p1 on %r13
    movq    %rdx,  %r14     # Save p2 on %r14

    switch:
        cmpl    $10,    %ebx    # Compare selection to 10.
        ja      .Ld             # If bigger then 10, go to default. If the num is negative, I am looking at him as unsigned so he is a bigger number and for sure above 10.
        jmp     *.L(, %ebx, 8)  # Go to jump_table[selection]
        
        # L1 is the block for selection = 50/60                
        .L1:
            # Check the length of both Pstrings.            
            movq    %r13,    %rdi      # Move p1 to first argument for function pstrlen.
            call    pstrlen            # Call pstrlen
            movq    %rax,    %r10      # Save pstrlen(p1) in %r10.
            
            movq    %r14,    %rdi      # Move p2 to first argument for function pstrlen.
            call    pstrlen            # Call pstrlen
            movq    %rax,    %r11      # Save pstrlen(p2) in %r11.
            
            # Print the results.
            movq    $s1,     %rdi      # Move s1 to first argument for printf.
            movq    %r10,    %rsi      # Move the len of p1 to second argument for printf. 
            movq    %r11,    %rdx      # Move the len of p2 to third argument for printf. 
            call    printf             # Printing both lens of *p1, *p2.
            xorl    %eax,    %eax      # Initializing %rax to 0.

            jmp .Le                    # Jump to end.

        # L2 is the block for selection = 52            
        .L2:    
            subq    $16,     %rsp    # Allocate 16 byte on the stack for 2 chars.

            # Read first char.
            movq    $c,      %rdi    # Move $c to the first argument.
            movq    %rsp,    %rsi    # Move %rsp to the second argument- where the char will be saved. 
            call    scanf
            xorl    %eax,    %eax    # Initializing %rax to 0.

            # Read second char.
            movq    $c,      %rdi    # Move $c to the first argument.
            leaq    1(%rsp), %rsi    # Move %rsp +1 to the second argument- where the char will be saved. 
            call    scanf
            xorl    %eax,    %eax    # Initializing %rax to 0.
           
            # Call replaceChar for p1
            movq    %r13,    %rdi    # Move p1 to first argument.
            movzbq  (%rsp),  %rsi    # Move oldChar to second argument.
            movzbq  1(%rsp), %rdx    # Move newChar to third argument.
            call    replaceChar      # Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)  
            xorl    %eax,    %eax    # Initializing %rax to 0.

            # Call replaceChar for p2
            movq    %r14,    %rdi    # move p2 to first argument.
            movb    (%rsp),  %sil    # move oldChar to second argument.
            movb    1(%rsp), %dl     # move newChar to third argument.
            call    replaceChar      # Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)
            xorl    %eax,    %eax    # Initializing %rax to 0.

            # Print the results.   
            movq    $s2,     %rdi    # Move s2 to first argument for printf.
            movzbq  (%rsp),  %rsi    # Move oldChar to second argument.
            movzbq  1(%rsp), %rdx    # Move newChar to third argument.    
            leaq    1(%r13), %rcx    # Move the string of p1 to fourth argument for printf.
            leaq    1(%r14), %r8     # Move the string of p2 to fifth argument for printf.
            call    printf           # Printing the strings and the chars after the changes.
            xorl    %eax,    %eax    # Initializing %rax to 0.

            addq    $16,     %rsp    # Return allocated memory.
            jmp .Le                  # Jump to end.
        
                                         
        # L3 is the block for selection = 53              
        .L3:    
            subq    $16,     %rsp    # Allocate 8 byte on the stack for 2 chars.

            # Read first number.
            movq    $d,      %rdi    # Move $d to the first argument.
            movq    %rsp,    %rsi    # Move %rsp to the second argument- where the number will be saved. 
            call    scanf
            xorl    %eax,    %eax    # Initializing %rax to 0.

            # Read second number.
            movq    $d,      %rdi    # Move $d to the first argument.
            leaq    4(%rsp), %rsi    # Move %rsp + 4 to the second argument- where the char will be saved. 
            call    scanf
            xorl    %eax,    %eax    # Initializing %rax to 0.
            
            # Call pstrijcpy
            movq    %r13,    %rdi    # First argument - p1
            movq    %r14,    %rsi    # Second argument - p2
            movb    (%rsp),  %dl     # Third argument - first number.
            movb    4(%rsp), %cl     # Fourth argument - second number.
            call    pstrijcpy        # Pstring* pstrijcpy(Pstring* dst(p1), Pstring* src(p2), char i(first num), char j(second num))
            movq    %rax,    %r10    # Save the dest pointer in r10.
            xorl    %eax,    %eax    # Initializing %rax to 0.
            
            # Print for both pstrings.
            movq    $s3,     %rdi    # Move s3 to first argument for printf.
            movzbq  (%r10),  %rsi    # Move the len of dest to second argument for printf.
            leaq    1(%r10), %rdx    # Move the string of dest to third argument.
            call    printf           # Printing s3.
            xorl    %eax,    %eax    # Initializing %rax to 0.

            movq    $s3,     %rdi    # Move s3 to first argument for printf.
            movzbq  (%r14),  %rsi    # Move the len of src to second argument for printf.
            leaq    1(%r14), %rdx    # Move the string of src to third argument.
            call    printf           # Printing s3.
            xorl    %eax,    %eax    # Initializing %rax to 0.

            addq    $16,     %rsp    # Return allocated memory.
            jmp .Le                  # Jump to end.
            
               
        # L4 is the block for selection = 54              
        .L4:
            subq    $16,     %rsp    # allocate 8 byte on the stack for 2 chars.

            # Call swapCase for p1.
            movq    %r13,    %rdi    # move p1 to first argument for function swapCase.
            call    swapCase         # Pstring* swapCase(Pstring* pstr)  
            movq    %rax,    %r13    # save the return address to %r13.
            xorl    %eax,    %eax    # Initializing %rax to 0.

            # Call swapCase for p2.
            movq    %r14,    %rdi    # Move p2 to first argument for function swapCase.
            call    swapCase         # Pstring* swapCase(Pstring* pstr)  
            movq    %rax,    %r14    # Save the return address to %r14.
            xorl    %eax,    %eax    # Initializing %rax to 0.

            # Printing first Pstring after swapCase.
            movq    $s4,     %rdi    # Move s4 to first argument for printf.
            movzbq  (%r13),  %rsi    # Move the length to the second argument for printf.
            leaq    1(%r13), %rdx    # Move the string of p1 to second argument for printf.
            call    printf           # Printing s4 for first string.
            xorl    %eax,    %eax    # Initializing %rax to 0.
            
            # Printing second Pstring after swapCase.
            movq    $s4,     %rdi    # Move s4 to first argument for printf.
            movzbq  (%r14),  %rsi    # Move the length to the second argument for printf.
            leaq    1(%r14), %rdx    # Move the string of p2 to third argument for printf.
            call    printf           # Printing s4 for first string.
            xorl    %eax,    %eax    # Initializing %rax to 0.
            
            addq    $16,     %rsp    # Return allocated memory.
            jmp .Le                  # Jump to end.
        
        # L5 is the block for selection = 55             
        .L5:    
            subq    $16,     %rsp    # Allocate 8 byte on the stack for 2 chars.
            
            # Read first num.
            movq    $d,      %rdi    # Move $d to the first argument.
            movq    %rsp,    %rsi    # Move %rsp to the second argument- where the char will be saved. 
            call    scanf
            xorl    %eax,    %eax    # Initializing %rax to 0.
           
            # Read second num.
            movq    $d,      %rdi    # Move $d to the first argument.
            leaq    4(%rsp), %rsi    # Move (%rsp + 4) to the second argument- where the char will be saved. 
            call    scanf
            xorl    %eax,    %eax    # Initializing %rax to 0.

            # Move arguments for pstrijcmp.
            movq    %r13,    %rdi    # Move p1 to first argument for function pstrijcmp.
            movq    %r14,    %rsi    # Move p2 to second argument for function pstrijcmp.
            movb    (%rsp),  %dl     # Move first num to third argument for function pstrijcmp.
            movb    4(%rsp), %cl     # Move second num to fourth argument for function pstrijcmp.
            call    pstrijcmp        # int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j)

            # Printing the result.
            movq    $s5,    %rdi     # Move s5 to first argument for printf.
            movl    %eax,   %esi     # Move the return value from the function to second argument for printf. 
            call    printf           # Printing s5.
            xorl    %eax,   %eax     # Initializing %rax to 0.
            
            addq    $16,    %rsp     # Return allocated memory.
            jmp     .Le              # Jump to end.
        
        .Ld:
            movq    $s6,    %rdi     # Move s6 to first argument for printf.
            call    printf           # Printing s6. 
            xorl    %eax,   %eax     # Initializing %rax to 0.

        .Le:
            # Return values to saved registers.
            popq    %r14
            popq    %r13
            movq    %rbp,   %rsp     # Restore %rsp value.
            popq    %rbp             # Return %rbp value.
            ret
    
