#!/bin/bash

for i in $(seq 2 7)
do
 cd /home/giovanni/Documents/levenmar/levenmar/simulações
 mkdir ${i}
 cd ${i}
 cp /home/giovanni/Documents/levenmar/levenmar/dados/${i}*.dat . 
 for ii in $(seq 1 12)
 do
  mkdir spread${i}.diffusion${ii}
  cd spread${i}.diffusion${ii}
  for iii in $(seq 1 6)
  do
   echo ${i} ${ii} ${iii}
   mkdir spread${i}.diffusion${ii}.num${iii}
   cd spread${i}.diffusion${ii}.num${iii}
   cp /home/giovanni/Documents/levenmar/levenmar/dados/${i}.${iii}.dat .
   cp /home/giovanni/Documents/levenmar/levenmar/levenmar.for ./${i}.${ii}.${iii}_levenmar.for
   sed -i s/XXX/${i}.${iii}/g ${i}.${ii}.${iii}_levenmar.for
   sed -i s/YYY/${ii}/g ${i}.${ii}.${iii}_levenmar.for
   gfortran ${i}.${ii}.${iii}_levenmar.for -o ${i}.${ii}.${iii}.out
   ./${i}.${ii}.${iii}.out
   cat saida${i}.${iii}.DAT >> ../todasdifu${i}.${ii}.dat
   cd ../
   cp todasdifu${i}.${ii}.dat ../
  done
 cd ../
 done
done

  
   
  
