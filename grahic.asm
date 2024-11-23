section .data
    fmt db "%.2f", 10, 0  ; формат для вывода числа с плавающей точкой
    two dq 2.0
    neg_two dq -2.0
    neg_half dq -0.5
    three dq 3.0
    four dq 4.0
    neg4 dq -4.0
    neg6 dq -6.0
    neg8 dq -8.0

section .bss
    num resb 20           ; резервируем 20 байт для ввода числа
    result resq 1         ; резервируем 8 байт для результата

section .text
    extern printf
    global main

main:
    ; Читаем число с консоли
    mov eax, 3             ; syscall: sys_read
    mov ebx, 0             ; файл: stdin
    mov ecx, num           ; буфер для хранения числа
    mov edx, 20            ; максимальное количество байт для чтения
    int 0x80               ; вызов ядра

    ; Определяем диапазон и вычисляем y
    fst st0                ; сохраняем значение в st0 для дальнейших вычислений
    fld st0                ; дублируем значение
    fadd qword [neg8]   ; x + 8
    fmul st0, st0          ; (x + 8)^2
    fsub qword [four]      ; 4 - 4 * (x + 8)^2
    fsqrt                   ; sqrt(4 - 4(x + 8)^2)

    ; Проверяем диапазоны
    fld st1                ; загружаем значение x снова
    fcom qword [neg6]      ; сравниваем с -6
    fstsw ax               ; сохраняем флаги в ax
    sahf                   ; загружаем флаги в регистры
    jc below_neg6          ; если x < -6, перейти

    ; -6 <= x <= -4
    fld qword [two]        ; y = 2
    jmp print_result

below_neg6:
    fld st1                ; загружаем x снова
    fadd qword [neg8]      ; (x + 8)
    fmul st0               ; 2 + sqrt(4 - 4(x + 8)^2)
    fadd qword [two]       ; 2 + ...
    fld st0                ; дублируем результат
    fdiv qword [two]       ; (2 + sqrt(...))/2
    fstp qword [result]    ; сохраняем результат

    ; Проверяем второй диапазон
    fld st1                ; загружаем x снова
    fcom qword [neg4]      ; сравниваем с -4
    fstsw ax               ; сохраняем флаги в ax
    sahf                   ; загружаем флаги в регистры
    jc below_neg4          ; если x < -4, перейти

negative_four_to_two:
    fld st1                ; загружаем x снова
    fmul qword [neg_half]  ; y = -1/2 * x
    fstp qword [result]    ; сохраняем результат
    jmp print_result

below_neg4:
    fld st1                ; загружаем x снова
    fsub qword [three]     ; y = x - 3
    fstp qword [result]    ; сохраняем результат

    fld qword [two]  ; Использовать просто как пример

    ; После расчетов
    fstp qword [result]  ; сохраняем результат в памяти

    ; Выводим результат
print_result:
    mov rdi, fmt          ; формат
    mov rsi, [result]     ; передаем результат
    call printf           ; печатаем результат

    ; Завершаем программу
    mov eax, 1            ; syscall: sys_exit
    xor ebx, ebx          ; код завершения: 0
    int 0x80              ; вызов ядра
