/*
ARG_SETS: -revert=?
ARG_SETS: -revert=h
TEST_OUTPUT:
----
Revertable language changes listed by -revert=name:
  =all              Enables all available revertable language changes
  =dip25            revert DIP25 changes [DEPRECATED] (DIP25)
  =dip1000          revert DIP1000 changes (Scoped Pointers) (DIP1000)
  =intpromote       revert integral promotions for unary + - ~ operators
  =dtorfields       don't destruct fields of partially constructed objects
----
*/
