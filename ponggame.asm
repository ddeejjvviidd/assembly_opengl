section .rodata
windowTitle: db "Pong 2D in Assembly!", 0

section .bss
window resq 1 ; pointer to window
width resd 1
height resd 1

section .text

; glfw funcs
extern glfwInit, glfwInitHint, glfwWindowHint, glfwCreateWindow, glfwMakeContextCurrent
extern glfwSwapBuffers, glfwWindowShouldClose, glfwTerminate, glfwPollEvents


global _start
_start:

    ; glfwGetPlatform
    ;call glfwGetPlatform
    ;mov rsi, rax
    ;mov rdi, 1
    ;mov rdx, 16
    ;syscall

    ; wayland glfwWindowHint
    mov eax, 0x00060000
    mov ebx, 0x00060003
    call glfwWindowHint

    ; glfwInit()
    call glfwInit
    test eax, eax
    jz glfw_init_error

    ; glfwCreateWindow()
    mov rdi, 900
    mov rsi, 600
    mov rdx, windowTitle
    call glfwCreateWindow
    mov [window], rax

    ; glfwMakeContextCurrent()
    mov rdi, [window]
    call glfwMakeContextCurrent


windowLoop:

    ; glfwSwapBuffers()
    mov rdi, [window]
    call glfwSwapBuffers
    
    ; glfwPollEvents
    call glfwPollEvents

    ; glfwWindowShouldClose()
    mov rdi, [window]
    call glfwWindowShouldClose

    ; checking if user wants to close the app
    cmp rax, 0
    je windowLoop

    ; glfwTerminate()
    call glfwTerminate

    ; exit
    mov rax, 60
    mov rdi, 0
    syscall


; errors
glfw_init_error:
    mov rax, 60
    mov rdi, 1
    syscall