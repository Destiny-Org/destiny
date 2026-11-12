// upstream dmd issue 20963

void cdind() {
    struct ABC {
        int y;
    } *p;

    {
        struct ABC { int x; } abc;
        abc.x = 1;
    }
}
