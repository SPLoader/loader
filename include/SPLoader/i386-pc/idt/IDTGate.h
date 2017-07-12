/*
** File: include/SPLoader/i386-pc/idt/IDTGate.h
**
** Author: Brennan Ringey
**
*/

#ifndef _SPLOADER_I386_PC_IDT_IDTGATE_H
#define _SPLOADER_I386_PC_IDT_IDTGATE_H

#ifndef __ASM__

#include <stdint.h>

typedef struct IDTGate_s {

    uint16_t offset_lo;
    uint16_t selector;
    uint16_t flags;
    uint16_t offset_hi;

} IDTGate;

#endif  // __ASM__

#endif