// upstream issue 21416

// REQUIRED_ARGS: -betterC

extern(C) void main() {}

extern(C++) interface IEntry {}

extern(C++) class MyEntryInfo : IEntry {}
