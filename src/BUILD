load('//src:llvm.bzl', 'llvm')

cc_binary(
    name = 'binary',
    srcs=[':llvm_binary'],
    linkopts=['-static']
)

llvm(
    name='llvm_wasm',
    srcs=['signature.ll'],
    arch='wasm32'
)

llvm(
    name='llvm_binary',
    srcs=['main.ll', 'file.ll', 'signature.ll'],
    arch='x86-64'
)