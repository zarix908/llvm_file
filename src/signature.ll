@signatures = constant [25 x i8] c"\08\89PNG\0D\0A\1a\0A\04\7fELF\05%PDF-\04\00asm"
@types = constant [79 x i8] c"\04\13\28\35PNG image data\00ELF linux executable\00PDF document\00WebAssembly binary module\00"
@unknown_filetype = constant [18 x i8] c"unknown file type\00"

define i1 @match(i8* %position, [50 x i8]* %data) {
0:
    %len = load i8, i8* %position
    br label %Loop
Loop:
    ; for (uint8_t i = 0; i < len; i++)
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

define i8* @get_type([50 x i8]* %data) {
0:
    %begin_pos = getelementptr [25 x i8], [25 x i8]* @signatures, i32 0, i32 0
    br label %Loop
Loop:
    %pos = phi i8* [ %begin_pos, %0 ], [ %next_pos, %Continue ]

    ; for (int i = 0; i < type_count = 4; i++)
    %i = phi i32 [ 0, %0 ], [ %next_i, %Continue ]
    %next_i = add i32 %i, 1

    %len = load i8, i8* %pos
    %len_with_itself = add i8 %len, 1 
    %next_pos = getelementptr i8, i8* %pos, i8 %len_with_itself

    %match = call i1 @match(i8* %pos, [50 x i8]* %data)
    br i1 %match, label %Break, label %Continue
    Break:
        %type_offset_ptr = getelementptr [79 x i8], [79 x i8]* @types, i32 0, i32 %i
        %type_offset = load i8, i8* %type_offset_ptr
        %type = getelementptr [79 x i8], [79 x i8]* @types, i8 0, i8 %type_offset
        ret i8* %type
    Continue:
        %cond = icmp eq i32 %next_i, 4
        br i1 %cond, label %EndLoop, label %Loop
EndLoop:

    %unknown_type = getelementptr [18 x i8], [18 x i8]* @unknown_filetype, i8 0, i8 0
    ret i8* %unknown_type
}


; wasm only
define i8* @getType([50 x i8]* %data) #0 {
    %ptr = call i8* @get_type([50 x i8]* %data)
    ret i8* %ptr
}

attributes #0 = { "wasm-export-name"="getType" }
