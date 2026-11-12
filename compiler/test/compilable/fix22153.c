// REQUIRED_ARGS: -lib

// upstream dmd issue 22153


static void static_fun();

void (*funcptr)() = &static_fun;

void lib_fun()
{
	static_fun();
}

static void static_fun()
{
}
