The Redis wire protocol that I want to implement is pretty simple.

# Message Format

Message chunks are separated by CRLF. For brevity in this document I will use a newline to indicate a CRLF.

Redis data chunks are binary safe, and so may contain CRLF inside them. Argument counts, extents, and some replies are not binary safe and may not contain CRLF.

# Request

Request consist of an argument count chunk, followed by a number of arguments. An argument consists of a byte count chunk, followed by a data chunk.

Examples:

```
\*1
$4
PING

\*3
$3
SET
$7
chicken
$4
bok!
```

The argument count is prefixed with a `*` character, and the byte count by `$`.

# Reply

A reply can be of several types, each with its own prefix character. These are:

* Status: `+`
* Error: `-`
* Integer: `:`
* Bulk: `$`
* Multi-bulk: `*`

Examples of each:

```
+PONG

-ERR unknown command 'BOK'

:34

$5
bruk!

*3
$4
bok!
$5
bruk!
$9
buh-kawk!
```

A bulk reply is exactly the same as request argument, and a multi-bulk reply is like a full request.

There is a special case for an invalid/null value for bulk and multi-bulk replies. These are `$-1` and `*-1` respectively.
