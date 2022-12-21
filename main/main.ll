@readonly_flag = constant [2 x i8] c"r\00"

declare i32 @puts(i8*)
declare i8* @fopen(i8* %filename, i8* %flags)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, i8* %file)

define i32 @main(i32 %argc, i8** %argv) {
    %filename_ptr = getelementptr i8*, i8** %argv, i8 1
    %filename = load i8*, i8** %filename_ptr
    %readonly_flag_ptr = getelementptr [2 x i8], [2 x i8]* @readonly_flag, i8 0, i8 0
    %file = call i8* @fopen(i8* %filename, i8* %readonly_flag_ptr)

    %data = alloca [50 x i8]
    %data_ptr = getelementptr [50 x i8], [50 x i8]* %data, i8 0, i8 0
    %count = call i64 @fread(i8* %data_ptr, i64 1, i64 50, i8* %file)
    %last_byte_index = sub i64 %count, 1
    %end_data = getelementptr i8, i8* %data_ptr, i64 %last_byte_index
    store i8 0, i8* %end_data

    call i32 @puts(i8* %data_ptr)

    ret i32 0
}
