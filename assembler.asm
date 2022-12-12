%include "in_out.asm"

section .data
    registers db "rax:0000 rcx:0001 rdx:0010 rbx:0011 rsp:0100 rbp:0101 rsi:0110 rdi:0111 \
eax:0000 ecx:0001 edx:0010 ebx:0011 esp:0100 ebp:0101 esi:0110 edi:0111 \
ax:0000 cx:0001 dx:0010 bx:0011 sp:0100 bp:0101 si:0110 di:0111 \
al:0000 cl:0001 dl:0010 bl:0011 ah:0100 ch:0101 dh:0110 bh:0111 \
r8:1000 r9:1001 r10:1010 r11:1011 r12:1100 r13:1101 r14:1110 r15:1111 \
r8d:1000 r9d:1001 r10d:1010 r11d:1011 r12d:1100 r13d:1101 r14d:1110 r15d:1111 \
r8w:1000 r9w:1001 r10w:1010 r11w:1011 r12w:1100 r13w:1101 r14w:1110 r15w:1111 \
r8b:1000 r9b:1001 r10b:1010 r11b:1011 r12b:1100 r13b:1101 r14b:1110 r15b:1111 ",0

    zeroOperands db "stc:11111001 clc:11111000 std:11111101 cld:11111100 syscall:0000111100000101 ret:11000011 ",0
    oneOperands_reg db "inc:1111111 dec:1111111 neg:1111011 not:1111011 idiv:1111011 imul:1111011 pop:01011 push:01010 \
call:11101000 ",0

    oneOperands_mem db "inc:1111111 dec:1111111 neg:1111011 not:1111011 idiv:1111011 imul:1111011 pop:10001111 push:11111111 \
call:11111111 ",0

    regOne db "inc:000 dec:001 not:010 neg:011 pop:000 push:110 idiv:111 imul:101 jmp:100 call:010 ",0
    shifts db "shr:101 shl:100 imm_1:1101000 imm_n:1100000 "

        

    regTwo db "add:000 or:001 adc:010 sbb:011 and:100 sub:101 xor:110 cmp:111 shl:100 shr:101 ",0

    reg_reg_opcode db "mov:1000100 add:0000000 adc:0001000 sub:0010100 sbb:0001100  and:0010000  or:0000100 \
xor:0011000 cmp:0011100 test:1000010 xchg:1000011 xadd:000011111100000 imul:0000111110101111 \
bsf:0000111110111100 bsr:0000111110111101 ",0

    mem_reg_opcode db "mov:1000101 add:0000001 adc:0001001 sub:0010101 sbb:0001101 and:0010001 \
or:0000101 xor:0011001 cmp:0011101 test:1000010 xchg:1000011 xadd:000011111100000 imul:000011111010111 \
shl:1101000 shr:1101000 bsf:000011111011110 bsr:000011111011110 ",0

    ; reg1 db "r8", 0
    reg2 db "rdx", 0
    op db "cmp", 0
    start_rex db "0100", 0

    imul_ db "imul", 0
    bsr_ db "bsr", 0
    bsf_ db "bsf", 0
    shl_ db "shl",0
    shr_ db "shr",0
    mov_ db "mov",0
    sub_ db "sub",0
    sbb_ db "sbb",0
    or_ db "or",0
    xadd_ db "xadd",0
    test_ db "test",0

    sixty4 db "64", 0
    eight8 db "8", 0 
    sixteen16 db "16", 0
    thirty_two32 db "32",0

    opcode_imm db "100000", 0
    opcode_imm_sh db "110000",0
    opcode_imm_mov db "1011",0
    opcode_imm_mov64 db "110001",0
    three_zero db "000",0

    space db " ",0
    comma db ",",0
    open_par db "[",0
    plus db "+",0
    star db "*",0
    bp_ db "bp",0
    start_rex_w db "0100",0
    disp_base db "00000000",0
    disp_bp_8 db "00",0
    if_rex db "0",0


    cm1 db "inc",0
    reg1 db "edx", 0
    mem1 db "[eax+ecx]",0
    imm1 db "1"


    byte_ db "BYTE", 0
    qword_ db "QWORD", 0
    dword_ db "DWORD", 0
    word_  db "WORD",0

    imm_1 db "imm_1", 0
    imm_n db "imm_n", 0

    a_00 db "00",0
    a_10 db "10",0
    a_11 db "11",0
    a_20 db "20",0
    a_21 db "21",0
    a_30 db "30",0
    a_31 db "31",0
    a_40 db "40",0

    inp db "sbb QWORD PTR [rbp+rcx*4+0x94],rdx",0

    debug db "debug", 0

    pre67_bin db "01100111",0
    pre66_bin db "01100110",0

    filename db "input.txt",0
    hex_file db "hex.txt",0
    bin_file db "binary.txt",0
    descriptor dq 0
    descriptor_hex dq 0
    descriptor_bin dq 0

section .bss

    ; bin_ans resb 100
    ; hex_ans resb 100

    temp3 resb 100

    zero_op_temp resb 100 
    help_reg resb 100
    code_found resb 200
    temp resb 100
    temp2 resb 100
    reg_size resb 100
    exchange_help resb 100
    reg_code resb 100 ;used in mem to reg 

    op_1 resb 100
    op_2 resb 100
    command resb 100

    ;/////////////////
    b_ resb 10
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
    size resb 10 ;DWORd QWORD ...

    ans resb 100 
    bin_disp resb 100
section .text
    global _start
%macro add_str 2
; concat second str to rhe end of the first one /addds 0 to the end
;if len(first str) == 1 (means its S), we dont consider S 
    push r8
    push r9 
    push r10
    push r11
    push r12
    push rax

    xor r12, r12 ;iterator on the second str

    mov r8, %1
    mov r9, %2

    
    find_len %1
    mov r10, rax ;r9 has the len of the first str
    
    find_len %2
    mov r11, rax ;r11 has the len of the sec str

    ;0 base indexing
    dec r10
    dec r11

    add r8, r10

    cmp r10, 0
    je %%for_as

    inc r8; so now it points to 0 of end str

    jmp %%for_as

%%for_as:
    cmp r12, r11
    jg %%end_as 

    mov al, [r9+r12]
    mov [r8], al 

    inc r8 
    inc r12

    jmp %%for_as

%%end_as:
    mov byte [r8], 0

    pop rax
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
%endmacro

%macro hexToBin 0
    push rax
    push rbx 
    push rcx 
    push rdx 
    push rsi 
    push rdi 


    mov rsi,disp_data
    mov rdi,bin_disp
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

    mov [ans], al
    mov byte [ans +1], 0

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
    je %%check_fc ;checking if it is equal to the reg name or not
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


%macro find_size 2
;1 is register name // 2 is where we return the size(str)
    push r8
    push r9

    mov r8, %1
    mov r9, %2


    ;handling al-bh
    cmp byte [r8+1], "l"
    je %%eight_fs
    cmp byte [r8+1], "h"
    je %%eight_fs

    ;handling eax-edi
    cmp byte [r8], "e"
    je %%thirtytwo_fs

    ;handling r8w-r9w
    mov al,[r8+2]
    cmp al, "w"
    je %%sixteen_fs

    ;handling r10w-r15w
    mov al,[r8+3]
    cmp  al, "w"
    je %%sixteen_fs

    ;handling r8b-r9b
    mov al,[r8+2]
    cmp  al, "b"
    je %%eight_fs

    ;handling r10b-r15b
    mov al,[r8+3]
    cmp  al, "b"
    je %%eight_fs

    ;handling r8d-r9d
    mov al,[r8+2]
    cmp  al, "d"
    je %%thirtytwo_fs

    ;handling r10d-r15d
    mov al,[r8+3]
    cmp  al, "d"
    je %%thirtytwo_fs

    ;handling rax-rdi
    mov al, [r8+1]
    cmp al, "r"
    je %%sixty_four_fs

    mov al,[r8+1]
    cmp al, 48 
    jl %%sixteen_fs

    cmp al, 57
    jg %%sixteen_fs


    ;r8-r15
    jmp %%sixty_four_fs

%%eight_fs:
    mov al, "8"
    mov [r9], al
    mov byte [r9+1],0
    mov al, [r9]
    jmp %%end_fs

%%sixty_four_fs:
    mov al, "6"
    mov [r9], al
    mov al,"4"
    mov [r9+1], al
    mov byte [r9+2],0
    jmp %%end_fs

%%sixteen_fs:
    mov al,"1"
    mov [r9], al
    mov al,"6"
    mov [r9+1], al
    mov byte [r9+2],0
    jmp %%end_fs 

%%thirtytwo_fs:
    mov al,"3"
    mov [r9], al
    mov al,"2"
    mov [r9+1], al
    mov byte [r9+2],0
    jmp %%end_fs
    
%%end_fs:
    pop r9
    pop r8

%endmacro

%macro exchange_str  2
;exchanges first and second params
    push r8
    push r9
    push r10
    push r11
    xor r11, r11

    mov r8, %1
    mov r9, %2
    mov r10, exchange_help

    jmp %%copy_first_es

%%copy_first_es:
;copy the first str into exchange help
    cmp byte [r8+r11], 0
    je %%end_first_es

    mov al, [r8+r11]
    mov [exchange_help+r11], al 

    inc r11
    jmp %%copy_first_es
%%end_first_es:
    mov byte[exchange_help+r11], 0
    xor r11, r11
    jmp %%mov_two_es

%%mov_two_es:
;moving the second string into the first string
    cmp byte[r9+r11], 0
    je %%end_two_es

    mov al, [r9+r11]
    mov [r8+r11], al

    inc r11
    jmp %%mov_two_es
%%end_two_es:
    mov byte[r8+r11], 0
    xor r11, r11
    jmp %%mov_temp_es

%%mov_temp_es:
;moving exchange help into secondstring
    cmp byte[exchange_help+r11], 0
    je %%end_1_es

    mov al, [exchange_help+r11]
    mov [r9+r11], al

    inc r11
    jmp %%mov_temp_es
%%end_1_es:
    mov byte[r9+r11], 0  
    jmp %%end_es

%%end_es:
    pop r11
    pop r10
    pop r9
    pop r8 
%endmacro

%macro str_to_num 1
;1 is a character(which is a number) / turns it into int and returns it in rbx
    push r8

    xor rbx, rbx

    mov r8, %1

    cmp r8, 48
    je %%int_zero

    cmp r8, 49
    je %%int_one

    cmp r8, 50
    je %%int_two

    cmp r8, 51
    je %%int_three

    cmp r8, 52
    je %%int_four

    cmp r8, 53
    je %%int_five

    cmp r8, 54
    je %%int_six

    cmp r8, 55
    je %%int_seven

    cmp r8, 56
    je %%int_eight

    cmp r8, 57
    je %%int_nine

%%int_zero:
    mov rbx, 0
    jmp %%end_stm
%%int_one:
    mov rbx, 1
    jmp %%end_stm
%%int_two:
    mov rbx, 2
    jmp %%end_stm
%%int_three:
    mov rbx, 3
    jmp %%end_stm
%%int_four:
    mov rbx, 4
    jmp %%end_stm
%%int_five:
    mov rbx, 5
    jmp %%end_stm
%%int_six:
    mov rbx, 6
    jmp %%end_stm
%%int_seven:
    mov rbx, 7
    jmp %%end_stm
%%int_eight:
    mov rbx, 8
    jmp %%end_stm
%%int_nine:
    mov rbx, 9
    jmp %%end_stm
%%end_stm:
    pop r8
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


%macro reg_to_reg 3
; 1 is command/ 2 is reg1 / 3 is reg2
    push r8
    push r9 
    push r10
    push r12
    push r13

  

    mov r8, %1
    mov r9, %2
    mov r10, %3

    ;finding the opcode
    mov r13,r8 
    find_code reg_reg_opcode, r13, opcode

    ;cmp word[buffer], "BM"
    mov al,"1"

    mov [w], al 
    mov byte [w+1], 0

    mov [mod], al 
    mov [mod+1], al
    mov byte [mod+2], 0


;moving the code of reg 1 to r/m
    mov r13, r9
    find_code registers, r13, temp 


    mov r12, temp 
    inc r12 ;raqame avvalo hesab naknone

    mov_str r_m, r12


;moving the code of reg 2 to reg/op
    mov r13, r10
    find_code registers, r13, temp2 


    mov r12, temp2
    inc r12 ;raqame avvalo hesab nakone

    mov_str reg_op, r12


;checking rex 

    cmp byte [temp], "1"
    je %%rex_rtr 

    cmp byte [temp2], "1"
    je %%rex_rtr

    mov r13, r9

    ; mov rsi, r13
    ; call printString
    ; call newLine

    find_size r13, temp3
    
    ; cmp word[r11], "64"
    string_match temp3, sixty4
    cmp rax, 1
    je %%rex_rtr

    cmp byte [r9], "r"
    je %%rex_rtr

    jmp %%continue_rtr

%%rex_rtr:
    mov al, [temp]
    mov [b_], al

    mov al, [temp2]
    mov [r], al 

    mov byte [rex_w], "0"
    mov byte [x], "0"

    mov byte [rex_w+1],0
    mov byte [x+1],0


    mov r13, r9
    find_size r13, temp3

    string_match temp3, sixty4
    cmp rax, 1
    je %%change_rex_w_rtr

    jmp %%continue_rtr

%%continue_rtr:

    mov r13, r9
    find_size r13, temp3


    string_match temp3, eight8
    cmp rax, 1
    ; cmp byte[rax], "8"
    je %%change_w_rtr 

    ; cmp word[rax], "64"
    ; je change_rex_w



    string_match temp3, sixteen16
    cmp rax, 1
    ; cmp word[rax], "16"
    je %%prefix66_rtr

    jmp %%continue2_rtr


%%change_w_rtr:
    mov al, "0"
    mov [w], al 
    mov byte [w+1],0
    jmp %%continue2_rtr

%%change_rex_w_rtr:
    mov al, "1"
    mov [rex_w], al 
    mov byte [rex_w+1],0
    jmp %%continue2_rtr

%%prefix66_rtr:
    prefix66
    jmp %%continue2_rtr

%%continue2_rtr:
    string_match bsr_, %1
    cmp rax, 1
    je %%bsr_f_rtr

    string_match bsf_, %1
    cmp rax, 1
    je %%bsr_f_rtr


    string_match imul_, %1
    cmp rax, 1
    je %%bsr_f_rtr

    jmp %%end_rtr


%%bsr_f_rtr:
    mov al, "0"
    mov [w], al 
    mov byte [w+1],0

    ;changinge reg/ops and r/m
    ; mov r11, reg_op
    ; mov reg_op, r_m 
    ; mov r_m, r11
    exchange_str reg_op, r_m

    ;changing r and b
    ; mov byte al, [b_]
    ; mov byte bl, [r]
    ; mov byte [b_], bl
    ; mov byte [r], al
    exchange_str r, b_
    
    jmp %%end_rtr 
%%end_rtr:
    pop r13
    pop r12
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

%macro disp_imm 1
;1 is the string of imm data / displacement
;ans in disp_data
    push r8
    push r9  

    mov r8, %1

    ;now we have the length of the string in rax
    find_len r8
    
    push rax 

    xor rdx, rdx
    mov r11 ,2
    div r11

    pop rax 

    cmp rdx, 0
    jne %%add_zero_di

    jmp %%continue_di


%%add_zero_di:
    dec r8 
    mov byte [r8], "0"
    mov byte [r8+1], "x"
    mov byte [r8+2], "0"
    inc rax ;incr the length of the string
    jmp %%continue_di

%%continue_di:
    ;0 base indexing/ iterate on input
    dec rax 
    dec rax

    xor r9, r9 ;iterate on disp_data(output)

    jmp %%for_loop_di


%%for_loop_di:
    inc rax
    mov bl, [r8+rax]
    cmp bl,120
    je %%end_di

    dec rax
    mov bl, [r8+rax]
    mov byte [disp_data + r9], bl

    inc rax
    inc r9
    mov bl, [r8+rax]
    mov byte [disp_data + r9], bl

    dec rax
    dec rax
    dec rax

    inc r9
    jmp %%for_loop_di

%%end_di:
    mov byte[disp_data + r9], 0
    pop r9
    pop r8
%endmacro


%macro imm_to_reg 3
;1 is command/ 2 is reg 1 / 3 is imd
    push r8
    push r9 
    push r10
    push r12
    push r13

    mov r8, %1
    mov r9, %2
    mov r10, %3

    disp_imm %3

    mov al,"1"

    mov [w], al 
    mov byte [w+1], 0

    mov [mod], al 
    mov [mod+1], al
    mov byte [mod+2], 0

    mov al, "0"
    mov [s], al
    mov byte [s+1], 0

    ; mov r13,r9
    find_code registers, r9, temp 

    mov r12, temp 
    inc r12 ; ke raqame avvalo hesab nakone
    mov_str r_m, r12

    ;finding the size of reg and save it in r11
    find_size r9, temp3


    find_len %3
    ; len 0x ro kam mikonim
    dec rax
    dec rax

    cmp rax, 3
    jge %%continue_itr_1

    cmp rax, 2
    je %%len_two_itr

    ; cmp r11, 8
    string_match temp3, eight8
    cmp rax, 0
    je %%s_one_itr

    jmp %%continue_itr_1

%%len_two_itr:
    cmp byte [r10+2], 56
    jg %%continue_itr_1

    ; cmp r11, 8
    string_match temp3, eight8
    cmp rax,0
    je %%s_one_itr

    jmp %%continue_itr_1

%%s_one_itr:
    mov al, "1"
    mov [s], al
    mov byte [s+1], 0
    jmp %%continue_itr_1 

%%continue_itr_1:
;checking for rex part
    string_match temp3, sixty4
    cmp rax, 1
    je %%rex_itr

    mov r13,r9
    find_code registers, r13, temp 
    cmp byte [temp], "1"
    je %%rex_itr

    cmp byte [r9], "r"
    je %%rex_itr

    jmp %%continue_itr
%%rex_itr:
    mov al, [temp]
    mov [b_], al

    mov byte [rex_w], "0"
    mov byte [x], "0"
    mov byte [r], "0"

    mov byte [rex_w+1],0
    mov byte [x+1],0
    mov byte [r+1],0

    ;we have the size of r9 in r11
    string_match temp3, sixty4
    cmp rax, 1
    je %%change_rex_w_itr

    jmp %%continue_itr

%%continue_itr:

    string_match temp3, eight8
    cmp rax, 1
    je %%change_w_itr

    string_match temp3, sixteen16
    cmp rax, 1
    je %%prefix66_itr

    jmp %%continue2_itr

%%prefix66_itr:
    prefix66
    jmp %%continue2_itr

%%change_w_itr:
    mov al, "0"
    mov [w], al 
    mov byte [w+1],0
    jmp %%continue2_itr

%%change_rex_w_itr:
    mov al, "1"
    mov [rex_w], al 
    mov byte [rex_w+1],0
    jmp %%continue2_itr

%%continue2_itr:
    mov al,"0"
    mov_str opcode, opcode_imm


    find_code regTwo, %1, temp

    mov_str reg_op, temp

    ;nemikhaaad chon too khode dictionaty 3 raqame
    ;vase inke raqame avvalo hesab nakone
    ; inc reg_op

    string_match r8, shl_
    cmp rax,1
    je %%sh_find_itr

    string_match r8, shr_
    cmp rax,1
    je %%sh_find_itr

    string_match r8, mov_
    cmp rax,1
    je %%mov_find_itr

    jmp %%end_itr

%%sh_find_itr:
    mov_str opcode, opcode_imm_sh
    jmp %%end_itr

%%mov_find_itr:
    ;checking if reg is of size 64
    find_size r9, temp3
    string_match temp3, sixty4
    cmp rax,1
    je %%mov_64_itr



    mov byte [s],0
    mov byte [mod],0
    mov byte [r_m],0

    mov_str opcode, opcode_imm_mov

    jmp %%end_itr

%%mov_64_itr:
    mov_str opcode, opcode_imm_mov64

    mov al, "1"
    mov [s], al 
    mov byte [s+1],0
    
    mov_str reg_op, three_zero

    jmp %%end_itr

%%end_itr:
    pop r13
    pop r12
    pop r10
    pop r9
    pop r8
%endmacro

%macro zero_op 1
    push r8
    mov r8, %1
    find_code zeroOperands, r8, zero_op_temp 
    pop r8
%endmacro

%macro one_op_reg 2
; 1 is command / 2 is operand
    push r8
    push r9

    mov r8, %1
    mov r9, %2

    find_code oneOperands_reg, r8, temp 
    mov_str opcode, temp

    find_code regOne, r8, temp 
    mov_str reg_op, temp

    find_code registers, r9, temp 

    mov al, "1"
    mov [mod], al 
    mov [mod+1], al
    mov byte [mod+2], 0

    mov [w], al
    mov byte [w+1], 0

    find_size r9, r11 

    string_match r11, sixteen16
    cmp rax, 1
    je %%prefix66_oor

    string_match r11, eight8
    cmp rax, 1
    je %%zero_w_oor

    string_match r11, sixty4
    cmp rax,1
    je %%rex_oor

    jmp %%continue_oor

%%prefix66_oor:
    prefix66
    jmp %%continue_oor

%%zero_w_oor:
    mov al, "0"
    mov [w], al
    mov byte [w+1], 0
    jmp %%continue_oor

%%continue_oor:
    cmp byte [r9], "r"
    je %%rex_oor

    jmp %%end_oor

%%rex_oor:
    mov al, "0"
    mov [r], al
    mov byte[r],0

    mov al, [temp]
    mov [b_], al 
    mov byte [b_+1], 0

    mov [rex_w], al 
    mov byte [rex_w+1], 0

    mov [x], al 
    mov byte [x+1], 0

    string_match r11, sixty4
    cmp rax,1
    je %%change_rex_w_oor

    jmp %%end_oor

%%change_rex_w_oor:
    mov al, "1"
    mov [rex_w], al 
    mov byte [rex_w+1], 0

    jmp %%end_oor

%%end_oor:
    pop r9
    pop r8

%endmacro


%macro string_searcher 2 
;1 is the whole string / 2 is the substring we want to search(first occurance)
;if found, index in rbx , o.w. rbx = 0 
    push r8
    push r9
    push r10

    mov r8, %1
    mov r9, %2

    xor rbx, rbx

    mov cl, [r9]

    find_len r8 
    ;length of r8 is in rax

    xor r10, r10;the iterator on r8
    dec rax

    jmp %%for_ss

%%for_ss:
    cmp r10, rax
    jg %%end_ss


    cmp [r8+r10], cl
    je %%found_ss

    inc r10
    jmp %%for_ss

%%found_ss:
    mov rbx, r10
    jmp %%end_ss

%%end_ss:
    pop r10
    pop r9
    pop r8
    
%endmacro

%macro extend_disp 0
;khodesh mire az disp_data_name barmidare va size javabo too disp_size
; mirize va code javabo too disp_data mirize
    push rax
    push rbx
    push r13
    push r10

    mov r10, disp_data_name
    find_len disp_data_name
    ; len 0x ro kam mikonim

    sub rax, 2 ;baraye 0x va []

    cmp rax, 3
    jge %%larges_128_m

    cmp rax, 2
    je %%len_two_itr

    ;here means less than 128
    ;r13 is num of bits (python code)
    mov r13, 8

    mov al, "8"
    mov [disp_size], al
    mov byte [disp_size+1], 0

    jmp %%c_2_m

%%len_two_itr:
    cmp byte [r10+2], 56
    jg %%larges_128_m
    mov r13, 8
    
    mov al, "8"
    mov [disp_size], al
    mov byte [disp_size+1], 0


    jmp %%c_2_m

%%larges_128_m:
    mov r13, 32

    mov al, "3"
    mov [disp_size], al
    mov al, "2"
    mov [disp_size+1], al
    mov byte [disp_size+2], 0

    jmp %%c_2_m

%%c_2_m:
    ;disp in disp_data
    disp_imm disp_data_name


    ;len in rax
    find_len disp_data
    ; sub rax, 2 sub nadarim chon disp_imm 0x nemizare 


    cmp r13, 32
    jl %%bit_8

    mov r13, 8 ;ta vaqti len beshe 8 (8*4=32) bayad 0 add konim

    sub r13,rax 

    jmp %%add_zero

%%bit_8:
    mov r13, 2;ta vaqti len beshe 2(2*4=8) bayad 0 ezafe konim

    ; find_len disp_data

    sub r13,rax 
    jmp %%add_zero    

%%add_zero:
    cmp r13,1
    jl %%end_disp_8_32

    find_len disp_data

    ;chon 0 based e nemikhad yeki ziad konim
    mov bl, "0"
    mov [disp_data+rax], bl

    dec r13

    jmp %%add_zero

%%end_disp_8_32:
    pop r10
    pop r13
    pop rbx
    pop rax
%endmacro

%macro rex_set 0
    push rax

    mov al, "0"
    mov [rex_w], al 
    mov byte [rex_w+1], 0

    cmp byte[base_name], "S"
    je %%no_base


    find_code registers, base_name, temp 
    mov al, [temp]
    mov [b_], al 
    mov byte [b_ +1], 0


    cmp byte[index_name], "S"
    je %%no_index


    find_code registers, index_name, temp
    mov al, [temp]
    mov [x], al 
    mov byte [x+1], 0

    cmp byte [reg_code], "S"
    je %%end_r


    mov al, [reg_code]
    mov [r], al 
    mov byte [r+1], 0

    jmp %%end_r

%%no_base:

    find_code registers, index_name, temp 
    mov al, [temp]
    mov [x], al 
    mov byte [x +1], 0


    mov al, "0"
    mov [b_], al
    mov byte[b_+1], 0

    cmp byte[r], "S"
    jne %%end_r

    mov al, "0"
    mov [r], al 
    mov byte[r+1],0
    jmp %%end_r

%%no_index:
    mov al, "0"
    mov [x], al
    mov byte[x+1], 0
    jmp %%end_r

%%end_r:

    pop rax
%endmacro

%macro mem 1
    ;[rdx+rax]
    push r8  ;input
    push r9  ;iteator for input
    push r10 ;used as temporary reg
    push r11 ;used as iterator for temp
    push r12 ;used for inc and dec of memmory
    push r13

    push rax
    push rbx

    mov r10, base_help

    ; mov rsi, w
    ; call printString

    ;initializing
    mov al, "S"
    mov [disp_data_name], al
    mov [base_name], al
    mov [index_name], al
    mov [ss_], al 

;changeee heeree -> changed
    mov r8, %1
    ;initialize r8 before calling this function
    xor r9,r9 ;iterator
    xor r11, r11

    inc r9 ;for '['

    jmp %%first_loop_m

%%first_loop_m:
    mov  al, [r8+r9]

    cmp al, "]"
    je %%end_brack_m

    cmp al, "+"
    je %%base_found_m

    cmp al, "*"
    je %%inx_found_m

    mov  byte [r10+r11], al 
    inc r9
    inc r11
    jmp %%first_loop_m

%%base_found_m:

    ; mov rsi, w
    ; call printString

    inc r11
    mov byte[r10+r11], 0

    cmp byte[base_name], "S"
    jne %%add_inx_third_case_middle

    mov_str base_name, r10

    xor r11, r11 ;reset iterator of temp
    inc r9
    jmp %%first_loop_m

%%inx_found_m:
    inc r11
    mov byte[r10+r11], 0
    mov_str index_name, r10


    inc r9
    mov al, [r8+r9]

    xor r11, r11
    inc r9


    cmp al, "1"
    je %%one_m

    cmp al, "2"
    je %%two_m

    cmp al, "4"
    je %%four_m
    
    cmp al, "8"
    je %%eight_m

%%one_m:
    mov al, "0"
    mov [ss_], al 
    mov [ss_+1], al
    mov byte [ss_+2],0
    jmp %%next_inx
%%two_m:
    mov al, "0"
    mov [ss_], al 
    mov al, "1"
    mov [ss_+1], al
    mov byte[ss_+2],0
    jmp %%next_inx
%%four_m:
    mov al, "1"
    mov [ss_], al 
    mov al, "0"
    mov [ss_+1], al
    mov byte[ss_+2],0
    jmp %%next_inx
%%eight_m:
    mov al, "1"
    mov [ss_], al 
    mov [ss_+1], al
    mov byte[ss_+2],0
    jmp %%next_inx

%%next_inx:
    mov al, [r8+r9]
    cmp al, "+"
    je %%disp_m

    cmp byte [base_name], "S"
    je %%fourth_case

    jne %%fifth_case

%%disp_m:
    inc r9
    mov al, [r8+r9]

    cmp al, "]"
    je %%end_disp_m

    mov [r10+r11], al

    inc r11
    jmp %%disp_m

%%end_disp_m:
    mov_str disp_data_name, r10
    inc r11
    mov byte[r10+r11], 0

    xor r11, r11

    cmp byte [base_name], "S"
    je %%fourth_case

    jmp %%fifth_case

%%piece_left_m: ;comes here after it reads ]
;[esi] / and more

    ; mov rsi, w
    ; call printString

    mov byte [r10+r11],0

    cmp byte[r10],"0"
    je %%disp_left_m

    ;check if [eax+edx]
    cmp byte [base_name], "S"
    jne %%add_inx_third_case

    cmp byte[index_name], "S"
    jne %%fourth_case

    mov_str base_name, r10

    push rax
    mov al, "0"
    mov [mod], al
    mov [mod+1], al
    mov byte [mod+2], 0
    pop rax

    find_code registers, base_name, temp 

   ;inc temp so that it starts at 1st index
    ; inc temp 
    mov r12, temp 
    inc r12

    mov_str r_m, r12
    ; dec temp

    find_size base_name, temp 
    string_match temp, thirty_two32
    cmp rax,1 
    je %%pr67_m

    jmp %%continue_m

%%pr67_m:
    prefix67
    jmp %%continue_m

%%continue_m:
;[esi]
    mov al, [if_rex]
    cmp al, "1"
    je %%rex_m 

    mov r12, base 
    inc r12 

    cmp byte [r12], 57
    jg %%bp_check

    cmp byte [r12], 48
    jl %%bp_check

    dec r12
    cmp byte [r12], "r"
    je %%rex_m 

    jmp %%bp_check

%%rex_m:
;[esi]
    rex_set
    jmp %%bp_check

%%bp_check:
;[esi]
    ; inc base_name 
    mov r12, base_name
    inc r12
    string_match r12, bp_
    ; dec base_name

    cmp rax,1 
    je %%bp_saw

    xor r11, r11
    jmp %%end_brack_m

%%bp_saw:
;[esi]
    push rax
    mov al, "0"
    mov [mod], al 
    mov al, "1"
    mov [mod+1],al
    mov byte [mod+2],0
    pop rax

    mov_str disp_data, disp_base
    jmp %%end_only_base

%%end_only_base:
;[esi]
    xor r11, r11 
    jmp %%end_brack_m

%%disp_left_m:

    mov_str disp_data_name, r10

    cmp byte [base_name], "S"
    jne %%check_case
;[0x5555551E]
    push rax

    mov al, "0"
    ; mod 00
    mov [mod],al
    mov [mod + 1], al
    mov byte [mod + 2], 0

    ;ss 00
    mov [ss_],al
    mov [ss_ + 1], al
    mov byte [ss_ + 2], 0

    ;rm 100
    mov [r_m + 1],al
    mov [r_m + 2], al
    mov byte [r_m + 3], 0

    ;inx 100
    mov [inx + 1],al
    mov [inx + 2], al
    mov byte [inx + 3], 0

    mov [base+1], al

    mov al, "1"
    mov [inx], al 
    mov [r_m], al 

    ;base 101
    mov [base], al 
    mov [base+2], al
    mov byte [base+3],0

    pop rax


    ;checkig if >128 or <128 and puting size in disp_size
    extend_disp


    jmp %%end_only_disp

%%end_only_disp:
;[0x5555551E]
    xor r11, r11 
    jmp %%end_brack_m
%%check_case:
    cmp byte [index_name], "S"
    je %%second_case_m

    cmp byte [ss_], "S"
    je %%third_case

    cmp byte [base_name], "S"
    je %%fourth_case

    jmp %%fifth_case

%%second_case_m:
;[esi+0x51]

    find_code registers, base_name, temp 


    ; inc temp
    mov r12, temp 
    inc r12



    mov_str r_m, r12
    ; dec temp 

    extend_disp

    
    string_match disp_size, eight8
    cmp rax, 1
    je %%eight_disp_2

    jmp %%disp_32_2

%%eight_disp_2:
;[esi+0x51]
    mov al, "0"
    mov [mod], al
    mov al, "1"
    mov [mod+1], al
    mov byte [mod+2],0
    jmp %%check_rex_2

%%disp_32_2:
;[esi+0x51]
    mov al, "1"
    mov [mod], al
    mov al, "0"
    mov [mod+1], al
    mov byte [mod+2],0
    jmp %%check_rex_2

%%check_rex_2:
;[esi+0x51]
    mov r12, base_name
    inc r12

    mov al, [r12]
    ; mov rsi , al
    ; call printString
    ; call newLine

    cmp byte [r12], 57
    jg %%end_2

    cmp byte [r12], 48
    jl %%end_2

    dec r12
    cmp byte [r12], "r"
    je %%rex_m_2

    mov al, [if_rex]
    cmp al, "1"
    je %%rex_m_2


    jmp %%end_2

%%rex_m_2:
;[esi+0x51]
    rex_set
    jmp %%end_2


%%end_2:
;[esi+0x51]
    xor r11, r11 
    jmp %%end_brack_m

%%add_inx_third_case_middle:

    ; mov rsi, w
    ; call printString

    mov_str index_name, r10

    xor r11, r11 ;reset iterator of temp
    inc r9

    jmp %%first_loop_m
%%add_inx_third_case:
;[eax+edx] and [eax+ecx+0x55]
    ; mov rsi, r10
    ; call printString
    ; call newLine

    mov_str index_name, r10

    ; mov rsi, index_name
    ; call printString

    jmp %%third_case
%%third_case:
;[eax+edx] / [eax+ecx+0x55]
    cmp byte[disp_data_name], "S"
    jne %%common_parts_3


    ; mov rsi, w 
    ; call printString

    push rax

    mov al, "0"
    mov [mod], al
    mov [mod+1], al 
    mov byte [mod+2], 0

    pop rax

    ; mov rsi, w 
    ; call printString

    mov r12, base_name
    inc r12
    string_match r12, bp_ 
    cmp rax, 1
    je %%saw_bp_3

    ; mov rsi, w 
    ; call printString

    jmp %%common_parts_3

%%saw_bp_3:
;[eax+edx] and [eax+ecx+0x55]
    push rax
    mov al, "0"
    mov [mod], al 
    mov al, "1"
    mov [mod+1],al
    mov byte [mod+2],0
    pop rax

    mov_str disp_data, disp_base
    jmp %%common_parts_3
    
%%common_parts_3:
;[eax+edx] and [eax+ecx+0x55]

    ; mov rsi, w
    ; call printString

    push rax

    mov al, "1"
    mov [r_m], al

    mov al, "0"
    mov [r_m+1], al 
    mov [r_m+2], al

    mov [ss_], al 
    mov [ss_+1], al 

   

    mov byte[r_m+3], 0
    mov byte[ss_ + 2], 0

    ; mov rsi, w
    ; call printString


    pop rax

    find_code registers, base_name, temp 
    mov r12, temp
    inc r12
    mov_str base, r12

    find_code registers, index_name, temp 
    mov r12, temp
    inc r12
    mov_str inx, r12

    find_size index_name, temp 
    string_match temp, thirty_two32
    je %%pref_67_3

    find_size base_name, temp 
    string_match temp, thirty_two32
    je %%pref_67_3

    jmp %%rex_check_3

%%pref_67_3:
;[eax+edx] and [eax+ecx+0x55]


    prefix67
    jmp %%rex_check_3
%%rex_check_3:
;[eax+edx] and [eax+ecx+0x55]
    mov r12, base_name
    inc r12

    mov al, [r12]

    cmp byte [r12], 57
    jg %%check_rex_3_2

    cmp byte [r12], 48
    jl %%check_rex_3_2

    dec r12
    cmp byte [r12], "r"
    je %%rex_m_3

    mov al, [if_rex]
    cmp al, "1"
    je %%rex_m_3

    jmp %%check_rex_3_2
%%check_rex_3_2:
;[eax+edx] and [eax+ecx+0x55]

    mov r12, index_name
    inc r12

    mov al, [r12]

    cmp byte [r12], 57
    jg %%third_2_part

    cmp byte [r12], 48
    jl %%third_2_part

    dec r12
    cmp byte [r12], "r"
    je %%rex_m_3
%%rex_m_3:
;[eax+edx] and [eax+ecx+0x55]
    rex_set
    jmp %%third_2_part

%%third_2_part:
;[eax+edx] and [eax+ecx+0x55]
    cmp byte [disp_data_name], "S"
    je %%end_third_case

    extend_disp

    string_match disp_size, thirty_two32 
    cmp rax, 1
    je %%mod10

    push rax
    mov al, "0"
    mov [mod], al
    mov al, "1"
    mov [mod+1], al
    mov byte[mod+2],0
    pop rax
    jmp %%end_third_case


%%mod10:
;[eax+edx] and [eax+ecx+0x55]
    push rax
    mov al, "1"
    mov [mod], al
    mov al, "0"
    mov [mod+1], al
    mov byte[mod+2],0
    pop rax
    jmp %%end_third_case

%%end_third_case:
;[eax+edx] and [eax+ecx+0x55]
    ; mov rsi, disp_data
    ; call printString
    ; call newLine

    xor r11,r11
    jmp %%end_brack_m

%%fourth_case:
;[ecx*4] and [ecx*4+0x06] 
    push rax
    mov al, "0"
    mov byte [mod], al
    mov byte [mod+1], al
    mov byte [mod+2], 0

    mov byte [r_m+1], al
    mov byte [r_m+2], al
    mov byte [base+1], al

    mov al, "1"
    mov byte [r_m], al
    mov byte [r_m+3], 0

    mov byte [base], al
    mov byte [base+2], al
    mov byte [base+3], 0
    pop rax 

    find_code registers, index_name, temp 

    mov r12, temp
    inc r12
    mov_str inx, r12 

    cmp byte [disp_data_name], "S"
    je %%add_disp_4

    disp_imm disp_data_name

    find_len disp_data_name

    sub rax, 2 ;for 0x

    mov r12, 8
    sub r12, rax
    cmp r12, 0
    jne %%add_zero_disp_4
    jmp %%continue_4

%%add_zero_disp_4:
;[ecx*4] and [ecx*4+0x06] 
    cmp r12, 1
    jl %%continue_4

    mov bl, "0"
    find_len disp_data
    mov [disp_data+rax], bl 
    dec r12
    jmp %%add_zero_disp_4

%%add_disp_4:
;[ecx*4] and [ecx*4+0x06] 
    mov_str disp_data, disp_base
    jmp %%continue_4

%%continue_4:
;[ecx*4] and [ecx*4+0x06] 
    find_size index_name, temp 
    string_match temp, thirty_two32
    cmp rax, 1
    je %%prefix67_4
    jmp %%rex_check_4

%%prefix67_4:
;[ecx*4] and [ecx*4+0x06] 
    prefix67
    jmp %%rex_check_4

%%rex_check_4:
;[ecx*4] and [ecx*4+0x06] 
    mov r12, index_name
    inc r12

    mov al, [r12]
    ; mov rsi , al
    ; call printString
    ; call newLine

    cmp byte [r12], 57
    jg %%fourth_end

    cmp byte [r12], 48
    jl %%fourth_end

    dec r12
    cmp byte [r12], "r"
    je %%rex_m_4

    mov al, [if_rex]
    cmp al, "1"
    je %%rex_m_4

    jmp %%fourth_end

%%rex_m_4:
;[ecx*4] and [ecx*4+0x06] 

    rex_set
    jmp %%fourth_end

%%fourth_end:
;[ecx*4] and [ecx*4+0x06] 
    xor r11, r11
    jmp %%end_brack_m

%%fifth_case:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]
    push rax

    mov al, "0"
    mov [mod], al 
    mov [mod+1], al 
    mov byte[mod+2], 0

    mov [r_m+1], al
    mov [r_m+2], al 
    mov al, "1"
    mov [r_m], al 
    mov byte[r_m+3],0

    pop rax

    find_code registers, base_name, temp 
    mov r12, temp 
    inc r12
    mov_str base, r12

    find_code registers, index_name, temp 
    mov r12, temp 
    inc r12
    mov_str inx, r12

    cmp byte [disp_data_name], "S"
    je %%add_disp_5

    extend_disp

    string_match disp_size, eight8
    cmp rax,1
    jne %%thirty_two_label

    push rax
    mov al, "0"
    mov [mod], al
    mov al, "1"
    mov [mod+1], al
    mov byte[mod+2], 0
    pop rax
    jmp %%continue_5

    
%%thirty_two_label:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]
    push rax
    mov al, "1"
    mov [mod], al
    mov al, "0"
    mov [mod+1], al
    mov byte[mod+2], 0
    pop rax
    jmp %%continue_5

%%add_disp_5: ;only add if we have rbp/ebp
;[ebp+ecx*4] 
    mov r12, base_name 
    inc r12
    string_match r12, bp_ 
    cmp rax, 1
    je %%bp_found

    mov r12, index_name 
    inc r12
    string_match r12, bp_ 
    cmp rax, 1
    je %%bp_found

    jmp %%continue_5


%%bp_found:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]
    push rax
    mov al, "0"
    mov [mod], al
    mov al, "1"
    mov [mod+1], al
    mov byte[mod+2], 0
    pop rax
    mov_str disp_data, disp_bp_8

    jmp %%continue_5

%%continue_5:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]
    find_size index_name, temp 
    string_match temp, thirty_two32
    cmp rax, 1
    je %%pref67_5


    find_size base_name, temp 
    string_match temp, thirty_two32
    cmp rax, 1
    je %%pref67_5
    jmp %%rex_check_5

%%pref67_5:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]

    prefix67
    jmp %%rex_check_5
%%rex_check_5:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]
    mov r12, base_name
    inc r12

    mov al, [r12]

    cmp byte [r12], 57
    jg %%check_rex_5_2

    cmp byte [r12], 48
    jl %%check_rex_5_2

    dec r12
    cmp byte [r12], "r"
    je %%rex_m_5

    mov al, [if_rex]
    cmp al, "1"
    je %%rex_m_5

    jmp %%check_rex_5_2
%%check_rex_5_2:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]
    mov r12, index_name
    inc r12

    mov al, [r12]

    cmp byte [r12], 57
    jg %%fifth_end

    cmp byte [r12], 48
    jl %%fifth_end

    dec r12
    cmp byte [r12], "r"
    je %%rex_m_5
%%rex_m_5:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]
    rex_set
    jmp %%fifth_end

%%fifth_end:
;[ebp+ecx*4] and [ebp+ecx*4+0x06]
    xor r11, r11
    jmp %%end_brack_m
%%end_brack_m:
    cmp r11, 0    
    jne %%piece_left_m

    
    mov r13, base_name
    inc r13

    string_match r13, bp_
    cmp rax,1
    jne %%end_brack_m_2

    cmp byte[disp_data_name], "S"
    jne %%end_brack_m_2

    mov al, "0"
    mov [disp_data], al 
    mov [disp_data+1], al 
    mov byte [disp_data+2], 0
    jmp %%end_brack_m_2

%%end_brack_m_2:
    pop rax
    pop rax
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
%endmacro


%macro mem_to_reg 3
; 1 is command / 2 is reg / 3 is mem
    push r8
    push r9
    push r10
    push rax
    push r12

    mov r8, %1
    mov r9, %2
    mov r10, %3

    mov al, "1"
    mov [w], al
    mov byte[w+1], 0

    mov rsi, %2
    call printString
    call newLine



    find_code registers, %2, reg_code

    mov rsi, reg_code
    call printString
    call newLine



    mov r12, reg_code
    inc r12

    mov_str reg_op, r12

    find_size %2, temp 



    string_match sixteen16, temp 
    cmp rax,1
    je %%prefix66_mtr

    string_match eight8, temp 
    cmp rax,1
    je %%set_w_0_mtr

    jmp %%continue_1_mtr

%%prefix66_mtr:
    prefix66
    jmp %%check_bsf_mtr
%%check_bsf_mtr:
    string_match r8, bsf_
    cmp rax, 1
    je %%set_w_0_mtr
    jmp %%continue_1_mtr

%%set_w_0_mtr:
    mov al, "0"
    mov [w], al
    mov byte [w+1], 0

    ; mov rsi, w
    ; call printString

    jmp %%continue_1_mtr

%%continue_1_mtr:

    find_size r9, temp 

    string_match temp, sixty4
    cmp rax, 1
    je %%rex_mtr

    cmp byte [r9], "r"
    jne %%mem_mtm

    inc r9
    mov al, [r9]

    ; mov rsi , al
    ; call printString
    ; call newLine

    cmp byte [r9], 57
    jg %%mem_mtm

    cmp byte [r9], 48
    jl %%mem_mtm
    dec r9


    jmp %%rex_mtr

%%rex_mtr:
    mov al, "1"
    mov [if_rex], al
    mov byte [if_rex+1],0

    jmp %%mem_mtm

%%mem_mtm:
    mem %3

    mov al, "S"
    cmp [rex_w], al
    je %%bef_tof

    find_size %2, temp 
    string_match temp, sixty4
    cmp rax, 1
    je %%rex_w_1

    jmp %%bef_tof

%%rex_w_1:

    mov al, "1"
    mov [rex_w], al
    mov byte [rex_w+1], 0

    jmp %%bef_tof
%%bef_tof:
    find_code mem_reg_opcode, %1, opcode

    jmp %%end_mtr

%%end_mtr:
    pop r12
    pop rax
    pop r10
    pop r9
    pop r8

%endmacro

%macro reg_to_mem 3
; 1 is command / 2 is mem / 3 is reg
    push r8
    push r9
    push r10
    push r11
    push rax

    mov r8, %1 
    mov r9, %2
    mov r10, %3

    mem_to_reg %1, %3, %2 

    string_match r8, sub_
    cmp rax, 1 
    je %%d_0

    string_match r8, sbb_
    cmp rax, 1 
    je %%d_0

    string_match r8, or_
    cmp rax, 1 
    je %%d_0

    string_match r8, xadd_
    cmp rax, 1 
    je %%finish_rtm

    string_match r8, test_
    cmp rax, 1 
    je %%finish_rtm

    ;here I should change d to one
    find_len opcode 
    dec rax 

    mov byte [opcode+rax], "1"
    inc rax
    mov byte [opcode+rax], 0


    jmp %%finish_rtm

%%d_0:

    find_len opcode 
    dec rax 

    mov byte [opcode+rax], "0"
    inc rax
    mov byte [opcode+rax], 0

    jmp %%finish_rtm

%%finish_rtm:
    pop rax
    pop r11
    pop r10
    pop r9
    pop r8

%endmacro

%macro one_operand_memmory 3
; 1 is command / 2 is size/3 is memmo
    push r8
    push r9
    push r10
    push rax

    mov r8, %1
    mov r9, %2
    mov r10, %3

    mov al, "1"
    mov [w],al 
    mov byte[w+1], 0

    mem %3

    find_code oneOperands_mem, %1, opcode 



    find_code regOne, %1, reg_op

    cmp byte [r], 0
    jne %%change_rex

    cmp byte [x], 0
    jne %%change_rex

    cmp byte [b_], 0
    jne %%change_rex

    jmp %%continue_oom
%%change_rex:
    mov al, "0"
    mov [rex_w], al 
    mov byte[rex_w+1], 0

    string_match %2, qword_
    cmp rax, 1
    jne %%continue_oom

    mov al, "1"
    mov [rex_w], al 
    jmp %%continue_oom

%%continue_oom:

    mov byte [prefix_66], 0

    string_match r9, byte_
    cmp rax, 1
    je %%change_w_0_oom

    string_match r9, word_
    cmp rax, 1
    je %%prefix_66_oom

    string_match r9, qword_
    cmp rax, 1
    je %%rex_edit_oom

    jmp %%end_oop

%%change_w_0_oom:
    mov al, "0"
    mov [w],al 
    mov byte[w+1], 0
    jmp %%end_oop

%%prefix_66_oom:
    prefix66
    jmp %%end_oop

%%rex_edit_oom:
    mov al, "1"
    mov [rex_w], al 
    mov byte[rex_w+1], 0
    
    cmp byte[r], 0
    je %%r_1_oop

    cmp byte[x], 0
    je %%x_1_oop

    cmp byte[b_], 0
    je %%b_1_oop

    jmp %%end_oop

%%r_1_oop:
    mov al, "1"
    mov [r], al 
    mov byte[r+1], 0
    jmp %%end_oop

%%x_1_oop:
    mov al, "1"
    mov [x], al 
    mov byte[x+1], 0
    jmp %%end_oop

%%b_1_oop:
    mov al, "1"
    mov [b_], al 
    mov byte[b_ +1], 0
    jmp %%end_oop

%%end_oop:
    pop rax
    pop r10
    pop r9
    pop r8
%endmacro

%macro shift 3
; 1 is command / 2 is reg / 3 is imm
    push r8
    push r9
    push r10
    push rax

    mov r8, %1
    mov r9, %2
    mov r10, %3

    find_code shifts, r8, reg_op

    find_code registers, r9, r_m

    find_size r9, temp

    string_match temp, sixteen16
    je %%pref_66_sh

    string_match temp, eight8
    je %%set_w_0_sh

    string_match temp, sixty4
    je %%set_rex_sh

    jmp %%continue_sh

%%pref_66_sh:
    prefix66 
    jmp %%continue_sh

%%set_w_0_sh:
    mov al, "0"
    mov [w], al 
    mov byte[w+1], 0
    jmp %%continue_sh

%%continue_sh:
    cmp byte [r9], "r"
    je %%set_rex_sh

    jmp %%check_imm

%%set_rex_sh:
    mov_str base_name,%2
    rex_set
    je %%check_imm

%%check_imm:
    cmp byte [r10], "1"
    je %%imm_1_sh

    find_code shifts, imm_n, opcode

;bayad qablesh 0x exafe konim ke
    dec r10 
    mov byte[r10], "x"
    dec r10
    mov byte[r10], "0"
    inc r10
    inc r10


    disp_imm r10
    jmp %%end_sh

%%imm_1_sh:
    find_code shifts, imm_1, opcode
    jmp %%end_sh

%%end_sh:
    pop rax
    pop r10
    pop r9
    pop r8

%endmacro

%macro parser 2
; 1 is input str / 2 is where we return parse conclusion

; 00 means zero operand/ 
;10 means one operand reg/11 means one operand mem
;20 reg_to_mem/ 21 mem_to_reg 
;30 imm_to_reg / 31 reg_to_reg

    push r8
    push r9
    push r10

    push rbx
    push rax
    push r11

    mov r8, %1
    mov r9, %2


    string_searcher r8, space 
    cmp rbx, 0
    je %%zero_operand_p

    string_searcher r8, comma 
    cmp rbx,0
    je %%one_operand_p



    string_searcher r8, comma 
    inc rbx
    cmp byte [r8+rbx], "0"
    je %%imm_to_reg_p
    mov r10, rbx

    string_searcher r8, open_par 
    cmp rbx, 0
    je %%reg_to_reg_p

    ;we have the index of comma in r10
    ;we have the index of open par in rbx

    cmp r10, rbx
    jg %%reg_to_mem_p

    cmp r10, rbx
    jl %%mem_to_reg_p

    jmp %%reg_to_reg_p

%%zero_operand_p:

    mov al, "0"
    mov [r9], al 
    mov [r9+1], al
    mov byte [r9+2],0
    mov r11, r8

    mov_str command, r11

    jmp %%end_p

%%one_operand_p:


    ;checking if one operand mem or reg
    string_searcher r8, open_par
    cmp rbx, 0
    je %%one_operand_reg_p

    ;finding operand and command
    string_searcher r8, space 
    add r8, rbx

    mov byte[r8], 0
    sub r8, rbx

    mov r11, r8

    mov_str command, r11
    add r8, rbx
    inc r8 ;points to Q

    string_searcher r8, space 
    add r8, rbx

    mov byte[r8], 0
    sub r8, rbx

    mov r11, r8

    mov_str size, r11
    add r8, rbx
    inc r8 ;points to P

   string_searcher r8, space 
    add r8, rbx
    inc r8 ;points to [
    
    mov r11, r8

    mov_str op_1, r11

    ;one operand mem
    mov al, "1"
    mov [r9], al 
    mov [r9+1], al
    mov byte [r9+2],0

    jmp %%end_p

%%one_operand_reg_p:

    string_searcher r8, space 
    add r8, rbx
    inc r8
    ; push rbx
    mov r11, r8
    mov_str op_1, r11

    dec r8
    mov byte[r8], 0
    sub r8, rbx
    mov r11, r8
    mov_str command, r11

    mov al, "1"
    mov [r9], al 
    mov al, "0"
    mov [r9+1], al
    mov byte [r9+2],0
    jmp %%end_p

%%reg_to_reg_p: 

    string_searcher r8, comma

    add r8, rbx 
    inc r8

    ; mov rsi, r8
    ; call printString
    ; call newLine

    mov r11, r8
    mov_str op_2, r11

    dec r8 
    mov byte [r8], 0


    sub r8, rbx 


    string_searcher r8, space 
    add r8, rbx
    inc r8

    ; mov rsi, r8
    ; call printString
    ; call newLine
    mov r11,r8
    mov_str op_1, r11

    dec  r8

    mov byte [r8], 0

    sub r8, rbx 


    ; mov rsi, r8
    ; call printString
    ; call newLine
    mov r11, r8
    mov_str command, r11


    mov al, "3"
    mov [r9], al 
    mov al, "1"
    mov [r9+1], al
    mov byte [r9+2],0
    jmp %%bef_end

%%mem_to_reg_p:
    ;command mov rax,WORD PTR [rax+rbx+0x55]
    string_searcher r8, space 
    add r8, rbx ;r8 points to the first space


    mov byte[r8], 0 
    sub r8, rbx ;r8 points to the begining

    mov r11, r8

    mov_str command, r11
    add r8, rbx
    inc r8

    ;operand one (reg)
    string_searcher r8, comma 
    add r8, rbx ;r8 points to the comma
    mov al, [r8]
    mov byte[r8], 0 
    sub r8, rbx ;r8 points to the begining

    mov r11, r8
    mov_str op_1, r11
    add r8, rbx
    inc r8


    ;operand two(mem)
    string_searcher r8, space 
    add r8, rbx ;r8 points to the space
    mov al, [r8]
    mov byte[r8], 0 
    sub r8, rbx ;r8 points to the begining

    mov r11, r8
    mov_str size, r11
    add r8, rbx
    inc r8

    string_searcher r8, space
    add r8, rbx ;skipping PTR
    inc r8 ;points to "["

    mov r11, r8
    mov_str op_2, r11

    mov al, "2"
    mov [r9], al 
    mov al, "1"
    mov [r9+1], al
    mov byte [r9+2],0
    jmp %%bef_end

%%reg_to_mem_p:
    ;command
    string_searcher r8, space 
    add r8, rbx ;r8 points to the first space

    mov byte[r8], 0 
    sub r8, rbx ;r8 points to the begining
    mov r11, r8
    mov_str command, r11
    add r8, rbx
    inc r8

 ;operand one(mem)
    string_searcher r8, space 
    add r8, rbx ;r8 points to the space
    mov byte[r8], 0 
    sub r8, rbx ;r8 points to the begining

    mov r11, r8
    mov_str size, r11
    add r8, rbx
    inc r8

    string_searcher r8, space
    add r8, rbx ;skipping PTR
    inc r8 ;points to "["

    string_searcher r8, comma
    add r8, rbx
    mov byte[r8], 0 
    sub r8, rbx

    mov r11, r8
    mov_str op_2, r11

    add r8, rbx
    inc r8 ;r8 points to rhe first character aftre comma

    ;operand one (reg)

    mov r11, r8
    mov_str op_1, r11

    mov al, "2"
    mov [r9], al 
    mov al, "0"
    mov [r9+1], al
    mov byte [r9+2],0
    jmp %%bef_end

%%imm_to_reg_p:


   string_searcher r8, comma

    add r8, rbx 
    inc r8

    mov r11, r8

    mov_str op_2, r11

    dec r8 
    mov byte [r8], 0


    sub r8, rbx 


    string_searcher r8, space 
    add r8, rbx
    inc r8


    mov r11, r8
    mov_str op_1, r11


    dec  r8

    mov byte [r8], 0

    sub r8, rbx 

    mov r11, r8
    mov_str command, r11

    mov al, "3"
    mov [r9], al 
    mov al, "0"
    mov [r9+1], al
    mov byte [r9+2],0
    jmp %%bef_end

%%bef_end:
    jmp %%end_p

%%end_p:
    pop r11
    pop rax
    pop rbx
    pop r10
    pop r9
    pop r8
%endmacro

%macro print 1
    push r8
    mov r8, %1

    cmp byte [r8], "S"
    je %%end_p

    add_str ans, %1

    ; mov rsi, r8 
    ; call printString
    ; call newLine

    jmp %%end_p
%%end_p:
    pop r8
%endmacro
; 00 means zero operand/ 
;10 means one operand reg/11 means one operand mem
;20 reg_to_mem/ 21 mem_to_reg 
;30 imm_to_reg / 31 reg_to_reg
;40 if shif
make_ans:
    push r8
    push r9

    mov r8, temp 

    string_match temp, a_00
    cmp rax, 1
    je m_zero_operand

    string_match temp, a_10
    cmp rax, 1
    je m_one_operand_reg

    string_match temp, a_11
    cmp rax, 1
    je m_one_operand_mem

    string_match temp, a_20
    cmp rax, 1
    je m_reg_mem

    string_match temp, a_21
    cmp rax, 1
    je m_mem_reg

    string_match temp, a_30
    cmp rax, 1
    je m_imm_reg

    string_match temp, a_31
    cmp rax, 1
    je m_reg_reg

    string_match temp, a_40
    cmp rax, 1
    je m_shift

m_zero_operand:
    zero_op command 

    ; mov rsi, zero_op_temp
    ; call printString
    ; call newLine
    add_str ans, zero_op_temp

    jmp end_make

m_one_operand_reg:
    one_op_reg command, op_1
    jmp print_ans


m_one_operand_mem:
    one_operand_memmory command, size, op_1
    jmp print_ans

m_reg_mem:
    reg_to_mem command, op_2, op_1
    jmp print_ans

m_mem_reg:

    mem_to_reg command, op_1, op_2
    jmp print_ans

m_imm_reg:


    imm_to_reg command, op_1, op_2
    jmp print_ans

m_reg_reg:
    reg_to_reg command, op_1, op_2
    jmp print_ans

m_shift:
    shift command,op_1, op_2 
    jmp print_ans

print_ans:
    cmp byte [prefix_67], "S"
    jne have_prefix_67

    cmp byte [prefix_66], "S"
    jne have_prefix_66

    ; print prefix_67
    ; print prefix_66


    jmp print_rex
have_prefix_67:
    add_str ans, pre67_bin

    cmp byte [prefix_66], "S"
    jne have_prefix_66

    jmp print_rex
    
have_prefix_66:

    add_str ans, pre66_bin


    jmp print_rex

print_rex:
    cmp byte [rex_w], "S"
    je continue_print_1


    print start_rex
    print rex_w
    print r
    print x 
    print b_ 


    jmp continue_print_1
continue_print_1:

    print opcode

    ; mov rsi, debug
    ; call printString
    ; call newLine

    print s

    print w 
        
    ; mov rsi, debug
    ; call printString
    ; call newLine


    print mod 
    print reg_op
    print r_m

    ; mov rsi, debug
    ; call printString
    ; call newLine

    print ss_
    print inx
    print base 

    ; mov rsi, debug
    ; call printString
    ; call newLine

    cmp byte [disp_data], "S"
    je end_make

    ; mov rsi, debug
    ; call printString
    ; call newLine

    ; mov rsi, disp_data
    ; call printString
    ; call newLine

    hexToBin

    ; mov rsi, bin_disp
    ; call printString
    ; call newLine

    add_str ans, bin_disp

    jmp end_make




end_make:
    mov rsi, ans
    call printString
    call newLine

    ; find_len ans

    ; mov rdi, [descriptor_bin]
    ; mov rsi, ans 
    ; mov rdx, rax
    ; mov rax, 1
    ; syscall


    ; mov rax,1
    ; mov rdi,[descriptor_bin]
    ; mov rsi,space
    ; mov rdx,1
    ; syscall

    
debug

    binToHex ans

    ; find_len ans

    ; mov rdi, [descriptor_hex]
    ; mov rsi, ans 
    ; mov rdx, rax
    ; mov rax, 1
    ; syscall


    ; mov rax,1
    ; mov rdi,[descriptor_hex]
    ; mov rsi,space
    ; mov rdx,1
    ; syscall


    mov rsi, ans
    call printString
    call newLine

    pop r9
    pop r8
    ret



; create_open:
;     mov rax,2
;     mov rdi,filename
;     mov rsi,O_RDWR
;     syscall
;     mov [descriptor],rax


;     mov rax,85
;     mov rdi,hex_file
;     mov rsi,sys_IRUSR | sys_IWUSR
;     syscall
;     mov [descriptor_hex],rax 

;     mov rax,85
;     mov rdi,bin_file
;     mov rsi,sys_IRUSR | sys_IWUSR
;     syscall
;     mov [descriptor_bin],rax 

;     call main_

;     mov rax,3
;     mov rdi,[descriptor]    ;close input file
;     syscall

;     mov rax,3
;     mov rdi,[descriptor_hex]
;     syscall

;     mov rax,3
;     mov rdi,[descriptor_bin]
;     syscall

;     ret

; main_:
;     mov rbx, inp 
;     jmp next_m

; next_m:

;     mov rax,0
;     mov rdi,[descriptor]
;     mov rsi,rbx
;     mov rdx,1
;     syscall


;     cmp rax,rdx
;     jl read_end


;     ;finding end of line
;     cmp byte [rbx],0xA 
;     je found_line

;     inc rbx

;     jmp next_m



; found_line:
;     mov byte [rbx],0

;     initialization

;     parser inp, temp 

;     call make_ans

;     mov rbx,inp
;     jmp next_m

; read_end:
;     mov byte [rbx],0    
;     mov r15,-10  

;     initialization

;     parser inp, temp 

;     call make_ans


;     ret




_start:

    ; call create_open

    

    initialization

    parser inp, temp 

    mov rsi, temp 
    call printString
    call newLine

    call make_ans

Exit:
    mov rax, 1
    mov rbx, 0 
    int 0x80

