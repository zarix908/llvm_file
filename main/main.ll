declare i32 @puts(i8*)
declare i1 @read_file(i8* %filename, [50 x i8]* %data)
declare i1 @get_info([50 x i8]* %data)

@no_such_file_error = constant [22 x i8] c"error: file not found\00" 

define i32 @main(i32 %argc, i8** %argv) {
    %filename_ptr = getelementptr i8*, i8** %argv, i8 1
    %filename = load i8*, i8** %filename_ptr
    %data = alloca [50 x i8]

    %open_failed = call i1 @read_file(i8* %filename, [50 x i8]* %data)
    br i1 %open_failed, label %Fail, label %Success
Fail:
    %error_ptr = getelementptr [22 x i8], [22 x i8]* @no_such_file_error, i8 0, i8 0
    call i32 @puts(i8* %error_ptr)
    ret i32 5
Success:
    %info = call i1 @get_info([50 x i8]* %data)
    %code = zext i1 %info to i32
    ret i32 %code
}
