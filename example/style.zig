const std = @import("std");
const style = @import("salon").style;

pub fn main() !void {
    std.debug.print("----------------------------------------\n", .{});
    std.debug.print("example/style.zig:\n", .{});
    const s = style.Style.init(.{});

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onRed().format(" BLK "),
            s.red().onRed().format(" RED "),
            s.yellow().onRed().format(" YEL "),
            s.green().onRed().format(" GRN "),
            s.cyan().onRed().format(" CYN "),
            s.blue().onRed().format(" BLU "),
            s.magenta().onRed().format(" MAG "),
            s.white().onRed().format(" WHT "),
        },
    );

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onYellow().format(" BLK "),
            s.red().onYellow().format(" RED "),
            s.yellow().onYellow().format(" YEL "),
            s.green().onYellow().format(" GRN "),
            s.cyan().onYellow().format(" CYN "),
            s.blue().onYellow().format(" BLU "),
            s.magenta().onYellow().format(" MAG "),
            s.white().onYellow().format(" WHT "),
        },
    );

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onGreen().format(" BLK "),
            s.red().onGreen().format(" RED "),
            s.yellow().onGreen().format(" YEL "),
            s.green().onGreen().format(" GRN "),
            s.cyan().onGreen().format(" CYN "),
            s.blue().onGreen().format(" BLU "),
            s.magenta().onGreen().format(" MAG "),
            s.white().onGreen().format(" WHT "),
        },
    );

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onCyan().format(" BLK "),
            s.red().onCyan().format(" RED "),
            s.yellow().onCyan().format(" YEL "),
            s.green().onCyan().format(" GRN "),
            s.cyan().onCyan().format(" CYN "),
            s.blue().onCyan().format(" BLU "),
            s.magenta().onCyan().format(" MAG "),
            s.white().onCyan().format(" WHT "),
        },
    );

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onBlue().format(" BLK "),
            s.red().onBlue().format(" RED "),
            s.yellow().onBlue().format(" YEL "),
            s.green().onBlue().format(" GRN "),
            s.cyan().onBlue().format(" CYN "),
            s.blue().onBlue().format(" BLU "),
            s.magenta().onBlue().format(" MAG "),
            s.white().onBlue().format(" WHT "),
        },
    );

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onMagenta().format(" BLK "),
            s.red().onMagenta().format(" RED "),
            s.yellow().onMagenta().format(" YEL "),
            s.green().onMagenta().format(" GRN "),
            s.cyan().onMagenta().format(" CYN "),
            s.blue().onMagenta().format(" BLU "),
            s.magenta().onMagenta().format(" MAG "),
            s.white().onMagenta().format(" WHT "),
        },
    );

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onWhite().format(" BLK "),
            s.red().onWhite().format(" RED "),
            s.yellow().onWhite().format(" YEL "),
            s.green().onWhite().format(" GRN "),
            s.cyan().onWhite().format(" CYN "),
            s.blue().onWhite().format(" BLU "),
            s.magenta().onWhite().format(" MAG "),
            s.white().onWhite().format(" WHT "),
        },
    );

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onBlack().format(" BLK "),
            s.red().onBlack().format(" RED "),
            s.yellow().onBlack().format(" YEL "),
            s.green().onBlack().format(" GRN "),
            s.cyan().onBlack().format(" CYN "),
            s.blue().onBlack().format(" BLU "),
            s.magenta().onBlack().format(" MAG "),
            s.white().onBlack().format(" WHT "),
        },
    );

    std.debug.print(
        "{s}{s}{s}{s}{s}{s}{s}\n",
        .{
            s.black().onRed().format("R"),
            s.black().onYellow().format("A"),
            s.black().onGreen().format("I"),
            s.black().onCyan().format("N"),
            s.black().onBlue().format("B"),
            s.black().onMagenta().format("O"),
            s.black().onWhite().format("W"),
        },
    );
}
