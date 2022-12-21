declare void @puts(i8*)

define i32 @main(i32 %argc, i8** %argv ) {
    %filename_ptr = getelementptr i8*, i8** %argv, i8 1
    %filename = load i8*, i8** %filename_ptr
    call void @puts(i8* %filename)
    ret i32 0
}
