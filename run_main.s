# 318798782 Roni Oded
            .data
d:  .string    " %d"
s:  .string    " %s"

.text
  .section  .rodata
  .align 8   
.text
      .globl  main
      .type   main, @function  

main:
    pushq   %rbp                 # Save %rbp value.
    movq    %rsp,     %rbp       # Save %rsp value.
    subq    $528,     %rsp       # Allocate bytes on the stack.
    xorl    %eax,     %eax       # Initializng %rax to 0.
    
    # Scanning the first pstring.
    movq    $d,       %rdi       # Move $d to the first argument for scanf.
    movq    %rsp,     %rsi       # Move %rsp to the second argument-there the len will be saved. 
    call    scanf
    xorl    %eax,     %eax       # Initializng %rax to 0.
   
    movq    $s,       %rdi       # Move $s to the first argument for scanf.
    leaq    1(%rsp),  %rsi       # Move the address of %rsp + 1 to the second argument-there the string will be saved. 
    call    scanf
    xorl    %eax,     %eax       # Initializng %rax to 0. 
    movzbq  (%rsp),   %r10       # Move the len to %r10. 
    movb    $0,       1(%rsp, %r10, 1)  # Move \0 to the end of the string.
    
    # Scanning the second pstring.  
    movq    $d,         %rdi     # Move $d to the first argument for scanf.
    leaq    256(%rsp),  %rsi     # Move the address of %rsp + 256 to the second argument-there the len will be saved. 
    call    scanf
    xorl    %eax,       %eax     # Initializng %rax to 0. 
    
    movq    $s,         %rdi     # Move $s to the first argument for scanf.
    leaq    257(%rsp),  %rsi     # Move the address of %rsp + 257 to the second argument-there the string will be saved. 
    call    scanf
    xorl    %eax,      %eax      # Initializng %rax to 0.
    movzbq  256(%rsp), %r10      # Move the len to %r10. 
    movb    $0,       257(%rsp, %r10, 1)  # Move \0 to the end of the string.
    

    # Scanning the selection. 
    movq    $d,        %rdi      # Move $d to the first argument.
    leaq    512(%rsp), %rsi      # Move the address of %rsp + 512 to the second argument in order to save there the selection.
    call    scanf
    xorl    %eax,      %eax      # Initializng %rax to 0.
    
    # Setting arguments for func_select.
    movzbq  512(%rsp), %rdi      # Move the selection to first argument.
    leaq    (%rsp),    %rsi      # Move the address of the first pstring to second argument.
    leaq    256(%rsp), %rdx      # Move the address of the second pstring to third argument.
    call    run_func
    
    addq    $528,     %rsp       # De-allocate bytes on the stack.
    movq    %rbp,     %rsp       # Restore %rsp value.
    popq    %rbp                 # Return %rbp value.
    ret
