// upstream issue 23837
// EXTRA_FILES: imports/mainx23837.c

import imports.mainx23837;

struct TexturePacker
{
	stbrp_context _context;
}

int main()
{
    auto res = TexturePacker();
    return 0;
}
