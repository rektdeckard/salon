const std = @import("std");
const util = @import("util.zig");

pub const TableStyle = union(enum) {
    single: void,
    double: void,
    light: void,
    heavy: void,
    rounded: void,
    ascii: void,
    custom: TableBorder,
};

pub const TableBorder = struct {
    top_left: []const u8,
    top_center: []const u8,
    top_right: []const u8,
    center_left: []const u8,
    center: []const u8,
    center_right: []const u8,
    bottom_left: []const u8,
    bottom_center: []const u8,
    bottom_right: []const u8,
    vertical: []const u8,
    horizontal: []const u8,

    pub fn ascii() TableBorder {
        return TableBorder{
            .top_left = "+",
            .top_center = "+",
            .top_right = "+",
            .center_left = "+",
            .center = "+",
            .center_right = "+",
            .bottom_left = "+",
            .bottom_center = "+",
            .bottom_right = "+",
            .vertical = "|",
            .horizontal = "-",
        };
    }

    pub fn single() TableBorder {
        return TableBorder{
            .top_left = "┌",
            .top_center = "┬",
            .top_right = "┐",
            .center_left = "├",
            .center = "┼",
            .center_right = "┤",
            .bottom_left = "└",
            .bottom_center = "┴",
            .bottom_right = "┘",
            .vertical = "│",
            .horizontal = "─",
        };
    }

    pub fn rounded() TableBorder {
        var s = TableBorder.single();
        s.top_left = "╭";
        s.top_right = "╮";
        s.bottom_left = "╰";
        s.bottom_right = "╯";
        return s;
    }

    pub fn double() TableBorder {
        return TableBorder{
            .top_left = "╔",
            .top_center = "╦",
            .top_right = "╗",
            .center_left = "╠",
            .center = "╬",
            .center_right = "╣",
            .bottom_left = "╚",
            .bottom_center = "╩",
            .bottom_right = "╝",
            .vertical = "║",
            .horizontal = "═",
        };
    }

    pub fn heavy() TableBorder {
        return TableBorder{
            .top_left = "┏",
            .top_center = "┳",
            .top_right = "┓",
            .center_left = "┣",
            .center = "╋",
            .center_right = "┫",
            .bottom_left = "┗",
            .bottom_center = "┻",
            .bottom_right = "┛",
            .vertical = "┃",
            .horizontal = "━",
        };
    }

    pub fn light() TableBorder {
        return TableBorder{
            .top_left = "─",
            .top_center = "─",
            .top_right = "─",
            .center_left = "─",
            .center = "─",
            .center_right = "─",
            .bottom_left = "─",
            .bottom_center = "─",
            .bottom_right = "─",
            .vertical = " ",
            .horizontal = "─",
        };
    }
};

pub const TablePadding = struct { usize, usize };

pub const TableOptions = struct {
    allocator: std.mem.Allocator = std.heap.page_allocator,
    style: TableStyle = TableStyle.single,
    padding: TablePadding = .{ 1, 0 },
};

pub const Table = struct {
    allocator: std.mem.Allocator = undefined,
    columns: []const []const u8 = &[_][]u8{},
    rows: [][]const []const u8 = &[_][][]u8{},
    borders: TableBorder = undefined,
    padding: TablePadding = undefined,

    pub fn init(options: TableOptions) Table {
        return Table{
            .allocator = options.allocator,
            .padding = options.padding,
            .borders = switch (options.style) {
                .single => TableBorder.single(),
                .double => TableBorder.double(),
                .light => TableBorder.light(),
                .heavy => TableBorder.heavy(),
                .rounded => TableBorder.rounded(),
                .ascii => TableBorder.ascii(),
                .custom => options.style.custom,
            },
        };
    }

    pub fn headers(self: *Table, c: []const []const u8) void {
        self.columns = c;
    }

    pub fn row(self: *Table, r: []const []const u8) !void {
        self.rows = try self.allocator.realloc(self.rows, self.rows.len + 1);
        self.rows[self.rows.len - 1] = r;
    }

    // pub fn arow(self: *Table, tuple: anytype) !void {
    //     const tuple_len = @typeInfo(@TypeOf(tuple)).Tuple.fields.len;
    //     var slice: [tuple_len][]const u8 = undefined;
    //     inline for (tuple, 0..) |value, i| {
    //         slice[i] = value;
    //     }
    //     try self.row(slice);
    // }

    pub fn print(self: *Table, f: std.fs.File) !void {
        var writer = std.io.bufferedWriter(f.writer());
        var w = writer.writer();
        defer writer.flush() catch {};

        // Allocate a buffer to store the width of each column
        var cols: usize = self.columns.len;
        for (self.rows) |r| {
            cols = @max(cols, r.len);
        }
        const widths = try self.allocator.alloc(usize, cols);
        @memset(widths, 0);

        // Measure the widths of each column
        for (self.columns, 0..) |cell, i| {
            widths[i] = util.printableLength(cell);
        }
        for (self.rows) |r| {
            for (r, 0..) |cell, i| {
                widths[i] = @max(widths[i], util.printableLength(cell));
            }
        }

        // Print the header top border
        for (0..widths.len) |i| {
            // Leading corner or cross
            if (i == 0) {
                try w.writeAll(self.borders.top_left);
            } else {
                try w.writeAll(self.borders.top_center);
            }
            // Body
            try w.writeBytesNTimes(
                self.borders.horizontal,
                widths[i] + (self.padding[0] * 2),
            );
            // Trailing corner
            if (i == widths.len - 1) {
                try w.writeAll(self.borders.top_right);
            }
        }
        try w.writeAll("\n");

        if (self.columns.len > 0) {
            // Print the header
            for (0..self.padding[1]) |_| {
                for (0..widths.len) |i| {
                    try w.writeAll(self.borders.vertical);
                    try w.writeByteNTimes(' ', widths[i] + self.padding[0] * 2);
                    if (i == self.columns.len - 1) {
                        try w.writeAll(self.borders.vertical);
                    }
                }
                try w.writeAll("\n");
            }
            for (0..widths.len) |i| {
                try w.writeAll(self.borders.vertical);
                if (i > self.columns.len - 1) {
                    try w.writeByteNTimes(' ', widths[i] + self.padding[0] * 2);
                } else {
                    const cell = self.columns[i];
                    try w.writeByteNTimes(' ', self.padding[0]);
                    try w.writeAll(cell);
                    try w.writeByteNTimes(' ', widths[i] - util.printableLength(cell) + self.padding[0]);
                }
                if (i == widths.len - 1) {
                    try w.writeAll(self.borders.vertical);
                }
            }
            try w.writeAll("\n");
            for (0..self.padding[1]) |_| {
                for (0..widths.len) |i| {
                    try w.writeAll(self.borders.vertical);
                    try w.writeByteNTimes(' ', widths[i] + self.padding[0] * 2);
                    if (i == self.columns.len - 1) {
                        try w.writeAll(self.borders.vertical);
                    }
                }
                try w.writeAll("\n");
            }
        }

        if (self.rows.len > 0) {
            if (self.columns.len > 0) {
                // Print the divider
                for (0..widths.len) |i| {
                    // Leading corner or cross
                    if (i == 0) {
                        try w.writeAll(self.borders.center_left);
                    } else {
                        try w.writeAll(self.borders.center);
                    }
                    // Body
                    try w.writeBytesNTimes(
                        self.borders.horizontal,
                        widths[i] + (self.padding[0] * 2),
                    );
                    // Traling corner
                    if (i == widths.len - 1) {
                        try w.writeAll(self.borders.center_right);
                    }
                }
                try w.writeAll("\n");
            }

            // Print the rows
            for (self.rows, 0..) |r, i| {
                for (0..self.padding[1]) |_| {
                    for (0..widths.len) |j| {
                        try w.writeAll(self.borders.vertical);
                        try w.writeByteNTimes(' ', widths[j] + self.padding[0] * 2);
                        if (j == widths.len - 1) {
                            try w.writeAll(self.borders.vertical);
                        }
                    }
                    try w.writeAll("\n");
                }
                for (0..widths.len) |j| {
                    if (j > r.len - 1) {
                        try w.writeAll(self.borders.vertical);
                        try w.writeByteNTimes(' ', widths[j] + self.padding[0] * 2);
                    } else {
                        const cell = r[j];
                        try w.writeAll(self.borders.vertical);
                        try w.writeByteNTimes(' ', self.padding[0]);
                        try w.writeAll(cell);
                        try w.writeByteNTimes(' ', widths[j] - util.printableLength(cell) + self.padding[0]);
                    }
                    if (j == widths.len - 1) {
                        try w.writeAll(self.borders.vertical);
                    }
                }
                try w.writeAll("\n");
                if (i == self.rows.len - 1) {
                    for (0..self.padding[1]) |_| {
                        for (0..widths.len) |j| {
                            try w.writeAll(self.borders.vertical);
                            try w.writeByteNTimes(' ', widths[j] + self.padding[0] * 2);
                            if (j == cols - 1) {
                                try w.writeAll(self.borders.vertical);
                            }
                        }
                        try w.writeAll("\n");
                    }
                }
            }
        }

        // Print the bottom border
        for (0..widths.len) |i| {
            // Leading corner or cross
            if (i == 0) {
                try w.writeAll(self.borders.bottom_left);
            } else {
                try w.writeAll(self.borders.bottom_center);
            }
            // Body
            try w.writeBytesNTimes(
                self.borders.horizontal,
                widths[i] + (self.padding[0] * 2),
            );
            // Traling corner
            if (i == widths.len - 1) {
                try w.writeAll(self.borders.bottom_right);
            }
        }
        try w.writeAll("\n");
    }
};
