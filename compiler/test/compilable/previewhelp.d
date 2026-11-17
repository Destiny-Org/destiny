/*
ARG_SETS: -preview=?
ARG_SETS: -preview=h
TEST_OUTPUT:
----
Upcoming language changes listed by -preview=name:
  =all              Enables all available upcoming language changes
  =dip25            implement Sealed References DIP [DEPRECATED] (DIP25)
  =dip1000          implement Scoped Pointers DIP (always enabled in Destiny) [DEPRECATED] (DIP1000)
  =dip1008          implement @nogc Throwable DIP (DIP1008)
  =dip1021          implement Mutable Function Arguments DIP (DIP1021)
  =bitfields        add C-like bitfields (upstream website pull request 3190)
  =fieldwise        use fieldwise comparisons for struct equality (upstream changelog 2.085.0)
  =fixAliasThis     when a symbol is resolved, check alias this scope before going to upper scopes (upstream dmd pull request 8885)
  =rvaluerefparam   enable rvalue arguments to ref parameters (https://gist.github.com/andralex/e5405a5d773f07f73196c05f8339435a)
  =safer            more safety checks by default (https://github.com/WalterBright/documents/blob/38f0a846726b571f8108f6e63e5e217b91421c86/safer.md)
  =nosharedaccess   disable access to shared memory objects (https://github.com/Destiny-Org/destiny/blob/main/spec/const3.dd)
  =in               `in` on parameters means `scope const [ref]` and accepts rvalues (https://github.com/Destiny-Org/destiny/blob/main/spec/function.dd)
  =inclusiveincontracts 'in' contracts of overridden methods must be a superset of parent contract (upstream changelog 2.095.0)
  =fixImmutableConv disallow `void[]` data from holding immutable data (upstream changelog 2.101.0, upstream issue 17148)
  =systemVariables  disable access to variables marked '@system' from @safe code (https://github.com/Destiny-Org/destiny/blob/main/spec/attribute.dd)
  =fastdfa          Fast dataflow analysis engine, experimental
----
*/
