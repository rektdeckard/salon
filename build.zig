const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const salon_mod = b.addModule("salon", .{
        .root_source_file = b.path("lib/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    {
        const exe = b.addExecutable(.{
            .name = "table",
            .root_source_file = b.path("example/table.zig"),
            .target = target,
            .optimize = optimize,
        });
        exe.root_module.addImport("salon", salon_mod);
        b.installArtifact(exe);
    }

    {
        const exe = b.addExecutable(.{
            .name = "style",
            .root_source_file = b.path("example/style.zig"),
            .target = target,
            .optimize = optimize,
        });
        exe.root_module.addImport("salon", salon_mod);
        b.installArtifact(exe);
    }

    {
        const exe = b.addExecutable(.{
            .name = "all",
            .root_source_file = b.path("example/all.zig"),
            .target = target,
            .optimize = optimize,
        });
        exe.root_module.addImport("salon", salon_mod);
        b.installArtifact(exe);
    }

    const lib = b.addStaticLibrary(.{
        .name = "salon",
        .root_source_file = b.path("lib/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("lib/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
