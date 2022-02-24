# Pstring Library.
Pstring library implementation in assembly.

**pstring.s** - contains the library functions:
pstrlen- accepts pstring and return it's length.
replaceChar- accepts pstring and 2 chars, then replace all appearance of the first char accepted in the second char accepted.
pstrijcpy- accepts src pstring, dst pstring, and 2 chars, then copy the substring src[i:j] to dst[i:j].
swapCase- accepts pstring and replace all little English letter with big English letter and the opposite.
pstrijcmp- accepts pstring1, pstring2, and 2 chars, then compare the substrings pstring1[i:j], pstring2[i:j]. Return 1 if pstring1 is bigger lexicographic from pstring 2, -1 if it is the opposite, or 0 if the substrings are equals.

**run_main.s** - contains the main function which accepts from the client 2 strings, their length, and option from the menu, it builds from the data 2 pstrings and sends the pstrings and the option to run_func.

**func_select.s** - contains the function run_func - use switch-case (jump table) in order to go to the option accepts as an argument. The options:
50/60- call pstrlen.
52- accepts 2 chars from the client and calls replaceChar.
53- accepts 2 integers from the client(0-254), which represent start and end indexes and call to pstrijcpy.
54- call swapCase with both pstrings.
55- accepts 2 integers from the client(0-254), which represent start and end indexes and call to pstrijcmp.
