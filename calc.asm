section .data
    result db 0

section .text
    global _start

_start:
    
    mov rax, 1           
    mov rdi, 1          
    mov rsi, msg_operacao 
    mov rdx, len_operacao 
    syscall

    
    mov rax, 0         
    mov rdi, 0          
    mov rsi, operacao    
    mov rdx, 2  
    syscall

 
    movzx rax, byte [operacao]
    sub rax, '0'
    mov [operacao_num], rax

  
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num1
    mov rdx, len_msg_num
    syscall


    mov rax, 0
    mov rdi, 0
    mov rsi, num1
    mov rdx, 10
    syscall


    mov rax, 0
    mov rdi, num1
    call str_to_int


    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num2
    mov rdx, len_msg_num
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 10
    syscall


    mov rax, 0
    mov rdi, num2
    call str_to_int


    mov rax, [operacao_num]
    cmp rax, ADD
    je add_numbers
    cmp rax, SUB
    je sub_numbers
    cmp rax, MUL
    je mul_numbers
    cmp rax, DIV
    je div_numbers

add_numbers:
    add r8, r9 
    jmp print_result

sub_numbers:
    sub r8, r9  
    jmp print_result

mul_numbers:
    imul r8, r9 
    jmp print_result

div_numbers:
    mov rax, r8
    xor rdx, rdx
    idiv r9   
    jmp print_result

print_result:
    
    mov rax, r8
    mov rdi, result
    call int_to_str


    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 10
    syscall


    mov rax, 60
    xor rdi, rdi
    syscall

section .bss
    operacao resb 1
    operacao_num resb 1
    num1 resb 10
    num2 resb 10

section .data
    msg_operacao db 'Escolha a operacao (+, -, *, /): ', 0
    len_operacao equ $ - msg_operacao

    msg_num1 db 'Digite o primeiro numero: ', 0
    msg_num2 db 'Digite o segundo numero: ', 0
    len_msg_num equ $ - msg_num1

section .text
    str_to_int:
   
        xor rax, rax
        xor rcx, rcx

    str_to_int_loop:
        movzx rbx, byte [rdi + rcx]
        cmp rbx, 0
        je str_to_int_done

        sub rbx, '0'
        imul rax, 10
        add rax, rbx

        inc rcx
        jmp str_to_int_loop

    str_to_int_done:
        ret

    int_to_str:


        mov rbx, 10
        mov rcx, 0
        mov rdx, 1

    int_to_str_loop:
        imul rcx, rdx
        mov rdx, 0
        div rbx

        add dl, '0'
        dec rdi
        mov [rdi], dl

        test rax, rax
        jnz int_to_str_loop

        ret
