/*
EXTRA_ARGS: -gdwarf=5 -main

// upstream issue 22855
DWARF_VERIFY: false
*/

noreturn noret()
{
	assert(0);
}
