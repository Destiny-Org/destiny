#include "valgrind.h" /*<valgrind/valgrind.h>*/
#include "memcheck.h" /*<valgrind/memcheck.h>*/
#include <stddef.h> /* for size_t */

void _d_valgrind_make_mem_noaccess(const void* addr, size_t len)
{
    VALGRIND_MAKE_MEM_NOACCESS(addr, len);
}

void _d_valgrind_make_mem_undefined(const void* addr, size_t len)
{
    VALGRIND_MAKE_MEM_UNDEFINED(addr, len);
}

void _d_valgrind_make_mem_defined(const void* addr, size_t len)
{
    VALGRIND_MAKE_MEM_DEFINED(addr, len);
}

unsigned _d_valgrind_get_vbits(const void* addr, char* bits, size_t len)
{
    return VALGRIND_GET_VBITS(addr, bits, len);
}

unsigned _d_valgrind_set_vbits(const void* addr, char* bits, size_t len)
{
    return VALGRIND_SET_VBITS(addr, bits, len);
}

void _d_valgrind_disable_addr_reporting_in_range(const void* addr, size_t len)
{
    VALGRIND_DISABLE_ADDR_ERROR_REPORTING_IN_RANGE(addr, len);
}

void _d_valgrind_enable_addr_reporting_in_range(const void* addr, size_t len)
{
    VALGRIND_ENABLE_ADDR_ERROR_REPORTING_IN_RANGE(addr, len);
}

/* A fiber switches to its own stack; registering the stack lets valgrind
 * follow the switch instead of reporting reads on an unknown stack. Outside
 * valgrind these are a few no-op instructions. */
unsigned _d_valgrind_stack_register(const void* start, const void* end)
{
    return VALGRIND_STACK_REGISTER(start, end);
}

void _d_valgrind_stack_deregister(unsigned id)
{
    VALGRIND_STACK_DEREGISTER(id);
}
