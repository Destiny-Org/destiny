/**
 * Definitions for DWARF debug infos (v3 to v5)
 *
 * See_Also:
 *  - $(LINK2 https://www.dwarfstd.org/doc/Dwarf3.pdf, DWARFv3 standard)
 *  - $(LINK2 https://www.dwarfstd.org/doc/DWARF4.pdf, DWARFv4 standard)
 *  - $(LINK2 https://www.dwarfstd.org/doc/DWARF5.pdf, DWARFv5 standard)
 * Source: $(DMDSRC backend/_dwarf.d)
 */

module destiny.backend.dwarf;

import destiny.backend.cc;
import destiny.backend.cdef;
import destiny.backend.type;
import destiny.backend.dwarfeh : DwEhTable;

import destiny.common.outbuffer;

public import destiny.backend.dwarfeh : genDwarfEh;
public import destiny.backend.dwarfdbginf : dwarf_initfile, dwarf_termfile, dwarf_initmodule,
    dwarf_termmodule, dwarf_func_start, dwarf_func_term, dwarf_typidx, dwarf_abbrev_code,
    dwarf_regno, dwarf_addrel;
public import destiny.backend.elfobj : elf_dwarf_reftoident;
public import destiny.backend.machobj : mach_dwarf_reftoident, dwarf_eh_frame_fixup;
