/* This used to not be allowed
 * upstream dmd pull request 20634
 */

struct A
{
    this (ref shared A a) immutable {}
}

struct B
{
    A a;
    this(immutable B b) shared {}
}
