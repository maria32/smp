name "progr_SMP"
INCLUDE 'emu8086.inc'  


org 100h

lat dw ?
lung dw ?
between_lung dw ?
between_lat dw ?
cmp_lung dw ?
last_lat dw ?


jmp start

intro db "Aceasta este o problema care va calcula suprafata unui dreptunghi", 0Dh, 0Ah, '$'
msg_latime db 0Dh, 0Ah, 'Latime :  $'
msg_lungime db 0Dh, 0Ah, 'Lungime:  $'
rezultat db 0Dh, 0Ah, 'Suprafata este de: $' 

start:  


;enuntul problemei
mov dx, offset intro 
mov ah, 9
int 21h
 
 
 
 
;latime
lea dx, msg_latime       
mov ah, 09h    ; output string at ds:dx
int 21h 
 

call scan_num
mov lat, cx


putc 0Dh  ;linie noua
putc 0Ah

mov ax, lat
call print_num  ; printare latime

putc 0Dh  ;linie noua
putc 0Ah




;lungime
lea dx, msg_lungime       
mov ah, 09h    ; output string at ds:dx
int 21h  

call scan_num
mov lung, cx


putc 0Dh  ;linie noua
putc 0Ah

mov ax, lung
call print_num

putc 0Dh   ;linie noua
putc 0Ah

;rezultat
lea dx, rezultat       
mov ah, 09h    ; output string at ds:dx
int 21h 
 
mov ax, lat
mov bx, lung
mul bx         ;ax=ax*bx  
call print_num


putc 0Dh  ;linie noua
putc 0Ah
                 
                 
                 
                 
                 
;===========================================
;------------grafica 3D---------------------
                 
jmp code 

init_cx equ 100
init_dx equ 30

code: mov ah, 0
    mov al, 13h ; trecere in mod grafic 3init_dxxinit_dx0
    int 10h

;===================================   
;-pregatire desenare dreptunghi fata

; afisare latura superioara    
    mov dx, lat  
    sar dx, 1     
    add dx, init_dx   
    mov between_lat, dx
     
    mov dx, between_lat 
    add dx, lat
    mov last_lat, dx    
    
    mov dx, between_lat
 
    mov cx, lat  
    sar cx, 1     
    mov bx, init_cx   
    sub bx, cx
    mov cmp_lung, bx
    
    mov bx, lat
    sar bx, 1  
    mov cx, init_cx
    add cx, lung     
    sub cx, bx   
    mov between_lung, cx
    
    mov al, 4

u12:mov ah, 0ch ; afisare pixel
    int 10h
    dec cx
    cmp cx, cmp_lung
    jae u12

; afisare latura inferioara    
mov cx, between_lung
mov dx, last_lat
mov al, 4

u22:mov ah, 0ch
    int 10h
    dec cx
    cmp cx, cmp_lung
    ja u22

; afisare latura din stanga
mov cx, cmp_lung
mov dx, last_lat
mov al, 4           ;culoare Red

u32: mov ah, 0ch
    int 10h
    dec dx
    cmp dx, between_lat
    ja u32

; afisare latura din dreapta
mov cx, between_lung
mov dx, last_lat
mov al, 4
    
u42: mov ah, 0ch
    int 10h
    dec dx
    cmp dx, between_lat
    ja u42

;=======================================
;----------adancime-desenare------------

;afisare oblica stanga sus
mov cx, init_cx
mov dx, init_dx
mov al, 2           ;culoare Green

u13:mov ah, 0ch ; afisare pixel
    int 10h
    dec cx
    add dx, 1
    cmp cx, cmp_lung
    jae u13

; afisare oblica dreapta sus    
mov cx, between_lung
mov dx, init_dx
mov al, 2
   ;calculare punct extrem
    mov bx, lung
    add bx, init_cx
    mov cx, bx 
    
u23:mov ah, 0ch
    int 10h
    dec cx
    add dx, 1
    cmp cx, between_lung
    ja u23

; afisare oblica stanga jos
mov cx, init_cx
mov dx, init_dx
add dx, lat
mov al, 2           ;culoare Red

u33: mov ah, 0ch
    int 10h
    sub cx, 2
    add dx, 2
    cmp cx, cmp_lung
    ja u33

; afisare oblica dreapta jos
mov cx, init_cx
add cx, lung
mov dx, init_dx
add dx, lat
mov al, 2
   
u43: mov ah, 0ch
    int 10h
    dec cx
    add dx, 1
    cmp cx, between_lung
    ja u43

;======================================
;-----------dreptunghiul din spate-----

; afisare latura superioara 
mov cx, init_cx
add cx, lung ; coloana
mov dx, init_dx ; rand
mov al, 15 ; alb

u1: mov ah, 0ch ; afisare pixel
    int 10h
    dec cx
    cmp cx, init_cx
    jae u1

; afisare latura inferioara
mov cx, init_cx
add cx, lung
mov dx, init_dx
add dx, lat
mov al, 15
u2: mov ah, 0ch
    int 10h
    sub cx, 4
    cmp cx, init_cx
    ja u2

; afisare latura din stanga
mov cx, init_cx
mov dx, init_dx
add dx, lat
mov al, 15
u3: mov ah, 0ch
    int 10h
    sub dx, 4
    cmp dx, init_dx
    ja u3

; afisare latura din dreapta
mov cx, init_cx
add cx, lung
mov dx, init_dx
add dx, lat
mov al, 15    
u4: mov ah, 0ch
    int 10h
    dec dx
    cmp dx, init_dx
    ja u4                           
    
     
; asteptare apasare tasta
mov ah,00
int 16h
 
     
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

