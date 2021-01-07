.PHONY: all distclean cleaner clean parts release test stego check check-sh check-misc dist

all:
	MAKE="$(MAKE)" ./make $@
test:
	MAKE="$(MAKE)" ./make $@
release:
	MAKE="$(MAKE)" ./make $@
stego:
	MAKE="$(MAKE)" ./make $@
clean:
	MAKE="$(MAKE)" ./make $@
cleaner:
	MAKE="$(MAKE)" ./make $@
distclean:
	MAKE="$(MAKE)" ./make $@
archive.tar: check
	MAKE="$(MAKE)" ./make $@
#dist: stego
dist:
	[ ! -d .git ]
	MAKE="$(MAKE)" ./make $@

check: check-sh check-misc
check-sh: support.sh
	shellcheck -axs sh $^
check-misc: support-wrapper make
	shellcheck -ax     $^

