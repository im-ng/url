const std = @import("std");
const URL = @import("url.zig");

test "sample1" {
    var values: std.StringHashMap(std.ArrayList([]const u8)) = std.StringHashMap(std.ArrayList([]const u8)).init(std.testing.allocator);
    defer values.deinit();
    var name = std.ArrayList([]const u8).init(std.testing.allocator);
    defer name.deinit();
    try name.append("Ava");

    var friend = std.ArrayList([]const u8).init(std.testing.allocator);
    defer friend.deinit();
    try friend.append("Jess");
    try friend.append("Sarah");
    try friend.append("Zoe");

    try values.put("name", name);
    try values.put("friend", friend);

    try std.testing.expectEqualStrings("Ava", name.getLast());

    const friend1 = values.get("friend").?.items[0];
    const friend2 = values.get("friend").?.items[1];
    const friend3 = values.get("friend").?.items[2];
    try std.testing.expectEqualStrings("Jess", friend1);
    try std.testing.expectEqualStrings("Sarah", friend2);
    try std.testing.expectEqualStrings("Zoe", friend3);

    values.clearAndFree();
}

test "sample2" {
    const text = "name=Ava&friend=Jess&friend=Sarah&friend=Zoe";
    var values: std.StringHashMap(std.ArrayList([]const u8)) = std.StringHashMap(std.ArrayList([]const u8)).init(std.testing.allocator);
    defer values.deinit();
    try URL.parseQuery(&values, text);
    try std.testing.expectEqualStrings("Ava", values.get("name").?.items[0]);
    try std.testing.expectEqualStrings("Jess", values.get("friend").?.items[0]);
    try std.testing.expectEqualStrings("Sarah", values.get("friend").?.items[1]);
    try std.testing.expectEqualStrings("Zoe", values.get("friend").?.items[2]);
}

test "sample3" {
    const text = "https://example.org/?a=1&a=2&b=&=3&&&&";
    var url = URL.init(.{});
    const result = try url.parseUri(text);

    const values = result.values.?;

    const a1 = values.get("a").?.items[0];
    const a2 = values.get("a").?.items[1];
    try std.testing.expectEqual(2, values.get("a").?.items.len);
    try std.testing.expectEqualStrings("1", a1);
    try std.testing.expectEqualStrings("2", a2);

    try std.testing.expectEqualStrings("", values.get("b").?.items[0]);
    const v3 = values.get("").?;
    try std.testing.expectEqual(1, v3.items.len);
    try std.testing.expectEqualStrings("3", v3.items[0]);
}
