ев.model medium
public    inputline,input,readfile,output,writefile,menu,algorithm
extrn    start:far
    .code
inputline    proc
    locals @@
@@buffer    equ [bp+6]
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    mov ah,3fh
    xor bx,bx
    mov cx,80
    mov dx,@@buffer
    int 21h
    jc @@ex
    cmp ax,80
    jne @@m
    stc
    jmp short @@ex
    @@m:    mov di,@@buffer
    dec ax
    dec ax
    add di,ax
    xor al,al
    stosb
    @@ex:    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
    endp
input    proc
    locals @@
@@buffer    equ [bp+6]
push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    xor bx,bx
    mov cx,4095
    mov dx,@@buffer
    @@m1:    mov ah,3fh
    int 21h
    jc @@ex
    cmp ax,2
    je @@m2
    sub cx,ax
    jcxz @@m2
    add dx,ax
    jmp @@m1
    @@m2:    mov di,@@buffer
    add di,4095
    sub di,cx
    xor al,al
    stosb
    @@ex:    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
    endp
output    proc
    locals @@
    @@buffer    equ [bp+6]
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    mov di,@@buffer
    xor al,al
    mov cx,0ffffh
    repne scasb
    neg cx
    dec cx
    dec cx
    jcxz @@ex
    cmp cx,4095
    jbe @@m
    mov cx,4095
    @@m:    mov ah,40h
    xor bx,bx
    inc bx
    mov dx,@@buffer
    int 21h
    @@ex:    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
    endp
readfile    proc
    locals @@
    @@buffer    equ [bp+6]
    @@filnam    equ [bp+8]
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    mov ax,3d00h
    mov dx,@@filnam
    int 21h
    jc @@ex
    mov bx,ax
    mov cx,4095
    mov dx,@@buffer
    @@m1:    mov ah,3fh
    int 21h
    jc @@er
    or ax,ax
    je @@m2
    sub cx,ax
    jcxz @@m2
    add dx,ax
    jmp @@m1
    @@m2:    mov di,@@buffer
    add di,4095
    sub di,cx
    mov ax,13
    stosb
    mov ax,10
    stosb
    xor al,al
    stosb
    mov ah,3eh
    int 21h
    @@ex:    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
    @@er:    mov ah,3eh
    int 21h
    stc
    jmp @@ex
    endp
writefile proc
    locals @@
    @@filnam    equ [bp+8]
    @@buffer    equ [bp+6]
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    mov ah,3ch
    xor cx,cx
    mov dx,@@filnam
    int 21h
    jc @@ex
    mov bx,ax
    mov di,@@buffer
    xor al,al
    mov cx,0ffffh
    repne scasb
    neg cx
    dec cx
    dec cx
    jcxz @@ex
    cmp cx,4095
    jbe @@m
    mov cx,4095
@@m:    mov ah,40h
    mov dx,@@buffer
    int 21h
    jc @@er
    mov ah,3eh
    int 21h
@@ex:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
@@er:    mov ah,3eh
    int 21h
    stc
    jmp @@ex
    endp

algorithm    proc
        locals @@
        @@ibuf    equ [bp+6]; буфер с исходными строками. equ - аналогично сишному define
        @@obuf    equ [bp+8]; буфер, куда надо записать ответ
        push bp
        mov bp,sp
        push ax
        push bx
        push dx
        push cx
        push si
        push di
        mov cx,0ffffh
        mov di,@@ibuf
        xor al,al
        repne scasb
        neg cx
        dec cx
        dec cx
        jcxz @@ex
        cmp cx,4095
        jbe @@mm1
        stc
        jmp short @@ex
@@mm1:       mov si,@@ibuf
        xor cx,cx ;обнуляем счетчик
        xor dx,dx
        lodsb;первый символ
        cmp al,0
        je @@ex
        mov bx,ax
        xor di,di


@@m0:   lodsb;считали символ, si сдвинулся
        cmp al,13
        je @@konecStr
        cmp al,' '
        je @@m0
        cmp al,','
        je @@m0
        cmp ax,bx;сравнли буквы
        jne @@m1;если не равны буквы
        inc dx;
        inc di;
        jmp @@m2; чтобы не заносить в стек не нужную букву
@@m1: push ax;занесли в стек
        inc cx
@@m2: jmp @@m0
@@konecStr:
        cmp di,0
        je @@one
        inc dx

@@one:  xor di,di
        mov si,@@ibuf
        cmp cx,0
        je @@ex; сравнили все
        pop bx
        dec cx
        cmp cx,0
        je @@ex; сравнили все
@@m4:  pop ax; (извлекли символ слова)
        mov [si],ax
        inc si
        loop @@m4;  столько раз сколько cx
        mov ax,13
        mov [si],ax
        mov si,@@ibuf
        jmp @@m0;
; записать результат dx в строку obuf
@@ex:

        mov di,@@obuf
        xor ax,ax
        xor cx,cx;счетчик кол-ва цифр в цисле (кол-во остактов от деления)
        mov ax,dx;занесли значение в ax
        mov bx,10;for div 10 сс
@@div:        xor dx,dx ; для деления dx ax на bx
        div bx
        add dl,'0' ; преобразуем остаток от деления в символ
        push dx;сохарним
        inc cx; увеличим счетчик кол-во остатков
        test ax,ax; в числе есть еще цирфы?
        jnz     @@div ;да-повтоим цикл деления
@@output:      pop dx
        mov [di],dx
        inc di
        loop @@output
        mov dx,13
        mov [di],dx
        inc di
        mov dx,10
        mov [di],dx
        inc di
        mov dx,0
        mov [di],dx
        pop di
        pop si
        pop cx
        pop dx
        pop bx
        pop ax
        pop bp
        ret
        endp
    menu    proc
    locals @@
    @@ax        equ [bp-82]
    @@buffer    equ [bp-80]
    @@items    equ    [bp+6]
    push bp
    mov bp,sp
    sub sp,80
    push ax
    @@m:    push @@items
    call output
    pop ax
    jc @@ex
    push ds
    push es
    push ss
    push ss
    pop ds
    pop es
    mov ax,bp
    sub ax,80
    push ax
    call inputline
    pop ax
    pop es
    pop ds
    jc @@ex
    mov al,@@buffer
    cbw
    sub ax,'0'
    cmp ax,0
    jl @@m
    cmp ax,@@ax
    jg @@m
    clc
    @@ex:    mov sp,bp
    pop bp
    ret
    endp
        end start
