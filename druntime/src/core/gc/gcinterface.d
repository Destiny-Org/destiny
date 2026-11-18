/**
 * Contains the internal GC interface.
 *
 * Copyright: Copyright Digital Mars 2016.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Walter Bright, Sean Kelly, Jeremy DeHaan
 */

 /*          Copyright Digital Mars 2016.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.gc.gcinterface;

import core.thread.threadbase : ThreadBase;

static import core.memory;
alias BlkAttr = core.memory.GC.BlkAttr;
alias BlkInfo = core.memory.GC.BlkInfo;

alias RootIterator = int delegate(scope int delegate(ref Root) nothrow dg);
alias RangeIterator = int delegate(scope int delegate(ref Range) nothrow dg);


struct Root
{
    void* proot;
    alias proot this;
}

struct Range
{
    void* pbot;
    void* ptop;
    TypeInfo ti; // should be tail const, but doesn't exist for references
    alias pbot this; // only consider pbot for relative ordering (opCmp)
    bool opEquals(const scope Range rhs) const pure nothrow @nogc @safe { return pbot == rhs.pbot; }
}

interface GC
{
    /**
     *
     */
    @system void enable();

    /**
     *
     */
    @system void disable();

    /**
     *
     */
    @system void collect() nothrow;

    /**
     * minimize free space usage
     */
    @system void minimize() nothrow;

    /**
     *
     */
    @system uint getAttr(void* p) nothrow;

    /**
     *
     */
    @system uint setAttr(void* p, uint mask) nothrow;

    /**
     *
     */
    @system uint clrAttr(void* p, uint mask) nothrow;

    /**
     *
     */
    @system void* malloc(size_t size, uint bits, const TypeInfo ti) nothrow;

    /*
     *
     */
    @system BlkInfo qalloc(size_t size, uint bits, const scope TypeInfo ti) nothrow;

    /*
     *
     */
    @system void* calloc(size_t size, uint bits, const TypeInfo ti) nothrow;

    /*
     *
     */
    @system void* realloc(void* p, size_t size, uint bits, const TypeInfo ti) nothrow;

    /**
     * Attempt to in-place enlarge the memory block pointed to by p by at least
     * minsize bytes, up to a maximum of maxsize additional bytes.
     * This does not attempt to move the memory block (like realloc() does).
     *
     * Returns:
     *  0 if could not extend p,
     *  total size of entire memory block if successful.
     */
    @system size_t extend(void* p, size_t minsize, size_t maxsize, const TypeInfo ti) nothrow;

    /**
     *
     */
    @system size_t reserve(size_t size) nothrow;

    /**
     *
     */
    @system void free(void* p) nothrow @nogc;

    /**
     * Determine the base address of the block containing p.  If p is not a gc
     * allocated pointer, return null.
     */
    @system void* addrOf(void* p) nothrow @nogc;

    /**
     * Determine the allocated size of pointer p.  If p is an interior pointer
     * or not a gc allocated pointer, return 0.
     */
    @system size_t sizeOf(void* p) nothrow @nogc;

    /**
     * Determine the base address of the block containing p.  If p is not a gc
     * allocated pointer, return null.
     */
    @system BlkInfo query(void* p) nothrow;

    /**
     * Retrieve statistics about garbage collection.
     * Useful for debugging and tuning.
     */
    core.memory.GC.Stats stats() @safe nothrow @nogc;

    /**
     * Retrieve profile statistics about garbage collection.
     * Useful for debugging and tuning.
     */
    core.memory.GC.ProfileStats profileStats() @safe nothrow @nogc;

    /**
     * add p to list of roots
     */
    @system void addRoot(void* p) nothrow @nogc;

    /**
     * remove p from list of roots
     */
    @system void removeRoot(void* p) nothrow @nogc;

    /**
     *
     */
    @property RootIterator rootIter() @nogc;

    /**
     * add range to scan for roots
     */
    @system void addRange(void* p, size_t sz, const TypeInfo ti) nothrow @nogc;

    /**
     * remove range
     */
    @system void removeRange(void* p) nothrow @nogc;

    /**
     *
     */
    @property RangeIterator rangeIter() @nogc;

    /**
     * run finalizers
     */
    @system void runFinalizers(const scope void[] segment) nothrow;

    /*
     *
     */
    bool inFinalizer() nothrow @nogc @safe;

    /**
     * Returns the number of bytes allocated for the current thread
     * since program start. It is the same as
     * GC.stats().allocatedInCurrentThread, but faster.
     */
    @system ulong allocatedInCurrentThread() nothrow;

    // ARRAY FUNCTIONS
    /**
     * Get the current used capacity of an array block.
     *
     * Note that this is only needed if you are about to change the array used
     * size and need to deal with the memory that is about to go away. For
     * appending or shrinking arrays that have no destructors, you probably
     * don't need this function.
     *
     * Params:
     *   ptr = The pointer to check. This can be an interior pointer, but if it
     *       is beyond the end of the used space, the return value may not be
     *       valid.
     *   atomic = The value is fetched atomically (for shared arrays)
     * Returns:
     *   Current array slice, or null if the pointer does not point to a valid
     *   appendable GC block.
     */
    @system void[] getArrayUsed(void *ptr, bool atomic = false) nothrow;

    /**
     * Expand the array used size in place.
     *
     * Used for appending and expanding the length of the array slice. If the
     * operation can be performed without reallocating, the function succeeds.
     * Newly expanded data is not initialized. Slices that do not point at
     * expandable GC blocks cannot be affected, and this function will always
     * return false.
     *
     * Params:
     *   slice = the slice to attempt expanding in place.
     *   newUsed = the size that should be stored as used.
     *   atomic = if true, the array may be shared between threads, and this
     *   operation should be done atomically.
     * Returns: true if successful.
     */
    bool expandArrayUsed(void[] slice, size_t newUsed, bool atomic = false) nothrow @safe;

    /**
     * Expand the array capacity in place.
     *
     * Used for reserving space that can be used for appending. If the
     * operation can be performed without reallocating, the function succeeds.
     * The used size is not changed. Slices that do not point at expandable GC
     * blocks cannot be affected, and this function will always return zero.
     *
     * Params:
     *   slice = the slice to attempt reserving capacity for.
     *   request = the requested size to expand to. Includes the existing data.
     *      Passing a value less than the current array size will result in no
     *      changes, but will return the current capacity.
     *   atomic = The array may be shared between threads, and this operation
     *      should be done atomically.
     *
     * Returns:
     *   Resulting capacity size or 0 if the operation could not be performed.
     */
    size_t reserveArrayCapacity(void[] slice, size_t request, bool atomic = false) nothrow @safe;

    /**
     * Shrink used space of a slice in place.
     *
     * Unlike the other array functions, the array slice passed in is the
     * target slice, and the existing used space is passed separately. This is
     * to discourage code that ends up with a slice to dangling valid data.
     *
     * If slice.ptr[0 .. existingUsed] does not point to the end of a valid GC
     * appendable slice, then the operation fails.
     *
     * Params:
     *   slice = The proposed valid slice data.
     *   existingUsed = The amount of data in the block (starting at slice.ptr)
     *       that is currently valid in the array. If this amount does not match
     *       the current used size, the operation fails.
     *   atomic = The slice may be shared between threads, and the operation
     *       should be atomic.
     * Returns: true if successful.
     */
    @system bool shrinkArrayUsed(void[] slice, size_t existingUsed, bool atomic = false) nothrow;

    /**
     * Prepare a thread for use with the GC after the GC is initialized. Note
     * that you can register an initThread function to call before the GC is
     * initialized, see core.gc.registry.
     *
     * This function is always called *from* the thread as it is being started,
     * before any static initializers. The thread object parameter may not yet
     * be registered as `ThreadBase.getThis()`, as this is called before that
     * happens.
     */
    @system void initThread(ThreadBase thread) nothrow @nogc;

    /**
     * Clean up any GC related data from the thread before it exits. There is
     * no equivalent of this function as a hook before the GC is initialized.
     * That is, the thread init function called before the GC is initialized
     * (from the registry hook) should assume this function may not be called
     * on termination if the GC is never initialized.
     *
     * This function is only called from a thread that was started from the D
     * runtime, and is terminating. The GC can assume the thread is still in
     * the list of running threads and can be paused for a GC cycle. This is
     * not called for the main thread which initialized the GC.
     */
    @system void cleanupThread(ThreadBase thread) nothrow @nogc;
}
