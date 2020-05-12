    .model small
    .stack 100h
    .data
string    db 'xcxx iidds',0
newstring db 100 dup(?)
    .code
    mov ax,@data
    mov ds,ax
    mov es,ax
    cld;флаг направления
    lea si,string;смещение строки в сегмент данных
    xor cx,cx ;обнуляем счетчик
    xor dx,dx
    lodsb;первый символ
    cmp al,0
    je end_str
    mov bx,ax
m0:  lodsb;считали символ, si сдвинулся
    cmp al,0
    je konecStr
    cmp al,' '
    je m0
    cmp ax,bx;сравнли буквы
    jne m1;если не равны буквы
    inc dx;
    jmp m2; чтобы не заносить в стек не нужную букву
m1: push ax;занесли в стек
    inc cx
m2: jmp m0
konecStr:
    cmp cx,0
    je end_str; сравнили все
    pop bx
    dec cx
m4:  pop ax; (извлекли символ слова)
    stosb; (занесли в di)
    loop m4;  столько раз сколько cx
    mov al,0
    stosb
    lea si,string
    mov di,0
    jmp m0;
end_str:
    mov ax,4c00h
    int 21h
    end

