# Compiling flags
CFLAGS = -O3 -I/opt/homebrew/opt/pgplot/include -I/opt/homebrew/opt/fftw/include -I/opt/homebrew/opt/sox/include -I/opt/homebrew/opt/cmocka/include

# Linking flags
LFLAGS = -L/opt/homebrew/opt/pgplot/lib -L/opt/X11/lib -L/opt/homebrew/opt/gsl/lib -L/opt/homebrew/opt/fftw/lib -L/opt/homebrew/opt/sox/lib -lcpgplot -lpgplot -lX11 -lpng -lm -lgsl -lgslcblas -L/opt/homebrew/opt/sox/include

# Compiler
CC = gcc

# Installation
INSTALL_PROGRAM = install -m 755
prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin

all:
	make rfedit rfplot rffft rfpng rffit rffind rfdop

rffit: rffit.o sgdp4.o satutl.o deep.o ferror.o dsmin.o simplex.o versafit.o rfsites.o rftles.o
	gfortran -o rffit rffit.o sgdp4.o satutl.o deep.o ferror.o dsmin.o simplex.o versafit.o rfsites.o rftles.o $(LFLAGS)

rfpng: rfpng.o rftime.o rfio.o rftrace.o sgdp4.o satutl.o deep.o ferror.o rftles.o zscale.o
	gfortran -o rfpng rfpng.o rftime.o rfio.o rftrace.o sgdp4.o satutl.o deep.o ferror.o rftles.o zscale.o $(LFLAGS)

rfdop: rfdop.o rftrace.o rfio.o rftime.o sgdp4.o satutl.o deep.o ferror.o rftles.o zscale.o
	$(CC) -o rfdop rfdop.o rftrace.o rfio.o rftime.o sgdp4.o satutl.o deep.o ferror.o rftles.o zscale.o -lm

rfedit: rfedit.o rfio.o rftime.o zscale.o
	$(CC) -o rfedit rfedit.o rfio.o rftime.o zscale.o -lm

rffind: rffind.o rfio.o rftime.o zscale.o
	$(CC) -o rffind rffind.o rfio.o rftime.o zscale.o -lm

rftrack: rftrack.o rfio.o rftime.o rftrace.o sgdp4.o satutl.o deep.o ferror.o zscale.o
	$(CC) -o rftrack rftrack.o rfio.o rftime.o rftrace.o sgdp4.o satutl.o deep.o ferror.o zscale.o -lm

rfplot: rfplot.o rftime.o rfio.o rftrace.o sgdp4.o satutl.o deep.o ferror.o versafit.o dsmin.o simplex.o rftles.o zscale.o
	gfortran -o rfplot rfplot.o rftime.o rfio.o rftrace.o sgdp4.o satutl.o deep.o ferror.o versafit.o dsmin.o simplex.o rftles.o zscale.o $(LFLAGS)

rffft: rffft.o rffft_internal.o rftime.o
	$(CC) -o rffft rffft.o rffft_internal.o rftime.o -L/opt/homebrew/opt/fftw/lib -L/opt/homebrew/opt/sox/lib -lfftw3f -lsox -lm

tests/tests: tests/tests.o tests/tests_rffft_internal.o tests/tests_rftles.o rffft_internal.o rftles.o satutl.o ferror.o
	$(CC) -Wall -o $@ $^ -L/opt/homebrew/opt/cmocka/lib -lcmocka -lm

tests: tests/tests
	./tests/tests

.PHONY: clean install uninstall tests

clean:
	rm -f *.o tests/*.o
	rm -f *~

install:
	$(INSTALL_PROGRAM) rffit $(DESTDIR)$(bindir)/rffit
	$(INSTALL_PROGRAM) rfpng $(DESTDIR)$(bindir)/rfpng
	$(INSTALL_PROGRAM) rfedit $(DESTDIR)$(bindir)/rfedit
	$(INSTALL_PROGRAM) rffind $(DESTDIR)$(bindir)/rffind
	$(INSTALL_PROGRAM) rfplot $(DESTDIR)$(bindir)/rfplot
	$(INSTALL_PROGRAM) rffft $(DESTDIR)$(bindir)/rffft
	$(INSTALL_PROGRAM) tleupdate $(DESTDIR)$(bindir)/tleupdate

uninstall:
	$(RM) $(DESTDIR)$(bindir)/rffit
	$(RM) $(DESTDIR)$(bindir)/rfpng
	$(RM) $(DESTDIR)$(bindir)/rfedit
	$(RM) $(DESTDIR)$(bindir)/rffind
	$(RM) $(DESTDIR)$(bindir)/rfplot
	$(RM) $(DESTDIR)$(bindir)/rffft
	$(RM) $(DESTDIR)$(bindir)/tleupdate
