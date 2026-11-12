/* REQUIRED_ARGS: -defaultlib= -c -O
 */

// upstream issue 23047
version(D_SIMD):
alias long2 = __vector(long[2]);

long2 _mm_srl_epi64 ()
{
    long2 r = void;
    r[0] = 1;
    return r;
}
