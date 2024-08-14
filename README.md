# url
The URL features extension package is written in Zig.

### Usage.
```zig
    var url = URL.init(.{});
    const text = "http://example.com/path?query=1&query2=2";
    const result = url.parse(text) catch return;
    try testing.expectEqualStrings("http", result.scheme());
    try testing.expectEqualStrings(
        "example.com",
        result.host(),
    );
    try testing.expectEqualStrings(
        "/path",
        result.path(),
    );
    try testing.expectEqualStrings("query=1&query2=2", result.query());

    var querymap = result.queryMap();
    try testing.expectEqualStrings("1", querymap.get("query").?);
    try testing.expectEqualStrings("2", querymap.get("query2").?);

    if (querymap.get("query3") != null) {
        try testing.expect(false);
    }
```