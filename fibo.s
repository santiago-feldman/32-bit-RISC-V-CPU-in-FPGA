.global _boot
.text

N = 30;
INICIO_TABLA = 0x1;

.macro imprimir inicio, n, puntero
	lui \puntero, \inicio
	.rept \n-1
    	addi \puntero, \puntero, 4
    .endr
.endm

_boot:
    addi x5, x0, N-2
    lui x4, INICIO_TABLA
    addi x1, x0, 0
    addi x2, x0, 1
    sw x1, 0(x4)
    sw x2, 4(x4)
    addi x4, x4, 8
    repetir:
        add x3, x1, x2
        sw x3, (x4)
        addi x1, x2, 0
        addi x2, x3, 0
        addi x4, x4, 4
        addi x5, x5, -1
        bne x5, x0, repetir
	imprimir INICIO_TABLA, N, x4
    fin:
	beq x0, x0, fin 