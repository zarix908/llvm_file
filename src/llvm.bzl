def _llvm_impl(ctx):
    inputs = depset(ctx.files.srcs)

    files = []
    for file in ctx.files.srcs:
        filename = file.basename

        ext = None
        if ctx.attr.arch == 'x86-64':
            ext = '.o'
        elif ctx.attr.arch == 'wasm32':
            ext = '.wasm'
        else:
            fail(str(ctx.attr.arch) + " arch isn't supported")

        output_file = ctx.actions.declare_file(filename + ext)
        files.append(output_file)

        args = ctx.actions.args()
        args.add('-o', output_file.path)
        args.add('-filetype', 'obj')
        args.add('-march', ctx.attr.arch)
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
        'srcs': attr.label_list(allow_files = ['.ll'], mandatory=True),
        'arch': attr.string(values=['x86-64', 'wasm32'], mandatory=True)
    }
)