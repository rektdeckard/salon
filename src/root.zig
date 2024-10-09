pub const table = @import("table.zig");
pub const style = @import("style.zig");
pub const util = @import("util.zig");

test {
    @import("std").testing.refAllDecls(@This());
}

test "table + style" {
    const std = @import("std");
    const a = std.heap.page_allocator;
    const s = style.Style.init(.{ .allocator = a });
    var t = table.Table.init(.{
        .allocator = a,
        .style = .single,
        .padding = .{ 1, 0 },
    });

    t.headers(&[_][]const u8{
        s.red().format("Name"),
        s.blue().format("Age"),
        s.green().format("Height"),
        s.yellow().format("Weight"),
    });
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
