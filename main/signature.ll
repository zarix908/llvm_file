@signatures = constant [9 x i8] c"\08\89PNG\0D\0A\1a\0A"
@info = constant [30 x i8] c"PNG image data\00unknown format\00"

define i1 @match(i8* %position, [50 x i8]* %data) {
0:
    %len = load i8, i8* %position
    br label %Loop
Loop:
    %i = phi i8 [ 0, %0 ], [ %next_i, %Continue ]
    %next_i = add i8 %i, 1
    %cond = icmp eq i8 %next_i, %len

    %pos = getelementptr i8, i8* %position, i8 %next_i
    %sign_symbol = load i8, i8* %pos

    %data_symbol_ptr = getelementptr [50 x i8], [50 x i8]* %data, i8 0, i8 %i
    %data_symbol = load i8, i8* %data_symbol_ptr

    %match = icmp eq i8 %data_symbol, %sign_symbol
    br i1 %match, label %Continue, label %Break
    Break:
        ret i1 0
    Continue:  
        br i1 %cond, label %EndLoop, label %Loop
EndLoop:

    ret i1 1
}

define i1 @get_info([50 x i8]* %data) {
    %position = getelementptr [9 x i8], [9 x i8]* @signatures, i32 0, i32 0
    %matched = call i1 @match(i8* %position, [50 x i8]* %data)
    ret i1 %matched
}
