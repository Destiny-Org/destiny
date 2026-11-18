// REQUIRED_ARGS: -O

// upstream issue 14114

@system: import core.volatile;

struct Ports {
    static ubyte B() { return volatileLoad(cast(ubyte *)0x0025); }
    static void B(ubyte value) { volatileStore(cast(ubyte *)0x0025, value); }
}
