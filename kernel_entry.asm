;By making this file the head of my kernel I guarantee the main function
;will be executed before any other functions
[bits 32]
[extern main]
call main
jmp $
