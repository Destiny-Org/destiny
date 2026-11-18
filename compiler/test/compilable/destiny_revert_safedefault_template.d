/*
REQUIRED_ARGS: -revert=safedefault
*/
// Destiny: with -revert=safedefault, code that a Fate template generates for
// this module (here std.typecons.AutoImplement) follows this module's
// default (@system), not Fate's. Found building dub with Destiny.

import std.typecons : AutoImplement;
import std.traits : isAbstractFunction;

abstract class Base
{
    abstract int f();
    int g() { int* p; p++; return 2; }   // @system under the switch
}

// the generated f() calls the @system g()
template callG(C, alias fun)
{
    enum string callG = "return g();";
}

alias Impl = AutoImplement!(Base, callG, isAbstractFunction);

void use()
{
    Base b = new Impl;
    auto x = b.f();
}
