// upstream dmd issue 21020

shared struct Queue {
    int[int] map;
}

void main() {
    auto queue = Queue();
    (cast(int[int]) queue.map)[1] = 2;
    assert(queue.map[1] == 2);
}
