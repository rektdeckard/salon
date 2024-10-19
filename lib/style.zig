const std = @import("std");
const util = @import("util.zig");

pub const Color = union(enum) {
    @"4": Color4,
    rgb: ColorRGB,
};

pub const Color4 = enum(u7) {
    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    blue = 34,
    magenta = 35,
    cyan = 36,
    white = 37,
    default = 39,
    bright_black = 90,
    bright_red = 91,
    bright_green = 92,
    bright_yellow = 93,
    bright_blue = 94,
    bright_magenta = 95,
    bright_cyan = 96,
    bright_white = 97,
};

pub const ColorRGB = struct {
    r: u8,
    g: u8,
    b: u8,

    pub fn eql(self: @This(), other: @This()) bool {
        return std.meta.eql(ColorRGB, self, other);
    }
};

pub const Style = struct {
    const _reset = "\x1b[0m";
    const _bold = "\x1b[1m";
    const _dim = "\x1b[2m";
    const _italic = "\x1b[3m";
    const _underline = "\x1b[4m";
    const _blink_slow = "\x1b[5m";
    const _blink_fast = "\x1b[6m";
    const _reverse = "\x1b[7m";
    const _hidden = "\x1b[8m";
    const _strike = "\x1b[9m";
    const _black = "\x1b[30m";
    const _red = "\x1b[31m";
    const _green = "\x1b[32m";
    const _yellow = "\x1b[33m";
    const _blue = "\x1b[34m";
    const _magenta = "\x1b[35m";
    const _cyan = "\x1b[36m";
    const _white = "\x1b[37m";
    const _bg_black = "\x1b[40m";
    const _bg_red = "\x1b[41m";
    const _bg_green = "\x1b[42m";
    const _bg_yellow = "\x1b[43m";
    const _bg_blue = "\x1b[44m";
    const _bg_magenta = "\x1b[45m";
    const _bg_cyan = "\x1b[46m";
    const _bg_white = "\x1b[47m";

    allocator: std.mem.Allocator = std.heap.page_allocator,
    fg: []const u8 = "",
    bg: []const u8 = "",
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strike: bool = false,

    pub const Printable = struct {
        data: []const u8,
        pub fn format(self: Printable, comptime _: std.fmt.Format, writer: anytype) !void {
            try writer.print("{s}", .{self.data});
        }
    };

    pub fn init(options: struct {
        allocator: std.mem.Allocator = std.heap.page_allocator,
        fg: []const u8 = "",
        bg: []const u8 = "",
        bold: bool = false,
        dim: bool = false,
        italic: bool = false,
        underline: bool = false,
        blink: bool = false,
        reverse: bool = false,
        hidden: bool = false,
        strike: bool = false,
    }) Style {
        return Style{
            .allocator = options.allocator,
            .fg = options.fg,
            .bg = options.bg,
            .bold = options.bold,
            .dim = options.dim,
            .italic = options.italic,
            .underline = options.underline,
            .blink = options.blink,
            .reverse = options.reverse,
            .hidden = options.hidden,
            .strike = options.strike,
        };
    }

    pub fn text(self: *const Style, input: []const u8) Printable {
        return Printable{ .data = self.format(input) };
    }

    pub fn format(self: Style, input: []const u8) []const u8 {
        const total_length = self.fg.len + self.bg.len + input.len + _reset.len;
        var result = self.allocator.alloc(u8, total_length) catch {
            return &[_]u8{};
        };

        @memcpy(result[0..self.fg.len], self.fg);
        @memcpy(result[self.fg.len..(self.fg.len + self.bg.len)], self.bg);
        @memcpy(result[(self.fg.len + self.bg.len)..(self.fg.len + self.bg.len + input.len)], input);
        @memcpy(result[(self.fg.len + self.bg.len + input.len)..], _reset);

        return result;
    }

    pub fn begin(self: *const Style) []const u8 {
        const total_length = self.fg.len + self.bg.len;
        var result = self.allocator.alloc(u8, total_length) catch {
            return &[_]u8{};
        };

        @memcpy(result[0..self.fg.len], self.fg);
        @memcpy(result[self.fg.len..], self.bg);

        return result;
    }

    pub fn end(_: *const Style) []const u8 {
        return _reset;
    }

    pub fn reset() []const u8 {
        return _reset;
    }

    pub fn black(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = _black,
            .bg = self.bg,
        };
    }

    pub fn onBlack(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = self.fg,
            .bg = _bg_black,
        };
    }

    pub fn red(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = _red,
            .bg = self.bg,
        };
    }

    pub fn onRed(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = self.fg,
            .bg = _bg_red,
        };
    }

    pub fn green(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = _green,
            .bg = self.bg,
        };
    }

    pub fn onGreen(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = self.fg,
            .bg = _bg_green,
        };
    }

    pub fn yellow(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = _yellow,
            .bg = self.bg,
        };
    }

    pub fn onYellow(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = self.fg,
            .bg = _bg_yellow,
        };
    }

    pub fn blue(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = _blue,
            .bg = self.bg,
        };
    }

    pub fn onBlue(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = self.fg,
            .bg = _bg_blue,
        };
    }

    pub fn magenta(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = _magenta,
            .bg = self.bg,
        };
    }

    pub fn onMagenta(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = self.fg,
            .bg = _bg_magenta,
        };
    }

    pub fn cyan(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = _cyan,
            .bg = self.bg,
        };
    }

    pub fn onCyan(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = self.fg,
            .bg = _bg_cyan,
        };
    }

    pub fn white(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = _white,
            .bg = self.bg,
        };
    }

    pub fn onWhite(self: *const Style) Style {
        return Style{
            .allocator = self.allocator,
            .fg = self.fg,
            .bg = _bg_white,
        };
    }
};

test "formats to a string" {
    const t = std.testing;
    var s = Style.init(.{});

    try t.expectEqualDeep(s.black().format("TEST"), "\x1b[30mTEST\x1b[0m");
    try t.expectEqualDeep(s.red().format("TEST"), "\x1b[31mTEST\x1b[0m");
    try t.expectEqualDeep(s.green().format("TEST"), "\x1b[32mTEST\x1b[0m");
    try t.expectEqualDeep(s.yellow().format("TEST"), "\x1b[33mTEST\x1b[0m");
    try t.expectEqualDeep(s.blue().format("TEST"), "\x1b[34mTEST\x1b[0m");
    try t.expectEqualDeep(s.magenta().format("TEST"), "\x1b[35mTEST\x1b[0m");
    try t.expectEqualDeep(s.cyan().format("TEST"), "\x1b[36mTEST\x1b[0m");
    try t.expectEqualDeep(s.white().format("TEST"), "\x1b[37mTEST\x1b[0m");

    try t.expectEqualDeep(s.onBlack().format("TEST"), "\x1b[40mTEST\x1b[0m");
    try t.expectEqualDeep(s.onRed().format("TEST"), "\x1b[41mTEST\x1b[0m");
    try t.expectEqualDeep(s.onGreen().format("TEST"), "\x1b[42mTEST\x1b[0m");
    try t.expectEqualDeep(s.onYellow().format("TEST"), "\x1b[43mTEST\x1b[0m");
    try t.expectEqualDeep(s.onBlue().format("TEST"), "\x1b[44mTEST\x1b[0m");
    try t.expectEqualDeep(s.onMagenta().format("TEST"), "\x1b[45mTEST\x1b[0m");
    try t.expectEqualDeep(s.onCyan().format("TEST"), "\x1b[46mTEST\x1b[0m");
    try t.expectEqualDeep(s.onWhite().format("TEST"), "\x1b[47mTEST\x1b[0m");
}

test "produces printable data" {
    const t = std.testing;
    var b: [128]u8 = undefined;
    var s = Style.init(.{});

    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}", s.black().text("TEST")),
        "\x1b[30mTEST\x1b[0m",
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}", s.red().text("TEST")),
        "\x1b[31mTEST\x1b[0m",
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}", s.green().text("TEST")),
        "\x1b[32mTEST\x1b[0m",
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}", s.yellow().text("TEST")),
        "\x1b[33mTEST\x1b[0m",
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}", s.blue().text("TEST")),
        "\x1b[34mTEST\x1b[0m",
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}", s.magenta().text("TEST")),
        "\x1b[35mTEST\x1b[0m",
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}", s.cyan().text("TEST")),
        "\x1b[36mTEST\x1b[0m"[0..],
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}", s.white().text("TEST")),
        "\x1b[37mTEST\x1b[0m"[0..],
    ));
}

test "can be enabled and disabled" {
    const t = std.testing;
    var b: [128]u8 = undefined;
    var s = Style.init(.{});

    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}TEST{s}", .{ s.black().begin(), s.end() }),
        "\x1b[30mTEST\x1b[0m",
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}TEST{s}", .{ s.red().begin(), s.end() }),
        "\x1b[31mTEST\x1b[0m",
    ));
    try t.expect(std.mem.eql(
        u8,
        try std.fmt.bufPrint(&b, "{s}TEST{s}", .{
            s.green().onBlue().begin(),
            s.end(),
        }),
        "\x1b[32m\x1b[44mTEST\x1b[0m",
    ));
}
