#!/usr/bin/env dub
/+dub.sdl:
dependency "dmd:frontend" path="../../.."
+/

// Verify that dmd:frontend links without requiring backend symbols.
// Regression test for upstream dmd issue 23119

import dmd.frontend;

void main()
{
    initDMD();
}
