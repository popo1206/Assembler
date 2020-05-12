	.model small
	.stack 100h
	.486
	.data
a	db 4
b	db 2
c	db 4
d	db 2
e	db 2
	.code
	mov ax,@data
	mov ds,ax
    xor ax,ax
    mov al,b
	movsx bx,a
	imul b ; ax=(b^2)
	add ax,bx; ax=(a+b^2)
	idiv e;(a+b^2)/e
    sar al,1;(a+b^2)/2e
	push ax; put result in stack
    xor ax,ax
	mov al,d
	movsx bx,c
	imul d; d^2
    neg ax;-d^2
	sal bx,1; c*2
	add ax,bx;(2c-d^2)
    xor bx,bx
    pop bx;
    imul bx; (2c*d^2)*(a+b^2) /2e рез в dx:ax
	int 21h
	end
