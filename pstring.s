    # 318798782 Roni Oded
            .data
s:      .string    "invalid input!\n"

.text
	.section	.rodata
.text
    .globl	pstrlen
	.type	pstrlen, @function
    .globl	replaceChar
	.type	replaceChar, @function
    .globl	pstrijcpy
	.type	pstrijcpy @function
    .globl	swapCase
	.type	swapCase, @function
    .globl	pstrijcmp
	.type	pstrijcmp @function


# char pstrlen(Pstring* pstr)
# pstr saved in %rdi.
pstrlen:    
       movzbq    (%rdi),    %rax     # Move the first byte of pstr to %rax cause it represent the size.
       ret 
       
# Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)
# pstr saved in %rdi, oldChar saved in %sil, newChar saved in %dl.
replaceChar:
       # Save the value registers..
       pushq     %r9
       pushq     %r8
       
       movl      $1,       %r10d    # Initialize %r10d to 1 ~ i = 1
       movq      %rdi,     %r11     # Save pstr in %r11.
       call      pstrlen            # Calculate the len of the string.
       movq      %rax,     %r9      # len = pstrlen(pstr)
       cmpq      %r10,     %r9      # Compare i:size
       jl        done1              # If size < i jump to done1.
       loop1:   
           leaq    (%r11, %r10, 1),    %r8    # Save &pstr[i] in %r8
           cmpb    (%r8),              %sil   # Compare pstr[i]:oldChar
           jne     if1                        # If pstr[i]!=oldChar jump to if.
           movb    %dl,                (%r8)  # If pstr[i]==oldChar -> pstr[i] = newChar
           if1:    
               incb    %r10b           # i++
               cmpq    %r10,    %r9    # Compare i:size
               jge     loop1           # If i <= size jump back to loop.
       done1:
           # Restore the value of saved registers.
           popq    %r8
           popq    %r9          
           ret
           
# Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)    
# dst saved in %rdi, src saved in %rsi, i saved in %dl, j saved in %cl.
pstrijcpy:
       pushq     %r14               # Save value of %r14 on the stack.
       pushq     %r15               # Save value of %r15 on the stack.
       pushq     %r8                # Save value of %r8 on the stack.

       # Save arguments on other registers.
       subq      $8,       %rsp     # Allocate 8 byte on the stack for 2 chars.
       movq      %rdi,     %r14     # Save dst in %r14.
       movq      %rsi,     %r11     # Save src in %r11.
       
       # Calculate len of dst.
       call      pstrlen            # Calculate the len of *dst.
       movq      %rax,    (%rsp)    # lenDest = pstrlen(dest)
       
       # Calculate len of src.
       movq      %rsi,     %rdi     # Move src to first argument for pstrlen.
       call      pstrlen            # Calculate the len of *src.
       movq      %rax,     1(%rsp)  # lenSrc = pstrlen(src)
       
       # Check the value of i.
       cmpb      (%rsp),   %dl      # Compare  pstrlen(dest):i
       jae       invalid2           # If i >= pstrlen(dest) jump to print invalid input.
       cmpb      $0,       %dl      # Compare  pstrlen(dest):i
       jb        invalid2           # If i < 0 jump to print invalid input. 
       cmpb      1(%rsp),  %dl      # Compare  pstrlen(src):i
       jae       invalid2           # If i >= pstrlen(src) jump to print invalid input.

       # Check the value of j.
       cmpb      (%rsp),   %cl      # Compare  pstrlen(dest):j
       jae       invalid2           # If j >= pstrlen(dest) jump to print invalid input.
       cmpb      $0,       %cl      # Compare  pstrlen(dest):j
       jb        invalid2           # If j < 0 jump to print invalid input. 
       cmpb      1(%rsp),  %cl      # Compare  pstrlen(src):j
       jae       invalid2           # If j >= pstrlen(src) jump to print invalid input.
       
       movzbq    %cl,      %r15     # Save j in %r15
       movzbq    %dl,      %r10     # Initialize %r10 to i ~ k = i
       cmpb      %r10b,    %r15b    # Compare k:j
       jb        done2              # If j > k jump to done2.
       loop2:   
           movb    1(%r11, %r10, 1),    %r8b             # Save src[k] in %r8b
           movb     %r8b,              1(%r14, %r10, 1)  # dst[k] = src[k]  
      
           incb    %r10b                                # k++
           cmpb    %r10b,              %r15b            # Compare k:j
           jae     loop2                                # If j >= k jump back to loop.
       done2:
           movq    %r14,     %rax   # Move dst in order to return it's value.
           addq    $8,       %rsp   # Return allocated memory.
           popq    %r8              # Return old value to %r8.
           popq    %r15             # Return old value to %r15.
           popq    %r14             # Return old value to %r14.
           ret
       invalid2:
           # Print invalid option.
           xorl    %eax,   %eax     # Initialized %rax to 0.
           movq    $s,     %rdi     # Print invalid input. 
           call    printf  
           xorl    %eax,     %eax   # Initialized %rax to 0.
           jmp     done2        
       
# Pstring* swapCase(Pstring* pstr)    
# pstr saved in %rdi.
swapCase:       
       pushq     %r14               # Save value of %r14 on the stack.
       pushq     %r8                # Save value of %r8 on the stack.
      
       movq      %rdi,     %r10     # Save pstr in %r10.       
       movzbq    (%r10),   %r11     # Save the len of pstr in r11.
       
       movl      $1,       %r14d    # Initialize %r14 to 1 ~ i = 1
       cmpb      %r14b,    %r11b    # Compare i:size
       jb        done3              # If size < i jump to done.
       loop3:   
           movb    (%r10, %r14, 1),    %r8b    # Save pstr[i] in %r8b  -  c
           
           # CheckBounderies
           cmpb    $65,                %r8b    # Compare 65='A' :  c 
           jb      if3                         # If c < 65 so c < 'A' so is not an english letter so jump to if3.
           cmpb    $122,               %r8b    # Compare 122='z' :  c 
           ja      if3                         # If c > 122 so c > 'z' so is not an english letter so jump to if3.
           cmpb    $97,                %r8b    # Compare 97='a' :  c 
           jae     changeToBig                 # If c >= 97 so c >= 'a' and already c <=122='z' as checked before so jump to ChangeToBig
           cmpb    $90,                %r8b    # Compare 90='Z' :  c 
           jbe     changeToLow                 # If c <= 90 so c <= 'Z' and already c >= 65='A' as checked before so jump to ChangeToLow
           jmp    if3                          # If we get here, it does not a big or little english letter so jump to if3.
           changeToLow:
               addb    $32,    %r8b            # The difference between low and big english letters as char is 32 so it is a big letter and i want to swap it to low letter so i add 32.
               jmp    if3                      # Jump to if3 in order to no change to big.
           changeToBig:
               subb    $32,    %r8b            # The difference between low and big english letters as char is 32 so it is a low letter and i want to swap it to low letter so i sub 32.
           if3:
               movb    %r8b,   (%r10, %r14, 1)     # Move c back to the pstring.
               incq    %r14                        # i++
               cmpq    %r14,               %r11    # Compare i:size
               jae     loop3                       # If size >= i jump back to loop.
       done3:
           movq    %r10,     %rax   # Move pstr in order to return it's value.
           popq    %r8              # Return old value to %r8.
           popq    %r14             # Return old value to %r14.
           ret
       
# int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j)       
# pstr1 saved in %rdi, pstr2 saved in %rsi, i saved in %dl, j saved in %cl.
pstrijcmp:
       pushq     %r14               # Save value of %r14 on the stack.
       pushq     %r15               # Save value of %r15 on the stack.
       pushq     %r9                # Save value of %r9 on the stack. 
       
       # Save arguments on registers.
       subq      $8,       %rsp     # Allocate 8 byte on the stack for 2 chars.
       movq      %rdi,     %r14     # Save pstr1 in %r14.
       movq      %rsi,     %r11     # Save pstr2 in %r11.
       
       # Get len of pstr1
       call      pstrlen            # Calculate the len of *pstr1.
       movq      %rax,    (%rsp)    # len1 = pstrlen(pstrlen1)
       
       # Get len of pstr2
       movq      %r11,     %rdi     # Move pstr2 to first argument for pstrlen.
       call      pstrlen            # Calculate the len of *pstr2.
       movq      %rax,     1(%rsp)  # len2 = pstrlen(pstrlen2)
       
       # Check the value of i.
       cmpb      (%rsp),   %dl      # Compare  pstrlen(dest):i
       jae       invalid4           # If i >= pstrlen(dest) jump to print invalid input.
       cmpb      $0,       %dl      # Compare  pstrlen(dest):i
       jb        invalid2           # If i < 0 jump to print invalid input. 
       cmpb      1(%rsp),  %dl      # Compare  pstrlen(src):i
       jae       invalid4           # If i >= pstrlen(src) jump to print invalid input.

       # Check the value of j.
       cmpb      (%rsp),   %cl      # Compare  pstrlen(dest):j
       jae       invalid4           # If j >= pstrlen(dest) jump to print invalid input.
       cmpb      $0,       %cl      # Compare  pstrlen(dest):j
       jb        invalid4           # If j < 0 jump to print invalid input. 
       cmpb      1(%rsp),  %cl      # Compare  pstrlen(src):j
       jae       invalid4           # If j >= pstrlen(src) jump to print invalid input.
       
       movzbq    %cl,      %r15     # Save j in %r15
       movzbq    %dl,      %r10     # Initialize %r10 to i ~ k = i
       cmpb      %r10b,    %r15b    # Compare k:j
       jl        done4              # If j > k jump to done4.
       loop4:   
           movb    1(%r14, %r10, 1),    %r8b             # Save pstr1[i] in %r8b
           movb    1(%r11, %r10, 1),    %r9b             # Save pstr2[i] in %r9b
           cmpb    %r8b,        %r9b    # Compare pstr1[i]:pstr2[i]
           jb      bigger               # If pstr1[i]>pstr2[i] - pstr1 is bigger than pstr2 so jump to bigger.
           cmpb    %r8b,        %r9b    # Compare pstr1[i]:pstr2[i]
           ja      lower                # If pstr1[i]<pstr2[i] - pstr2 is bigger than pstr1 so jump to lower.
           jmp     if4                  # pstr1[i]=pstr2[i] so move to if4 to continue the loop.
           bigger:
               movl    $1,      %eax    # Move 1 to return value.
               jmp     done4
           lower:
               movl    $-1,     %eax    # Move -1 to return value.
               jmp     done4
           if4:
               incb    %r10b            # k++
               cmpb    %r10b,   %r15b   # Compare k:j
               jae     loop4            # If j >= k jump back to loop.
               movl    $0,      %eax    # The sub-string passed the loop so the sub-string are equal - move 0 to return value.
       done4:
           addq    $8,    %rsp    # Return allocated memory.
           popq    %r9            # Return old value to %r9.
           popq    %r15           # Return old value to %r15.
           popq    %r14           # Return old value to %r14.
           ret
       invalid4:
           # Print invalid option.
           xorl    %eax,     %eax   # Initialized %rax to 0.
           movq    $s,       %rdi   # Print invalid input. 
           call    printf  
           xorl    %eax,     %eax   # Initialized %rax to 0.         
           movq    $-2,      %rax   # return value -2 cause this is invalid input.             
           jmp     done4 
          
