const std = @import("std");

const ZigBuildUtils = @import("zig-build-utils/build.zig");

pub const BuildUtils = ZigBuildUtils.Module;

pub const Module = @import("src/root.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    try ZigBuildUtils.buildSub(b, b.path("zig-build-utils"), target, optimize);

    const mod = b.addModule("ZigUtils", .{
        .target = target,
        .optimize = optimize,
    });

    const extern_utils = b.dependency("ZigExternUtils", .{
        .target = target,
        .optimize = optimize,
    });

    const misc_utils = b.dependency("ZigMiscUtils", .{
        .target = target,
        .optimize = optimize,
    });

    const text_utils = b.dependency("ZigTextUtils", .{
        .target = target,
        .optimize = optimize,
    });

    const type_utils = b.dependency("ZigTypeUtils", .{
        .target = target,
        .optimize = optimize,
    });

    mod.addImport("ZigExternUtils", extern_utils.module("ZigExternUtils"));
    mod.addImport("ZigMiscUtils", misc_utils.module("ZigMiscUtils"));
    mod.addImport("ZigTextUtils", text_utils.module("ZigTextUtils"));
    mod.addImport("ZigTypeUtils", type_utils.module("ZigTypeUtils"));
}
