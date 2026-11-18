/**
 * Implementation of an 'Optional' type
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/root/optional.d, root/_optional.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/root/optional.d
 *
 */
module destiny.root.optional; @safe:

nothrow:

///
@system unittest // catches AssertError
{
    import core.exception : AssertError;

    Optional!int opt;
    assert( opt.isEmpty());
    assert(!opt.isPresent());
    assert(!opt.hasValue(1));
    assert(!opt.hasValue(2));

    bool caught;
    try
        cast(void) opt.get();
    catch (AssertError)
        caught = true;
    assert(caught);

    opt = Optional!int(1);
    assert(!opt.isEmpty());
    assert( opt.isPresent());
    assert( opt.get() == 1);
    assert( opt.hasValue(1));
    assert(!opt.hasValue(2));
}

/// Optional type that is either `empty` or contains a value of type `T`
extern (C++) struct Optional(T)
{
    /// the value (if present)
    private T value;

    /// whether `value` is set
    private bool present;

  nothrow:

    /// Creates an `Optional` with the given value
    this(T value)
    {
        this.value = value;
        this.present = true;
    }

    // Ctor wrapper for the C++ interface (required by older host compilers)
    /// ditto
    static Optional!T create(T val)
    {
        return Optional!T(val);
    }

    /// Returns: Whether this `Optional` contains a value
    bool isPresent() const
    {
        return this.present;
    }

    /// Returns: Whether this `Optional` does not contain a value
    bool isEmpty() const
    {
        return !this.present;
    }

    /// Returns: The value if present
    inout(T) get() inout
    {
        assert(present);
        return value;
    }

    /// Returns: Whether this `Optional` contains the supplied value
    bool hasValue(const T exp) const
    {
        return present && value == exp;
    }
}
