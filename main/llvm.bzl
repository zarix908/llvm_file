def _llvm_impl(ctx):
    inputs = depset(ctx.files.srcs)

    files = []
    for file in ctx.files.srcs:
        filename = file.basename
        output_file = ctx.actions.declare_file(filename + '.o')
        files.append(output_file)

        args = ctx.actions.args()
        args.add("-o", output_file.path)
        args.add("-filetype", 'obj')
        args.add(file.path)

        ctx.actions.run(
            executable = "/usr/bin/llc",
            inputs = inputs,
            outputs = [output_file],
            arguments = [args]
        )

    return [DefaultInfo(files=depset(files))]

llvm = rule(
    implementation = _llvm_impl,
    attrs = {
        'srcs': attr.label_list(allow_files = ['.ll'])
    }
)