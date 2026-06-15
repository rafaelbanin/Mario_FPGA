.section .text.start
.global _start

_start:
    ldr sp, =__stack_top
    bl main
1:  b 1b
