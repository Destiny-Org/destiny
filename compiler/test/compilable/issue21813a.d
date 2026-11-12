// upstream issue 21813
Target.OS defaultTargetOS()
{
    return Target.OS.linux;
}

struct Target
{
    enum OS { linux }
    OS os = defaultTargetOS();
    void deinitialize() { this = this.init; }
    @property isPOSIX() scope @nogc { }
}
