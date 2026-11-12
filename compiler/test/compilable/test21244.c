// upstream dmd issue 21244
int z = _Generic(1, int()(int): 3, int: 3);
