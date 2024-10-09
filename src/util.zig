const std = @import("std");

pub fn repeatBytes(allocator: *std.mem.Allocator, substring: []const u8, n: usize) ![]u8 {
    // Calculate the total length needed for the resulting string
    const total_len = substring.len * n;

    // Allocate a buffer for the resulting string
    var result = try allocator.alloc(u8, total_len);

    // Fill the buffer by repeatedly copying the substring
    var index: usize = 0;
    while (index < total_len) : (index += substring.len) {
        std.mem.copyForwards(u8, result[index .. index + substring.len], substring);
    }

    return result;
}

pub fn printableLength(str: []const u8) usize {
    var length: usize = 0;
    var i: usize = 0;
    while (i < str.len) {
        if (str[i] == '\x1b') {
            if (std.mem.indexOf(u8, str[i..], "m")) |end| {
                i += end + 1;
            } else {
                // If no 'm' is found, treat the rest as printable
                return length + (str.len - i);
            }
        } else {
            length += 1;
            i += 1;
        }
    }
    return length;
}
