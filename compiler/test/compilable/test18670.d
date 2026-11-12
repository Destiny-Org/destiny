// REQUIRED_ARGS: -preview=dip1000

// upstream issue 18670

void foo() {
    new OVERLAPPED;
}

union OVERLAPPED {
    uint     OffsetHigh;
    uint     Pointer;
}
