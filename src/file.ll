declare i8* @fopen(i8* %filename, i8* %flags)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, i8* %file)

@readonly_flag = constant [2 x i8] c"r\00"

define i1 @read_file(i8* %filename, [50 x i8]* %data) {
    %ro_flag = getelementptr [2 x i8], [2 x i8]* @readonly_flag, i8 0, i8 0
    %file = call i8* @fopen(i8* %filename, i8* %ro_flag)
    %code = ptrtoint i8* %file to i8
    %open_failed = icmp eq i8 %code, 0
    br i1 %open_failed, label %Fail, label %Success

Fail:
    ret i1 %open_failed

Success:
    %data_ptr = getelementptr [50 x i8], [50 x i8]* %data, i8 0, i8 0
    call i64 @fread(i8* %data_ptr, i64 1, i64 50, i8* %file)
    ret i1 %open_failed
}