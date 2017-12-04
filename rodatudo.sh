#!/bin/bash

for i in $(seq 2 7)
do
 cd /home/giovanni/Documents/levenmar/levenmar/simulações
 mkdir ${i}
 cd /home/giovanni/Documents/levenmar/levenmar/simulações/${i}
 cp /home/giovanni/Documents/levenmar/levenmar/dados/${i}*.dat . 
 cp /home/giovanni/Documents/levenmar/levenmar/valx.dat .
 for ii in $(seq 1 12)
 do
  mkdir spread${i}.diffusion${ii}
  for iii in $(seq 1 6)
  do
   cd /home/giovanni/Documents/levenmar/levenmar/simulações/${i}/spread${i}.diffusion${ii}/
   echo ${i} ${ii} ${iii}
   mkdir spread${i}.diffusion${ii}.num${iii}
   cd /home/giovanni/Documents/levenmar/levenmar/simulações/${i}/spread${i}.diffusion${ii}/spread${i}.diffusion${ii}.num${iii}
   cp /home/giovanni/Documents/levenmar/levenmar/dados/${i}.${iii}.dat .
   cp /home/giovanni/Documents/levenmar/levenmar/levenmar.for ./${i}.${ii}.${iii}_levenmar.for
   sed -i s/XXX/${i}.${iii}/g ${i}.${ii}.${iii}_levenmar.for
   sed -i s/YYY/${ii}/g ${i}.${ii}.${iii}_levenmar.for
   gfortran ${i}.${ii}.${iii}_levenmar.for -o ${i}.${ii}.${iii}.out
   ./${i}.${ii}.${iii}.out
   cat saida${i}.${iii}.DAT >> /home/giovanni/Documents/levenmar/levenmar/simulações/${i}/todasdifu${i}.${ii}.dat
   cd /home/giovanni/Documents/levenmar/levenmar/simulações/${i}
   cp /home/giovanni/Documents/levenmar/levenmar/media.py .
   ./media.py ./todasdifu${i}.${ii}.dat mediatodasdifu${i}.${ii}.dat
   cat mediatodas* > todasmedias${i}rm.dat
   tail -n 9 todasmedias${i}rm.dat > todasmedias${i}.dat
   head -n 3 todasmedias${i}rm.dat >> todasmedias${i}.dat
   cp /home/giovanni/Documents/levenmar/levenmar/calcymod.for .
   sed -i s/YYY/${i}.${ii}/g calcymod.for
   gfortran calcymod.for -o ymod${i}.${ii}.out
   ./ymod${i}.${ii}.out
  done
 done
 cp /home/giovanni/Documents/levenmar/levenmar/rotina.gp .
 cp /home/giovanni/Documents/levenmar/levenmar/1/1.dat .
 sed -i s/XXX/${i}/g rotina.gp 
 gnuplot rotina.gp
done

  
   
  
