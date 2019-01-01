.model small
.stack 100h
.data
  n equ 5
  count db 0
  bufdigits db n dup(255)
  helpbuf dw 1,10,100,1000,10000
  number1 dw 0
  number2 dw 0
  res dw 0
  menu db "Enter number: $"
  sum db "Sum: $"
.code
  mov ax,@data
  mov ds,ax
  mov ax,0900h
  lea dx,menu
  int 21h
  lea ax,number1
  push ax
  call readnumber
  mov ax,0900h
  lea dx,menu
  int 21h
  lea ax,number2
  push ax
  call readnumber
  mov ax,[number2]
  mov bx,[number1]
  add ax,bx
  mov [res],ax
  xor bx,bx
  push res
  call printword
  mov ax,4c00h
  int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;reads decimal number into first stack word address
readnumber:
  push bp
  mov bp,sp
  lea bx,bufdigits
  add bx,n
  dec bx
zero:
  mov ah,01h
  int 21h
  inc count
  cmp al,0dh
  je next
  sub al,30h
  mov byte ptr[bx],al
  dec bx
  jmp zero
next:
  dec count
  xor ax,ax
  xor bx,bx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;puts decimal digits into buf array
  lea bx,bufdigits
  mov di,[bp+4]
  lea si,helpbuf
  dec bx
move:
  inc bx
  cmp byte ptr[bx],0ffh
  je move
  mov cl,count
outerloop:
  push cx
  mov cl,byte ptr[bx]
  mov dx, word ptr[si]
innerloop:
  add word ptr[di],dx
  loop innerloop
  inc bx
  inc si
  inc si
  pop cx
  loop outerloop
  mov cx,n
  lea bx,bufdigits
clear:
  mov byte ptr[bx],0ffh
  inc bx
  loop clear
  xor si,si
  xor bx,bx
  xor dx,dx
  xor di,di
  xor ax,ax
  mov count,0
  pop bp
  ret 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printword:
  push bp
  mov bp,sp
  mov ax,[bp+4]
  mov cx,10
divide:
  inc count
  div cx
  push dx
  xor dx,dx
  cmp ax,0
  jne divide
  mov cl,count
  mov ax,0900h
  lea dx,sum
  int 21h
print:
  pop dx
  add dl,30h
  mov ah,02h
  int 21h
  dec cx
  jnz print
  pop bp
  ret 2
end