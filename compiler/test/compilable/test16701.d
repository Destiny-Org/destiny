// REQUIRED_ARGS: -Icompilable/imports

// upstream issue 16701
// On Windows, Package.d may be capitalized since the file system is not case sensitive.
version(Windows)
{
	import pkg16701;
}
