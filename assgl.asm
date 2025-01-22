section .rodata
windowTitle: db "OpenGL in Assembly!", 0

section .data
colorBlack: dq 1.0, 0.0, 1.0, 0.0 
colorWhite: dd 1.0, 1.0, 1.0, 1.0
lineVertices: dq -0.01, -1.0, 0.01, -1.0, 0.01, 1.0, -0.01, 1.0 ; not used

x_val: dd 1.0
y_val: dd 1.0
x_val2: dd 0.0
y_val2: dd 0.0

section .bss
window resq 1 ; pointer to window
width resd 1
height resd 1

section .text

; glfw funcs
extern glfwInit, glfwInitHint, glfwWindowHint, glfwCreateWindow, glfwMakeContextCurrent
extern glfwSwapBuffers, glfwWindowShouldClose, glfwTerminate, glfwPollEvents, glfwGetFramebufferSize

extern glClearColor, glClear, glBegin, glEnd, glFlush, glViewport, glColor3f, glVertex2f, glColor4fv


global _start
_start:

    ; glfwGetPlatform
    ;call glfwGetPlatform
    ;mov rsi, rax
    ;mov rdi, 1
    ;mov rdx, 16
    ;syscall

    ; wayland glfwWindowHint
    mov rdi, 0x00060000
    mov rsi, 0x00060003
    call glfwWindowHint

    ; glfwInit()
    call glfwInit
    test eax, eax
    jz glfw_init_error

    ; glfwCreateWindow()
    mov rdi, 858
    mov rsi, 525
    mov rdx, windowTitle
    call glfwCreateWindow
    test rax, rax
    jz glfw_create_error
    mov [window], rax

    ; glfwMakeContextCurrent()
    mov rdi, [window]
    call glfwMakeContextCurrent

    ; setting up glClearColor()
    mov r12, __float32__(0.0)
    mov r13, __float32__(1.0)
    movq xmm0, r12 ; R
    movq xmm1, r12 ; G
    movq xmm2, r12 ; B
    movq xmm3, r12 ; A
    call glClearColor

; ==================== Main loop ====================
windowLoop:
    ; glfwGetFramebufferSize()
    mov rdi, [window]
    lea rsi, [width]
    lea rdx, [height]
    call glfwGetFramebufferSize

    ; glViewport()
    mov rdi, 0 ;
    mov rsi, 0 ;
    mov rdx, 858
    mov rcx, 525
    call glViewport

    mov rdi, 0x00004000 ; 0x00004000 GL_COLOR_BUFFER_BIT
    call glClear ; clearing color buffer

    
    mov rdi, 0x0001 ; 0x0001 GL_LINES
    call glBegin

    call setColorWhite

    ; trying to draw a line from center to top right
    movss xmm0, [x_val]
    movss xmm1, [y_val]
    call glVertex2f

    movss xmm0, [x_val2]
    movss xmm1, [y_val2]
    call glVertex2f

    call glEnd


    ; glfwSwapBuffers()
    mov rdi, [window]
    call glfwSwapBuffers
    
    ; glfwPollEvents
    call glfwPollEvents

    ; glfwWindowShouldClose()
    mov rdi, [window]
    call glfwWindowShouldClose
    cmp rax, 0 ; checking if user wants to close the app
    je windowLoop ; if not, repeat the loop 
    call glfwTerminate

    ; exit
    mov rax, 60
    mov rdi, 0
    syscall


; color funcs
setColorWhite:
    mov rdi, colorWhite
    call glColor4fv
    ret

; errors
glfw_init_error:
    mov rax, 60
    mov rdi, 54
    syscall

glfw_create_error:
    mov rax, 60
    mov rdi, 55
    syscall