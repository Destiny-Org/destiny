// upstream issue 24760

long f(int e = 0, uint[] optional...) => optional.length;
long f0() => f(); // compiler segfaults
