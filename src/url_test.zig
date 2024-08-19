const std = @import("std");
const testing = std.testing;
const mem = std.mem;
const Uri = std.Uri;
const ParseError = std.Uri.ParseError;
const StringHashMap = @import("std").StringHashMap;
const URL = @import("url.zig");

test "parseUri 1" {
    var url = URL.init(.{});
    const text = "http://example.com/path?query=1&query2=2";
    const result = url.parseUri(text) catch return;
    try testing.expectEqualStrings("http", result.scheme.?);
    try testing.expectEqualStrings(
        "example.com",
        result.host.?,
    );
    try testing.expectEqualStrings(
        "/path",
        result.path,
    );
    try testing.expectEqualStrings("query=1&query2=2", result.query.?);

    var querymap = result.querymap.?;
    defer querymap.deinit();
    try testing.expectEqualStrings("1", querymap.get("query").?);
    try testing.expectEqualStrings("2", querymap.get("query2").?);

    if (querymap.get("query3") != null) {
        try testing.expect(false);
    }

    // query=1&query2=2

    var qm = URL.parseQuery(result.query.?);
    defer qm.deinit();
    try testing.expectEqualStrings("1", qm.get("query").?);
    try testing.expectEqualStrings("2", qm.get("query2").?);

    if (qm.get("query3") != null) {
        try testing.expect(false);
    }
}
test "parseUri 2" {
    const text = "foo://example.com:8042/over/there?name=ferret#nose";
    var url = URL.init(.{});
    const result = url.parseUri(text) catch return;
    try testing.expectEqualStrings("foo", result.scheme.?);
    try testing.expectEqualStrings(
        "example.com",
        result.host.?,
    );
    try testing.expectEqualStrings(
        "/over/there",
        result.path,
    );
    try testing.expectEqualStrings("name=ferret", result.query.?);
    var qm = url.querymap.?;
    defer qm.deinit();
    try testing.expectEqualStrings("ferret", qm.get("name").?);
    try testing.expectEqualStrings("nose", result.fragment.?);
}

test "url target" {
    const text = "/path?query=1&query2=2";
    const result = Uri.parseAfterScheme("http", text) catch return;
    try testing.expectEqualStrings("/path", result.path.percent_encoded);
    try testing.expectEqualStrings("query=1&query2=2", result.query.?.percent_encoded);
}

test "url parse" {
    const text = "/path?query=1&query2=2";
    var url = URL.init(.{});
    const result = url.parseUrl(text) catch return;
    try testing.expectEqualStrings("/path", result.path);
    try testing.expectEqualStrings("query=1&query2=2", result.query.?);
}

test "RFC example 1" {
    const text = "/over/there?name=ferret#nose";
    var url = URL.init(.{});
    const result = url.parseUrl(text) catch return;
    try testing.expectEqualStrings("/over/there", result.path);
    try testing.expectEqualStrings("name=ferret", result.query.?);
    try testing.expectEqualStrings("nose", result.fragment.?);
}
