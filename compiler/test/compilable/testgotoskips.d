/*
    Tests to defend against false positives from the goto skips over decl errors
*/
// upstream issue 23271
class A {
        private static A[] active;
        private void test() {
                foreach(a; active) {
                    if(a is this)
                         goto label;
                }
                // used to say Error: `goto` skips declaration of variable `s.A.test.__appendtmp4` at s.d(...)
                active ~= this;
            label:
                return;
        }
}

// upstream dmd issue 18018
int main ()
{
   string[string] aa;
   goto A;               // line 4
   aa["X"] = "Y";        // line 5
A:
   return 0;
}
