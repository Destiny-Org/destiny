/*
Destiny has no legacy mode: scope checking cannot be turned off.
REQUIRED_ARGS: -revert=dip1000
TEST_OUTPUT:
---
Error: revert `-revert=dip1000` is invalid
Revertable language changes listed by -revert=name:
  =all              Enables all available revertable language changes
  =dip25            revert DIP25 changes [DEPRECATED] (DIP25)
  =intpromote       revert integral promotions for unary + - ~ operators
  =dtorfields       don't destruct fields of partially constructed objects
---
*/
void main() {}
