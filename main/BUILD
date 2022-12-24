load('//main:llvm.bzl', 'llvm')

cc_binary(
    name = 'main',
    srcs=[':llvm_main'],
    linkopts=['-static']
)

llvm(
    name='llvm_wasm',
    srcs=['signature.ll'],
    arch='wasm32'
)

llvm(
    name='llvm_main',
    srcs=['main.ll', 'file.ll', 'signature.ll'],
    arch='x86-64'
)