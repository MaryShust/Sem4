section .bss
    num resb 10          ; резервируем 10 байт для числа

section .text
    global _start

_start:
    ; Считываем число с консоли
    mov eax, 3          ; syscall: sys_read
    mov ebx, 0          ; файл: stdin
    mov ecx, num        ; буфер для хранения числа
    mov edx, 10         ; максимальное количество байт для чтения
    int 0x80            ; вызов ядра

    ; Выводим число на консоль
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; файл: stdout
    mov ecx, num        ; буфер с числом
    mov edx, 10         ; количество байт для вывода
    int 0x80            ; вызов ядра

    ; Завершаем программу
    mov eax, 1          ; syscall: sys_exit
    xor ebx, ebx        ; код завершения: 0
    int 0x80            ; вызов ядра
