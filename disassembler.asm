%include "in_out.asm"


section .data

    registers64 db "0000:rax 0001:rcx 0010:rdx 0011:rbx 0100:rsp 0101:rbp 0110:rsi 0111:rdi 1000:r8 1001:r9 1010:r10 1011:r11 1100:r12 1101:r13 1110:r14 1111:r15 ",0
    registers32 db "0000:eax 0001:ecx 0010:edx 0011:ebx 0100:esp 0101:ebp 0110:esi 0111:edi 1000:r8d 1001:r9d 1010:r10d 1011:r11d 1100:r12d 1101:r13d 1110:r14d 1111:r15d ",0
    registers16 db "0000:ax 0001:cx 0010:dx 0011:bx 0100:sp 0101:bp 0110:si 0111:di 1000:r8w 1001:r9w 1010:r10w 1011:r11w 1100:r12w 1101:r13w 1110:r14w 1111:r15w ",0
    registers8 db "0000:al 0001:cl 0010:dl 0011:bl 0100:ah 0101:ch 0110:dh 0111:bh 1000:r8b 1001:r9b 1010:r10b 1011:r11b 1100:r12b 1101:r13b 1110:r14b 1111:r15b ",0

    opcodes db "11111001:stc 11111000:clc 11111101:std 11111100:cld 0000111100000101:syscall 11000011:ret ",0


    inp db "0100110100001111110000011001001100011110010101010101010101010101"
    str_66 db "66",0
    str_67 db "67",0
    str_4 db "4",0
    str_0f db "0f",0

    check db "11111001",0
section .bss
    temp resb 100
    binary resb 100
    op_1 resb 100
    op_2 resb 100
    command resb 100
    help_reg resb 100

    ;/////////////////
    b_ resb 10
    d_ resb 10
    ;/////////////

    opcode resb 20 
    w resb 10
    mod resb 10
    reg_op resb 10
    r_m resb 10
    disp_data resb 500
    disp_data_name resb 500

    prefix_66 resb 50


    prefix_67 resb 50
    rex_w resb 20
    r resb 20
    x resb 20
    s resb 20

    ss_ resb 40
    inx resb 40
    base resb 40

    base_name resb 40
    index_name resb 40
    base_help resb 50

    disp_size resb 50
    size resb 10 

    disp_start_index resb 4

    save_tmp resb 4


section .text
    global _start 

%macro initialization 0
    push rax
    mov al, "S"

    mov [rex_w], al
    mov byte [rex_w +1], 0

    mov [op_1], al
    mov byte [op_1 +1], 0

    mov [op_2], al
    mov byte [op_2 +1], 0

    mov [b_], al
    mov byte [b_ +1], 0

    mov [disp_data], al
    mov byte [disp_data +1], 0

    mov [disp_data_name], al
    mov byte [disp_data_name +1], 0

    mov [prefix_66], al
    mov byte [prefix_66 +1], 0

    mov [prefix_67], al
    mov byte [prefix_67 +1], 0

    mov [r], al
    mov byte [r +1], 0

    mov [x], al
    mov byte [x +1], 0

    mov [s], al
    mov byte [s +1], 0

    mov [ss_], al
    mov byte [ss_ +1], 0

    mov [inx], al
    mov byte [inx +1], 0

    mov [base], al
    mov byte [base +1], 0

    mov [base_name], al
    mov byte [base_name +1], 0

    mov [index_name], al
    mov byte [index_name +1], 0

    mov [base_help], al
    mov byte [base_help +1], 0

    mov [disp_size], al
    mov byte [disp_size +1], 0

    pop rax
%endmacro
%macro hexToBin 2
; 1 is hex / 2 is where we put binary
    push rax
    push rbx 
    push rcx 
    push rdx 
    push rsi 
    push rdi 


    mov rsi,%1
    mov rdi,%2
    mov rbx,2
    mov rax,0
    mov rcx,4
%%body_htb:
    mov al,[rsi]
    cmp al,0
    je %%end_htb
    cmp al,97
    jge %%letter_htb
    jmp %%digit_htb
%%letter_htb:
    sub al,87
    jmp %%next_htb
%%digit_htb:
    sub al,48
    jmp %%next_htb
%%next_htb:
    cmp rcx,0
    je %%next2_htb
    mov rdx,0
    div rbx
    add dl,48
    dec rcx
    mov [rdi+rcx],dl
    jmp %%next_htb
%%next2_htb:
    mov rcx,4
    inc rsi
    add rdi,4
    jmp %%body_htb
%%end_htb:

    mov byte [rdi],0

    pop rdi 
    pop rsi 
    pop rdx 
    pop rcx 
    pop rbx 
    pop rax

%endmacro 

%macro find_len 1
;1 is a str/ finds the len of the str and returns it in rax(int)
    push r8 

    mov r8, %1
    xor rax, rax
    jmp %%loop1_fl

%%loop1_fl:
    cmp byte [r8], 0
    je %%end_fl 
    inc r8
    inc rax
    jmp %%loop1_fl

%%end_fl:
    pop r8 

%endmacro

%macro binToHex 1
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push rsi
    push rdi

    mov rsi,%1
    mov rdi,%1
%%start_bTH:
    cmp byte [rsi],0
    je %%end_bTH
    mov rax,8
    mov rbx,2
    mov rcx,4
    mov r8,0
%%loop_bTH:
    cmp rcx,0
    je %%after_bTH
    mov dl,[rsi]
    cmp dl,'1'
    je %%add_bTH
    jmp %%next_bTH
%%add_bTH:
    add r8,rax
%%next_bTH:
    dec rcx
    mov rdx,0
    div rbx
    inc rsi
    jmp %%loop_bTH
%%after_bTH:
    cmp r8,10
    jl %%digit_bTH
    add r8,87
    mov byte [rdi],r8b
    inc rdi
    jmp %%start_bTH
%%digit_bTH:
    add r8,48
    mov byte [rdi],r8b
    inc rdi
    jmp %%start_bTH
%%end_bTH:
    mov byte [rdi],0
    pop rdi
    pop rsi
    pop r8
    pop rdx 
    pop rcx 
    pop rbx 
    pop rax 
%endmacro

%macro string_match 2
;if strings were equal then rax=1 // o.w. rax=0
    push r8
    push r9

    mov r8, %1
    mov r9, %2

    find_len r8 
    mov rbx, rax

    find_len r9
    mov rdx, rax

    ;rax is initially 0
    xor rax, rax

    cmp rdx, rbx
    jne %%end_sm

    jmp %%eq_check_sm

%%eq_check_sm:
    inc rdx
    cmp rdx, 0
    je %%eq_sm 
    dec rdx

    mov al, [r8+rdx]
    cmp [r9+rdx], al 
    jne %%miss_match_sm 

    dec rdx 
    jmp %%eq_check_sm

%%eq_sm:
    mov rax,1
    jmp %%end_sm

%%miss_match_sm:
    xor rax, rax
    jmp %%end_sm

%%end_sm:
    pop r9
    pop r10

%endmacro

%macro mov_str 2
;it moves the second str into the first one (it puts 0 at the end)
    push r8
    push r9
    push r10
    push rax

    mov r8, %1
    mov r9, %2

    find_len r9

    xor r10, r10 ;iterator
    inc r10
    inc r10

    jmp %%for_mv

%%for_mv:
    cmp r10, rax
    jg %%end_mv

    mov al, [r9]
    mov [r8], al 

    inc r8
    inc r9
    inc r10

    jmp %%for_mv

%%end_mv:

    pop rax
    pop r10
    pop r9
    pop r8
%endmacro

%macro prefix66 0
    push rax
    mov al, "6"
    mov [prefix_66], al 
    mov [prefix_66+1], al
    mov byte[prefix_66+2], 0
    pop rax
%endmacro

%macro prefix67 0
    push rax
    mov al, "6"
    mov [prefix_67], al 
    mov al,"7"
    mov [prefix_67+1], al
    mov byte[prefix_67+2], 0
    pop rax
%endmacro

%macro find_code 3
;first operand is dictionar string and the second one is reg/command name third is the memory in which we put the result
    push r8
    mov r8, %1

    push r9 
    mov r9, %2

    push rcx
    mov rcx, %3 ;we save the code here

    push r10
    xor r10, r10 ;it iterates on temp

    jmp %%first_for_fc

%%first_for_fc:
    
    mov al, [r8]
    cmp al, ":"
    je %%check_fc ;checking if it is equal to the reg code or not
    mov  [help_reg + r10], al
    inc r8 
    inc r10
    jmp %%first_for_fc

%%check_fc: ;initializes r10 and adds 0 to the end of the string
    mov  byte [help_reg+r10], 0
    xor r10,r10
    jmp %%check2_fc

%%check2_fc:
    mov  al, [r9]
    cmp al, [help_reg+r10]
    jne %%init_fc ;it should add to r8 so that it goes to the next part of dict 
    inc r10
    cmp  byte [help_reg+r10], 0
    je %%check_find_fc ;check if we have colon after r8
    ;inc r10
    inc r9
    jmp %%check2_fc

%%init_fc:
    mov al, [r8]
    cmp al, " "
    je %%init2_fc
    inc r8
    jmp %%init_fc 

%%init2_fc:
    inc r8
    mov r9, %2 ;avval neveshte boodam help_reg2
    xor r10, r10
    jmp %%first_for_fc

%%check_find_fc:
    cmp  byte [r8], ":"
    mov al, [r8]
    jne %%init_fc
    inc r8
    xor r10, r10
    jmp %%founded_fc

%%founded_fc:
    ;r9 equals to the end of the second str // r8 equals to ":" // r10 equals to 0
    cmp  byte [r8]," "
    je %%end_fc
    mov al, [r8]
    mov [rcx+r10],al
    inc r8
    inc r10 
    jmp %%founded_fc 
%%end_fc:
    mov byte [rcx+r10], 0
    pop rcx
    pop r10
    pop r9
    pop r8

%endmacro
first_parse:
    push r8 ;has input
    push r9 ;iterates over input
    push rax
    push r10

    xor r9,r9

    mov r8, inp
    mov al, [r8+r9]
    mov [temp], al 

    inc r9
    mov al, [r8+r9]
    mov [temp+1], al

    mov byte [temp+2],0 

    string_match temp,str_67
    cmp rax,1
    je found_67

    string_match temp,str_66
    cmp rax,1
    je found_66

    ;if we reach this part -> no prefix
    dec r9
    jmp cont_one

found_67:
    mov_str prefix_67, str_67
    jmp check_66

check_66:
    inc r9
    mov al, [r8+r9]
    mov [temp], al 

    inc r9
    mov al, [r8+r9]
    mov [temp+1], al
    mov byte [temp+2],0 

    string_match temp,str_66
    cmp rax,1
    je found_66

    ;if we reach here -> 67 darim vali 66 na
    dec r9
    jmp cont_one


found_66:
    mov_str prefix_66, str_66
    jmp cont_one

cont_one:
    inc r9
    mov al, [r8+r9]
    mov [temp], al 
    mov byte [temp+1], 0

    string_match temp, str_4
    cmp rax,1
    je got_rex

    dec r9
    jmp check_opcode

got_rex:
    inc r9
    mov al,[r8+r9]
    mov [temp], al 
    mov byte [temp+1], 0 

    hexToBin temp, binary 

    mov al, [binary]
    mov [rex_w], al 

    mov al, [binary+1]
    mov [r], al 

    mov al, [binary+2]
    mov [x], al 

    mov al, [binary+3]
    mov [b_], al 

    jmp check_opcode

check_opcode:
    inc r9
    mov al, [r8+r9]
    mov [opcode], al 

    inc r9
    mov al, [r8+r9]
    mov [opcode+1], al
    mov byte [opcode+2],0 

    string_match opcode, str_0f
    jne op2
    
    inc r9
    mov al, [r8+r9]
    mov [opcode+2], al

    inc r9
    mov al, [r8+r9]
    mov [opcode+3], al

    mov byte[opcode+4], 0

    hexToBin opcode, binary

    mov al, [binary+14]
    mov [d_], al 
    mov byte [d_+1], 0

    mov al, [binary+15]
    mov [w], al 
    mov byte [w+1], 0

    mov byte [binary+14], 0

    mov_str opcode, binary

    jmp end_parse
    
op2:
    hexToBin opcode, binary

    mov al, [binary+6]
    mov [d_], al 
    mov byte [d_+1], 0

    mov al, [binary+7]
    mov [w], al 
    mov byte [w+1], 0

    mov byte [binary+7], 0


    mov_str opcode, binary

    jmp end_parse

end_parse:
    inc r9
    mov al, [r8+r9]
    mov [temp], al 

    inc r9
    mov al, [r8+r9]
    mov [temp+1], al
    mov byte [temp+2],0 

    hexToBin temp, binary   

    mov r10, binary

    mov al, [r10]
    mov [mod], al 
    inc r10
    mov al, [r10]
    mov [mod+1], al 
    mov byte [mod+2], 0

    inc r10 
    mov al, [r10]
    mov [reg_op], al 
    inc r10
    mov al, [r10]
    mov [reg_op+1], al 
    inc r10
    mov al, [r10]
    mov [reg_op+2], al 
    mov byte [reg_op], 0

    inc r10
    mov al, [r10]
    mov [r_m], al 
    inc r10
    mov al, [r10]
    mov [r_m+1], al 
    inc r10
    mov al, [r10]
    mov [r_m+2], al 
    mov byte [r_m], 0

    inc r9 ;so [r8+r9] now points to the first characted of disp/data

    ; add inp, r9 ;making inp start from disp/data

    pop r10
    pop rax
    pop r9
    pop r8
    ret
    
_start:
    ; binToHex inp 
    ; mov rsi, inp 
    ; call printString
    ; call newLine

    find_code check,opcodes, temp 

    mov rsi, temp
    call printString
    call newLine




Exit:
    mov rax, 1
    mov rbx, 0 
    int 0x80





