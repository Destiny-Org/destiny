// PERMUTE_ARGS:
// REQUIRED_ARGS: -D -Dd${RESULTS_DIR}/compilable -o-
// TEST_OUTPUT_FILE: extra-files/ddoc_markdown_links.html
// OUTPUT_FILES: ${RESULTS_DIR}/compilable/ddoc_markdown_links.html
// EXTRA_SOURCES: extra-files/ddoc_minimal.ddoc

/++
# Links

[D Site]: https://github.com/Destiny-Org/destiny 'D lives here'
[unused reference]: https://nowhere.com

A link to [printf].

A link to [the base object][Object].

Not a link because it's an associative array: int[Object].

An inline link to [the D homepage](https://github.com/Destiny-Org/destiny).

A reference link to [the **D** homepage][d site].

Not a reference link because it [links to nothing][nonexistent].

A simple link to [fate].

A slightly less simple link to [fate][].

An image: ![D-Man](https://github.com/Destiny-Org/destiny)
Another image: ![D-Man again][dman-error]

[fate]: <https://github.com/Destiny-Org/fate>
[dman-error]: https://github.com/Destiny-Org/destiny

$(P
    [tour]: https://github.com/Destiny-Org/destiny

    Here's a [reference to the tour][tour] inside a macro.
)
+/
module test.compilable.ddoc_markdown_links;

import core.stdc.stdio;
