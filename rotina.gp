set terminal pngcairo size 1366,768
set output "todasregXXX.png"
plot 'ymodXXX.1.dat' t 'chute=1', 'ymodXXX.2.dat' t 'chute=2', 'ymodXXX.3.dat' t 'chute=3', 'ymodXXX.4.dat' t 'chute=4', 'ymodXXX.5.dat' t 'chute=5', 'ymodXXX.6.dat' t 'chute=6', 'ymodXXX.7.dat' t 'chute=7', 'ymodXXX.8.dat' t 'chute=8', 'ymodXXX.9.dat' t 'chute=9', 'ymodXXX.10.dat' t 'chute=10', 'ymodXXX.11.dat' t 'chute=11', 'ymodXXX.12.dat' t 'chute=12', '1.dat' w l t 'valor real'
set output
set output "regxchuteXXX.png"
plot 'todasmediasXXX.dat' u $0*10**(-7):2 w lp t 'Difusões calculadas para cada chute', 6e-7 t 'Valor real da difusão'
set output

