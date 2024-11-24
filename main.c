#include <stdio.h>
#include <math.h>

int main() {
    double x, y;

    // Считываем число
    printf("Введите число: ");
    if (scanf("%lf", &x) != 1) {
        printf("Ошибка ввода.\n");
        return 1;
    }

    // Определяем диапазон x и вычисляем y
    if (x >= -10 && x < -6) {
        double temp = 4 - 4 * pow(x + 8, 2);
        if (temp < 0) {
            printf("Ошибка: корень из отрицательного числа.\n");
            return 1;
        }
        y = (2 + sqrt(temp)) / 2;
    } else if (x >= -6 && x <= -4) {
        y = 2;
    } else if (x > -4 && x <= 2) {
        y = -0.5 * x;
    } else if (x > 2 && x <= 4) {
        y = x - 3;
    } else {
        printf("Число вне диапазонов.\n");
        return 1;
    }

    // Выводим результат
    printf("Результат: y = %lf\n", y);

    return 0;
}
