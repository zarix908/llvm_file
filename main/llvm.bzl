def _llvm_impl(ctx):
    inputs = depset(ctx.files.srcs)
    output_file = ctx.actions.declare_file(ctx.label.name + '.o')

    args = ctx.actions.args()
    args.add("-o", output_file.path)
    args.add("-filetype", 'obj')
    args.add(ctx.files.srcs[0])

    ctx.actions.run(
        executable = "/usr/bin/llc",
        inputs = inputs,
        outputs = [output_file],
        arguments = [args]
    )

    return [DefaultInfo(files=depset([output_file]))]

llvm = rule(
    implementation = _llvm_impl,
    attrs = {
        'srcs': attr.label_list(allow_files = ['.ll'])
    }
)