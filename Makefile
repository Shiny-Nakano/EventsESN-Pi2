#
#  Makefile
#

FCC = ifx
FP = mpiifx
#FCC = gfortran
#OPT = -r8 -zero -O2 -mcmodel=large
OPT = -r8 -zero -O2 -mcmodel=large -check bounds -traceback -debug -g
#OPT=-fdefault-real-8 -O3
#LIB= -llapack -lblas
FLG = -c
OMP = -qopenmp
LIB = -qmkl=parallel


.SUFFIXES : .f .f90 .o


substorm_pred: mtfort90.o reservoir.o readdata.o substorm_pred.o
	$(FCC) $^ -o $@ $(LIB) $(OMP)

reservoir.o: reservoir.f90
	$(FCC) $(FLG) $(OPT) $(OMP) $*.f90


.f90.o:
	$(FCC) $(FLG) $(OPT) $*.f90

.f.o:
	$(FCC) $(FLG) $(OPT) $*.f

clean:
	rm -f *.o *.mod
