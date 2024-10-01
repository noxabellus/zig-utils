const std = @import("std");

pub const Module = @import("src/root.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("ZigUtils", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const build_utils = b.dependency("ZigBuildUtils", .{
        .target = target,
        .optimize = optimize,
    });

    const SnapshotWriter = build_utils.artifact("snapshot-writer");
    const Templater = build_utils.artifact("templater");
    const LibJoiner = build_utils.artifact("libjoiner");
    const HeaderGen = build_utils.namedLazyPath("HeaderGen.zig");

    b.default_step.dependOn(&b.addInstallArtifact(SnapshotWriter, .{}).step);
    b.default_step.dependOn(&b.addInstallArtifact(Templater, .{}).step);
    b.default_step.dependOn(&b.addInstallArtifact(LibJoiner, .{}).step);
    b.default_step.dependOn(&b.addInstallFile(HeaderGen, "HeaderGen.zig").step);


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

    mod.addImport("ZigBuildUtils", build_utils.module("ZigBuildUtils"));
    mod.addImport("ZigExternUtils", extern_utils.module("ZigExternUtils"));
    mod.addImport("ZigMiscUtils", misc_utils.module("ZigMiscUtils"));
    mod.addImport("ZigTextUtils", text_utils.module("ZigTextUtils"));
    mod.addImport("ZigTypeUtils", type_utils.module("ZigTypeUtils"));
}
