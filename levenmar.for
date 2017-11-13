      PROGRAM LEVENMARQ
C 
C               Montado para ajustar dados de difusao
C  Usando a solução de difusão em um disco circular de espessura l,
C o programa calcula a variação de massas em função do tempo, usando os 
C valores iniciais de massa no tempo infinito (a) e coeficiente de difusão (d).
C Após o cálculo são introduzidos erros aleatórios nos valores calculados, um "guess
C value" é dado para os dois parâmetros (a e d), e os valores iniciais são recalculados
C através do método de Levenberg-Marquardt.
C 
C
        IMPLICIT DOUBLE PRECISION (A-H, O-Z) 
        real*8 a(2),alpha(5,5),covar(5,5),sig(26),x(26),y(26),errper
        real*8 guess(2),api,api2,al,arg,arg1,divid,aa,aa2,ai
        real*8 alamda,dif(6),difu,sigma
        integer nca,ncols,nn,lista(5)
C     Valores iniciais para cálculo
C
C	data a/2.000d-2,6.00d-7/
c	spread = 0.00d0
C
C
         OPEN (8,FILE='saida1.DAT')
         OPEN (9,FILE='saiu1.dat')
         OPEN (10,FILE='1.dat')
         OPEN (11,FILE='ymod1.dat')
         OPEN (12,FILE='findus1.txt')
         OPEN (15,FILE='difu_LM1.dat')
         OPEN (16,FILE='errper1.dat')
        iciclo = 1
        difu = 0.0d0
       dif(:)=0.0d0
        nca=5
        ncols=26
C
C      nn -> ordem do desenvolvimento da expansao em N
C
        ndata = ncols     
        nn=40000
        do 234 k=1,ncols
         READ(10,*) x(k),y(k)
         sig(k) = 1.0d0
234     continue
        aux=y(1)
        guess(1) = y(ncols)
        guess(2) = 7e-7 
        lista(:)=0
c        do 456 k=1, ncols
c         y(k)=(y(k)-aux)/aux
c456     continue
        MFIT=2
        MA=MFIT
        do 1 i=1,ma
         lista(i)=i
         a(i)=guess(i)
1       continue
       alamda=-1.0d0
      do 123 i=1,15
      print*, chisq, alamda, i
       call mrqmin(x,y,sig,ndata,a,ma,lista,mfit,covar,alpha,nca,chisq,a
     *lamda,nn)
123   continue
      alamda=0
       call mrqmin(x,y,sig,ndata,a,ma,lista,mfit,covar,alpha,nca,chisq,a
     *lamda,nn)
      print*, "a1 e a2"
      print*, a(1), a(2)


        do 55 k=1,ndata
         api=3.1415926d0
         api2=api*api
         al=0.1d0
         arg=0.d0
         arg1=0.d0
         divid=4.0d0*al*al
         do 111 i=1,400
          j=i-1
          ai=dfloat(j)
          aa=2.0d0*ai+1.0d0
          aa2 = aa*aa
          arg=arg+(exp(-((aa2*api2*a(2)*x(k))/divid)))
          arg1=arg1+((exp(-((aa2*api2*a(2)*x(k))/divid)))/aa2)
111      continue
         ymod=a(1)-(a(1)*((8.0/api2)*arg1))
         write(11,*) x(k),ymod
55      continue
       dif(1) = a(2)
       difu = difu+dif(1)
        sigma = sigma + (dif(1)-difu)**2
       sigma = dsqrt(((1.0d0/(dfloat(ncols)-1.0d0))*sigma))
       write (8,*) '                      '
       write (8,*) '                      '
       write (8,*) 'D = ',a(2), ' +/- ', sigma, ' cm^2/min'
       write (*,*) 'D = ',a(2), ' +/- ', sigma, ' cm^2/min'
       write (15,*) difu, sigma
       errper = dsqrt(((a(2)-6.0d-07)/6.0d-07)**2)
       write(16,*) errper
      close(8)
      close(9)
      CLOSE (10)
      close(12)
      close(15)
      write(*,*) a
      stop
      end

C 
C            MRQMIN
C
      SUBROUTINE mrqmin(x,y,sig,ndata,a,ma,lista,mfit,covar,alpha,nca,
     *chisq,alamda,nn)
      IMPLICIT DOUBLE PRECISION (A-H, O-Z) 
      PARAMETER (nmax=30)
      real*8 x(ndata),y(ndata),sig(ndata),a(ma)
      real*8 covar(nca,nca),alpha(nca,nca),atry(ma)
      real*8 ochisq,chisq,beta(nmax),da(nmax),alamda
      integer lista(ma),ihit
      if(alamda.lt.0.d0)then
      	kk=mfit+1
        do 12 j=1,ma
          ihit=0
              do 11 k=1,mfit
              if(lista(k).eq.j) ihit=ihit+1
11            continue
            if(ihit.eq.0) then
            lista(kk)=j
            kk=kk+1
            else if(ihit.gt.1) then
            print*, 'permutacao impropria em lista'
		return
           endif
12      continue
        alamda=0.0010d0
C
C       Chamada de mrqcof
C
      call mrqcof(x,y,sig,ndata,a,ma,lista,mfit,alpha,beta,nca,chisq,
     *nn)
        ochisq=chisq
        do 13 j=1,ma
          atry(j)=a(j)
13      continue
      endif
      do 15 j=1,mfit
         do 14 k=1,mfit
         covar(j,k)=alpha(j,k)
14       continue
      covar(j,j)=alpha(j,j)*(1.0d0+alamda)
      da(j)=beta(j)
15    continue
C
C     Chamada de Gauss
C
      call gaussj(covar,mfit,nca,da,1,1)
      if(alamda.eq.0.d0)then
        call covsrt(covar,nca,ma,lista,mfit)
      endif
C
C       Termina o "if" inicial
C
      do 16 j=1,mfit
         atry(lista(j))=a(lista(j))+da(j)
16    continue
	 ochisq=chisq
      call mrqcof(x,y,sig,ndata,atry,ma,lista,mfit,alpha,beta,nca,chisq,
     *nn)
C	write(*,*) 'fim do if inicial', ochisq,chisq
       if(chisq.lt.ochisq)then
        alamda=0.1d0*alamda
        ochisq=chisq
        do 18 j=1,mfit
           do 17 k=1,mfit
           alpha(j,k)=covar(j,k)
17         continue
            beta(j)=da(j)
            a(lista(j))=atry(lista(j))
18      continue
      else
        alamda=10.0d0*alamda
        chisq=ochisq
      endif
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software #>,13.
C
C               MRQCOF
C      
      SUBROUTINE mrqcof(x,y,sig,ndata,a,ma,lista,mfit,alpha,beta,nalp,
     *chisq,nn)
      IMPLICIT DOUBLE PRECISION (A-H, O-Z) 
      PARAMETER (MMAX=30)
      real*8 x(ndata),y(ndata), sig(ndata),alpha(nalp,nalp),beta(ma)
      real*8 dyda(mmax),a(ma),chisq,ochisq,dy,ymod,sig2i
	integer lista(mfit)
       do 12 j=1,mfit
             do 11 k=1,j
             alpha(j,k)= 0.0d0
11           continue
       beta(j)=0.0d0
12      continue
      chisq=0.0d0
      do 15 i=1,ndata
C	xx=x(i)
        call funcs(x(i),a,ymod,dyda,ma,nn)
        sig2i=1.0d0/(sig(i)*sig(i))
        dy=y(i)-ymod
        do 14 j=1,mfit
            wt=dyda(lista(j))*sig2i
            do 13 k=1,j
                alpha(j,k)=alpha(j,k)+wt*dyda(lista(k))
13          continue
            beta(j)=beta(j)+dy*wt
14      continue
        chisq=chisq+dy*dy*sig2i
15    continue
      do 17 j=2,mfit
        do 16 k=1,j-1
          alpha(k,j)=alpha(j,k)
16      continue
17    continue
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software #>,13.
C
C               GAUSSJ
C
      SUBROUTINE gaussj(a,n,np,b,m,mp)
      IMPLICIT DOUBLE PRECISION (A-H, O-Z) 
      PARAMETER (nmax=30)
      real*8 a(np,np),b(np,mp),big,dum,pivinv
	integer ipiv(nmax),indxr(nmax),indxc(nmax)
	integer irow,icol
      do 11 j=1,n
        ipiv(j)=0
11    continue
      do 22 i=1,n
        big=0.d0
        do 13 j=1,n
          if(ipiv(j).ne.1)then
            do 12 k=1,n
              if (ipiv(k).eq.0) then
                if (dabs(a(j,k)).ge.big)then
                  big=dabs(a(j,k))
                  irow=j
                  icol=k
                endif
              else if (ipiv(k).gt.1) then
                write(*,*) 'singular matrix in gaussj1'
	stop
              endif
12          continue
          endif
13      continue
        ipiv(icol)=ipiv(icol)+1
        if (irow.ne.icol) then
          do 14 l=1,n
            dum=a(irow,l)
            a(irow,l)=a(icol,l)
            a(icol,l)=dum
14        continue
          do 15 l=1,m
            dum=b(irow,l)
            b(irow,l)=b(icol,l)
            b(icol,l)=dum
15        continue
        endif
        indxr(i)=irow
        indxc(i)=icol
        if (a(icol,icol).eq.0.) then
	write(*,*) 'singular matrix in gaussj2'
	exit
	endif
        pivinv=1.0d0/a(icol,icol)
        a(icol,icol)=1.0d0
        do 16 l=1,n
          a(icol,l)=a(icol,l)*pivinv
16      continue
        do 17 l=1,m
          b(icol,l)=b(icol,l)*pivinv
17      continue
        do 21 ll=1,n
          if(ll.ne.icol)then
            dum=a(ll,icol)
            a(ll,icol)=0.
            do 18 l=1,n
              a(ll,l)=a(ll,l)-a(icol,l)*dum
18          continue
            do 19 l=1,m
              b(ll,l)=b(ll,l)-b(icol,l)*dum
19          continue
          endif
21      continue
22    continue
      do 24 l=n,1,-1
        if(indxr(l).ne.indxc(l))then
          do 23 k=1,n
            dum=a(k,indxr(l))
            a(k,indxr(l))=a(k,indxc(l))
            a(k,indxc(l))=dum
23        continue
        endif
24    continue
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software #>,13.
C
C   COVSRT
C
      SUBROUTINE covsrt(covar,ncvm,ma,lista,mfit)
      IMPLICIT DOUBLE PRECISION (A-H, O-Z) 
      real*8 covar(ncvm,ncvm),swap
	integer lista(mfit)
      do 12 j=1,ma-1
        do 11 i=j+1,ma
          covar(i,j)=0.d0
11      continue
12    continue
      do 14 i=1,mfit-1
          do 13 j=i+1,mfit
          if(lista(j).gt.lista(i)) then
                covar(lista(i),lista(j))=covar(i,j)
                        else
                covar(lista(j),lista(i))=covar(i,j)
          endif
13        continue
14        continue
       swap=covar(1,1)
       do 15 j=1,ma
       covar(1,j)=covar(j,j)
       covar(j,j)=0.d0
15     continue
       covar(lista(1),lista(1))=swap
       do 16 j=2,mfit
        covar(lista(j),lista(j))=covar(1,j)
16     continue
       do 18 j=2,ma
       do 17 i=1,j-1
       covar(i,j)=covar(j,i)
17     continue
18     continue
       return
        END
C  (C) Copr. 1986-92 Numerical Recipes Software #>,13.
C
C     Funcao a ser optimizada
C
	subroutine funcs(x,a,ymod,dyda,na,nn)
        IMPLICIT DOUBLE PRECISION (A-H, O-Z) 
	real*8 a(na),dyda(na),api,api2,al,arg,arg1
	real*8 divid,ai,aa,aa2,ymod
	integer na,nn
	api=3.141592653589793d0
        api2=api*api
	al=1.0d-1
	arg=0.d0
	arg1=0.d0
        divid=4.0d0*al*al
	do 1 i=1,nn
	j=i-1
	ai=dfloat(j)
	aa=2.0d0*ai+1.0d0
        aa2 = aa*aa
	arg=arg+(exp(-((aa2*api2*a(2)*x)/divid)))
        arg1=arg1+((exp(-((aa2*api2*a(2)*x)/divid)))/aa2)
1	continue
	ymod=a(1)-(a(1)*((8.0/api2)*arg1))
	dyda(1)=1.0-(8.0/api2)*arg1
	dyda(2)=((2.0d0*a(1)*x)/(al*al))*arg

	RETURN
	END
C
C          Gerador de números aleatórios
C
C
C Subroutine to generate a random number. Routine is from Numerical Recipes,
C and is supposed to be excellent, although a little slower than some other
C routines.
C
      FUNCTION ran3(idum)
      INTEGER idum
C      INTEGER MBIG,MSEED,MZ
      REAL*8 MBIG,MSEED,MZ
      REAL*8 ran3,FAC
      PARAMETER (MBIG=1000000000.,MSEED=161803398.,MZ=0,FAC=1./MBIG)
C     PARAMETER (MBIG=4000000.d0,MSEED=1618033.d0,MZ=0.d0,FAC=1.d0/MBIG)
      INTEGER i,iff,ii,inext,inextp,k
C      INTEGER mj,mk,ma(55)
      REAL*8 mj,mk,ma(55)
      SAVE iff,inext,inextp,ma
      DATA iff /0/
      if(idum.lt.0.or.iff.eq.0)then
        iff=1
        mj=MSEED-iabs(idum)
        mj=dmod(mj,MBIG)
        ma(55)=mj
        mk=1
        do 11 i=1,54
          ii=mod(21*i,55)
          ma(ii)=mk
          mk=mj-mk
          if(mk.lt.MZ)mk=mk+MBIG
          mj=ma(ii)
11      continue
        do 13 k=1,4
          do 12 i=1,55
            ma(i)=ma(i)-ma(1+mod(i+30,55))
            if(ma(i).lt.MZ)ma(i)=ma(i)+MBIG
12        continue
13      continue
        inext=0
        inextp=31
        idum=1
      endif
      inext=inext+1
      if(inext.eq.56)inext=1
      inextp=inextp+1
      if(inextp.eq.56)inextp=1
      mj=ma(inext)-ma(inextp)
      if(mj.lt.MZ)mj=mj+MBIG
      ma(inext)=mj
      ran3=mj*FAC
      return
      END
