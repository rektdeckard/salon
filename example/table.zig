const std = @import("std");
const table = @import("salon").table;

pub fn main() !void {
    std.debug.print("----------------------------------------\n", .{});
    std.debug.print("example/table.zig:\n\n", .{});

    const a = std.heap.page_allocator;
    var t = table.Table.init(.{
        .allocator = a,
        .style = .single,
        .padding = .{ 1, 0 },
    });
    t.headers(&[_][]const u8{ "Name", "Age", "Height", "Weight" });
    try t.row(&[_][]const u8{
        "Alice",
        "25",
        "5'7\"",
        "130 lbs",
    });
    try t.row(&[_][]const u8{
        "Bob",
        "30",
        "6'0\"",
        "180 lbs",
    });
    try t.row(&[_][]const u8{
        "Charlie",
        "35",
        "5'11\"",
        "160 lbs",
    });
    try t.row(&[_][]const u8{
        "David",
        "40",
        "5'9\"",
        "150 lbs",
    });
    try t.row(&[_][]const u8{
        "Eve",
        "45",
        "5'5\"",
        "140 lbs",
    });
    try t.print(std.io.getStdErr());
}
