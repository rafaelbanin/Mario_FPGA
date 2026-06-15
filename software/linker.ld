ENTRY(_start)

MEMORY
{
    OCRAM (rwx) : ORIGIN = 0xFFFF0000, LENGTH = 64K
}

SECTIONS
{
    .text : {
        *(.text.start)
        *(.text*)
        *(.rodata*)
    } > OCRAM

    .data : {
        *(.data*)
    } > OCRAM

    .bss : {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    } > OCRAM

    __stack_top = ORIGIN(OCRAM) + LENGTH(OCRAM);
}
