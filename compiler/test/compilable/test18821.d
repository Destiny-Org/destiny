// upstream issue 18821

align(1) struct epoll_event
{
    void* ptr;
}
template isAllZeroBits(epoll_event value) {}
alias isInitAllZeroBits = isAllZeroBits!(epoll_event.init);

epoll_event e = { null };
