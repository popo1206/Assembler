    .model medium
    .stack 100h
    extrn    items:byte
    extrn    fn:byte
    extrn    ibuf:byte
    extrn    obuf:byte
    extrn    msg:byte
    extrn    frm:byte
    extrn    qws:byte
    extrn    inp:byte
    extrn    bye:byte
    extrn    input:far
    extrn    inputline:far
    extrn    readfile:far
    extrn    output:far
    extrn    writefile:far
    extrn    menu:far
    extrn    algorithm:far
    .code
start:    mov ax,@data
    mov ds,ax
    mov es,ax
    cld
    m1:    mov ax,5
    push offset items
    call menu
    pop bx
    jnc m2
    push offset msg
    call output
    pop bx
    jmp m10
m2:    cmp ax,1
    jne m3
    push offset inp
    call output
    pop bx
    push offset ibuf
    call input
    pop bx
    jc m4
    jmp m1
    m3:    cmp ax,2
    jne m5
    push offset qws
    call output
    pop bx
    push offset fn
    call inputline
    pop bx
    jc m4
    push offset fn
    push offset ibuf
    call readfile
    pop bx
    pop bx
    jc m4
    jmp m1
m4:    jmp m11
m5:    cmp ax,3
    jne m6
    push offset obuf
    call output ;процедура вывода
    pop bx      ;снова чистим да да
    jc m4       ;ошибку обрабатываем при неудаче
    jmp m1      ;меню
m6:    cmp ax,4;вывод инфо в файлв
    jne m7
    push offset qws
    call output
    pop bx
    ;процедура ввода имя файла
    push offset fn;один парамет буфер куда будет записываться инфа
    call inputline
    pop bx
    jc m11;в случае ошибки сразу на m11 удобно да да
    push offset fn; имя файла
    push offset obuf;информамиция на экран
    call writefile;процедура записи в файл
    pop bx;чи
    pop bx;стим
    jc m11;если ошибка
    jmp m1;если ок
m7:
    cmp ax,5;5: запуск алгоритма
    jne m9;если не 5 пункт значит равно 0
    push offset obuf;выходной буфер
    push offset ibuf;входной буфер
    call algorithm
    pop bx
    pop bx
    jc m8;с ошибкой некорректности информации в буфере
    jmp m1;меню
m8:    push offset frm
    call output
    pop bx
    jmp m1
m9:    push offset bye;выводим прощальной сообщений бай челик
    call output;вывели
    add sp,2    ;освобождение стека
m10:    mov ax,4c00h ;выход из программы
    int 21h
m11:    push offset msg;вывод сообщение об ошибке
    call output
    pop bx
    jmp m1
    end start






