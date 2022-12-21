@.str = constant [15 x i8] c"Hello, World!\0A\00"

declare void @printf(i8*)

define i32 @main() {
    %ptr = getelementptr [15 x i8], [15 x i8]* @.str, i64 0, i64 0
    call void @printf(i8* %ptr)
    ret i32 0
}
