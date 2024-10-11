const std = @import("std");
const salon = @import("salon");
const table = salon.table;
const style = salon.style;

pub fn main() !void {
    std.debug.print("----------------------------------------\n", .{});
    std.debug.print("example/all.zig:\n\n", .{});
    var q = table.Table.init(.{
        .style = .light,
        .padding = .{ 1, 0 },
    });
    var s = style.Style.init(.{});
    q.headers(&[_][]const u8{
        "QTR", "YEAR", "REVENUE", "EXPENSES", "PROFIT",
    });
    try q.row(&[_][]const u8{
        "Q4",
        "2019",
        "$1,693,000",
        "$1,200,000",
        s.black().onGreen().format("+$493,000"),
    });
    try q.row(&[_][]const u8{
        "Q1",
        "2020",
        s.red().format("$1,004,900"),
        "$1,211,400",
        s.black().onRed().format("-$206,500"),
    });
    try q.row(&[_][]const u8{
        "Q2",
        "2020",
        "$1,980,100",
        s.yellow().format("$2,147,000"),
        s.black().onYellow().format("-$166,900"),
    });
    try q.row(&[_][]const u8{
        "Q3",
        "2020",
        "$2,331,100",
        "$2,010,500",
        s.black().onGreen().format("+$320,600"),
    });
    try q.row(&[_][]const u8{
        "Q4",
        "2020",
        "$2,658,000",
        "$2,101,300",
        s.black().onGreen().format("+$556,700"),
    });
    try q.print(std.io.getStdErr());
}
