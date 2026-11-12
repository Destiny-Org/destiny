// REQUIRED_ARGS: -wi

// upstream issue 22930

int printf(const char *, ...);
void exit(int);

int main()
{
    switch (1)
    {
	case 2:
	    printf("failed test 22930\n");
	    exit(1);
    }
    return 0;
}
