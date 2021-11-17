.bss

.data
buffer: .skip 65536

.text
name: .asciz "Asda"
sDecimal: .asciz "%d"
usDecimal: .asciz "%lu"
String: .asciz "%s"
literal: .asciz "%%"

.global main

main:
    movq %rsp , %rbp #start stack

    movq $name, %rdi

    call myprint
    jmp end

myprint: #rdi sentence
    pushq %r9
    pushq %r8
    pushq %rcx
    pushq %rdx
    pushq %rsi
    movq $buffer, %r14
    movq $0, %r12
    movq $0, %r15

loop1:
    cmpb $0, (%rdi, %r15)
    je endmyprint

    cmpb $'%', (%rdi, %r15)
    je fill

proceed:
    movb (%rdi, %r15), %r9b
    movb %r9b, (%r14 ,%r12)
    addq $1, %r12
    addq $1, %r15
    jmp loop1

checkpos: #we have the sentence in RDI returns in RCX
    pushq %rbp
    movq %rsp, %rbp #reset stack

    movq %rsi, %rax
    call loop2

loop2:
    cmpb $0, (%rdi)
    je endloop2

    cmpb $'%', (%rdi)
    je endloop2

    addq $1, %r15
    addq $1, %rax

    jmp loop2

endloop2:
    ret

editstring: #position we edit (%rax (because we ex. it after checkpos.)), the string we need to place there (%rsi), the length ...
    pushq %rbp
    movq %rsp, %rbp #reset stack

checkend: #we have the sentence in RDI returns in RCX
    pushq %rbp
    movq %rsp, %rbp #reset stack

    movq $0, %rax
    call loop

loop:
    cmpb $0, (%rdi)
    je endloop

    addq $1, %rdi
    addq $1, %rax

    jmp loop

endloop:
    movq %rbp, %rsp
    pop %rbp
    ret

fill:
    addq $1, %r15#check the next char
    cmpb $'d', (%rdi,%r15)
    je sdecimal

    cmpb $'u', (%rdi,%r15)
    je positive

    cmpb $'s', (%rdi,%r15)
    je string

    cmpb $'%', (%rdi,%r15)
    je percent

sdecimal:
    pop %rax
    cmpq $0, %rax
    jl negative
    jg positive
    movq $48, (%r12)
    addq $1, %r12
    jmp proceed

negative:
    movq $'-', (%r12)

positive:
    movq $0, %r8
    movq $0, %rdx
    movq $10, %rcx
la:
    divq %rcx
    pushq %rdx
    addq $1, %r8
    cmpq $0, %rax
    je lp

    jmp la

lp:
    cmp $0,%r8
    je proceed
    pop (%r12)
    addq $1, %r12
    subq $1, %r8
    jmp lp

string:
    pop %rsi
    movq %rsi, (%r12)
    addq $1, %r12
    jmp proceed

percent:
    movq $'%', (%r12)
    addq $1, %r12
    jmp proceed

endmyprint:
    movq $buffer, %rsi #rdi needs to be the complete sentence
    call checkend #edit it so it chech the buffern
    movq %rax, %rdx
    movq $1, %rdi
    movq $1, %rax
    syscall

end:
    movq $0, %rdi #cleaning
    call exit #ending program

