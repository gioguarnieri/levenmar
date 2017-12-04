set terminal pngcairo size 1366,768
set output "todasregXXX.png"
plot 'ymodXXX.1.dat' t 'chute=1', 'ymodXXX.2.dat' t 'chute=2', 'ymodXXX.3.dat' t 'chute=3', 'ymodXXX.4.dat' t 'chute=4', 'ymodXXX.5.dat' t 'chute=5', 'ymodXXX.6.dat' t 'chute=6', 'ymodXXX.7.dat' t 'chute=7', 'ymodXXX.8.dat' t 'chute=8', 'ymodXXX.9.dat' t 'chute=9', 'ymodXXX.10.dat' t 'chute=10', 'ymodXXX.11.dat' t 'chute=11', 'ymodXXX.12.dat' t 'chute=12', '1.dat' w l t 'valor real'
set output
set output "regxchuteXXX.png"
set grid lw 2
a=(XXX*0.05-0.05)
title1= sprintf("Spread = %.3f",a)
set xlabel "Acréscimo e decrescimo no chute"
set ylabel "Diferença entre difusão calculada e real"
set title title1
plot 'todasmediasXXX.dat' u ($0*0.5+1-6)*10**(-7):($2-6*10**(-7)) w lp t 'Difusões calculadas para cada chute', 0 t 'Valor real da difusão' lw 2
set output

