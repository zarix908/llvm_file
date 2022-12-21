load('//main:llvm.bzl', 'llvm')

cc_binary(
    name = 'main',
    srcs=[':llvm_main'],
    linkopts=['-static']
)

llvm(
    name='llvm_main',
    srcs=['main.ll']
)