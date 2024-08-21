const std = @import("std");
const url = @import("url.zig");
test "sample1" {
    var values: std.StringHashMap(std.ArrayList([]const u8)) = std.StringHashMap(std.ArrayList([]const u8)).init(std.heap.page_allocator);
    defer values.deinit();

    var name = std.ArrayList([]const u8).init(std.heap.page_allocator);
    try name.append("Ava");

    var friend = std.ArrayList([]const u8).init(std.heap.page_allocator);
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
    var values: std.StringHashMap(std.ArrayList([]const u8)) = std.StringHashMap(std.ArrayList([]const u8)).init(std.heap.page_allocator);
    defer values.deinit();
    try url.parseQuery(&values, text);
    try std.testing.expectEqualStrings("Ava", values.get("name").?.items[0]);
    try std.testing.expectEqualStrings("Jess", values.get("friend").?.items[0]);
    try std.testing.expectEqualStrings("Sarah", values.get("friend").?.items[1]);
    try std.testing.expectEqualStrings("Zoe", values.get("friend").?.items[2]);
}
