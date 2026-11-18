TESTS:=test_hash

include ../common.mak

# issue19332 hashes a struct whose toHash is not const, on purpose
$(ROOT)/test_hash$(DOTEXE): compile_exp='struct HasNonConstToHash has method toHash, however it cannot be called with const(HasNonConstToHash) this.'
