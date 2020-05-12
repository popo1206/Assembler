    .model small
    .stack 100h
    .486
    .data
n    db    3
m    db    4
matrix    db    0,1,2,5
    db    3,4,5,2
    db    6,7,8,4
    .code
    mov ax,@data
    mov ds,ax
    xor ax,ax
    xor bx,bx
    mov bl,n
    cmp bl,m
    jle minN
    xor bl,bl
    mov bl,m
minN:
    mov dl,m
    xor si,si
    xor cx,cx
    mov si,offset matrix; адрес начала матрицы
metka:
    add al, [si]
    inc si
    inc cx
    add si,dx
    cmp cx,bx
    jne metka
    mov ax,4c00h
    int 21h
    end

