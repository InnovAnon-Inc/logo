.PHONY: all distclean cleaner clean logos fingerprint parts
.PRECIOUS:  shiva-rot-*.png kali-*.png archive.tar archive.tar.lrz archive.tar.lrz.zpaq archive.tlrzpq archive.tlrzpq.gpg shiva-small.png kali-small.png shiva-2.png shiva.png kali.png shiva.jpg kali.jpg
#.SECONDARY: shiva-rot-*.png kali-*.png archive.tar.lrz archive.tar.lrz.zpaq archive.tlrzpq archive.tlrzpq.gpg

# lrzip/zpaq are already parallel.
# use -j$(nproc) for more parallelization.
# imagemagick is memory-bound
#NPROC=$(shell nproc)

# optional
#PW=-k$(PW)

# mandatory
#RECP=<gpg encryp-to recipient>

#VISIBLE=0.9
#INVISIBLE=0.6
VISIBLE=40
MIDVISIBLE=30
INVISIBLE=10

TRANCE=7.83
SCALE=2
FPS=20
DEG=$(shell  echo 'scale=$(SCALE); 360 * $(TRANCE) / $(FPS)' | bc)
#NROT=$(shell echo 'scale=$(SCALE); 360 * $(TRANCE) / $(DEG)' | bc)
NROT=$(shell echo 'scale=0; 360 * $(TRANCE) / $(DEG)' | bc)

QUALITY?=100
QUAL=-quality $(QUALITY)
LOWQUALITYARGS=-quality $$(($(QUALITY) < 10 ? $(QUALITY) : 10)) -fuzz  7%
LOWQUALITY=convert $(LOWQUALITYARGS)
STRIPEQUALITY=-quality  $$(($(QUALITY) < 5  ? $(QUALITY) : 5))  -fuzz 19%

LOGOEXT=png
LOGO=logo.$(LOGOEXT)
LOGO_VISIBLE=logo-visible.$(LOGOEXT)
LOGO_MIDVISIBLE=logo-midvisible.$(LOGOEXT)
ANIMEXT=gif
LOGO_ANIM=logo-animated.$(ANIMEXT)
LOGO_ANIM_SMALL=logo-small-animated.$(ANIMEXT)

WGET=[ -f $@ ] || curl -o $@ `cat $^`
#WGET=[ -f $@ ] || pcurl `cat $^` $@
RM=rm -fv
IDENTIFY=identify -ping -format

CONVERT=convert $(QUAL)
TRANSPARENT=-fuzz 90% -transparent white
RESIZE=$(CONVERT) -gravity center $(TRANSPARENT)
GENLOGOARGS=-blend $$BLEND -gravity center $^ $@
GENLOGO=composite $(QUAL) $(GENLOGOARGS)
#GENLOGO=$(CONVERT) $^ -gravity center             \
#        \( -clone 0 -alpha extract \)             \
#        \( -clone 1 -clone 2 -alpha off           \
#           -compose copy_opacity -composite       \
#           -alpha on -channel a                   \
#           -evaluate multiply $$BLEND +channel \) \
#        -delete 1,2 -compose overlay -composite $@

# default target
all: logos
logos: $(LOGO_ANIM_SMALL)

# animate
$(LOGO_ANIM_SMALL): $(foreach d,$(shell seq -w 0 1 $$(($(NROT) - 1))),logo-stego-rot-$(d).$(LOGOEXT))
	$(CONVERT) $^ -loop 0 -delay $(FPS) -layers optimize $@
# embed data in logo frames
logo-stego-rot-%.$(LOGOEXT): logo-rot-%.$(LOGOEXT) parts
	[ -f $(patsubst logo-stego-rot-%.$(LOGOEXT),archive.tlrzpq.gpg.part%,$@) ]
	cp -v $< $@
	stegosuite $(PW) -d -f $(patsubst logo-stego-rot-%.$(LOGOEXT),archive.tlrzpq.gpg.part%,$@) $@ || { rm -fv $@ ; exit 2 ; }
# generate logo frames
logo-rot-%.$(LOGOEXT): shiva-rot-%.$(LOGOEXT) kali-%.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'
# dancing shiva
shiva-rot-%.$(LOGOEXT): shiva-small.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -background 'rgba(0,0,0,0)' -rotate $(shell echo 'scale=$(SCALE); $(patsubst shiva-rot-%.$(LOGOEXT),%,$@) * -$(DEG)' | bc) $^ $@

# kali yantra background with randomized fingerprint
kali-%.$(LOGOEXT): random-%.$(LOGOEXT) kali-small.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
random-%.$(LOGOEXT): fingerprint
	head -c "$$((3*256*256))" /dev/urandom | convert -depth 8 -size 256x256 RGB:- $@
fingerprint: # unique every time

# animated logo is 256x256
shiva-small.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(RESIZE) -resize 256x256\> -extent 256x256 $< $@
kali-small.$(LOGOEXT): kali.$(LOGOEXT)
	$(RESIZE) -resize 256x256^ -extent 256x256 $< $@

# shiva image is black (foreground) and white (background)
shiva-2.$(LOGOEXT): shiva.$(LOGOEXT)
	$(CONVERT) $< -colorspace gray -colors 2 -type bilevel $@

# convert images to a lossless format for our conversions
%.$(LOGOEXT): %.jpg
	$(CONVERT) $^ $@
# download source images
kali.jpg: kali.url
	$(WGET)
shiva.jpg: shiva.url
	$(WGET)

# data to hide
archive.tlrzpq.gpg.part%: parts
parts: archive.tlrzpq.gpg
	split -d -n $(NROT) $< $<.part
%.gpg: %
	rm -vf $@
	gpg --encrypt --sign -r $(RECP) -o $@ $<
%.tlrzpq: %.tar.lrz.zpaq
	cp -v $^ $@
%.zpaq: %
	zpaq a $@ $^ -m511.7
%.lrz: %
	lrzip -fUno $@ $^
# TODO strip exe, metadata
%.tar: %
	tar vcf $@ $^

# delete downloaded files, too
distclean: cleaner
	$(RM) shiva.jpg kali.jpg
# delete generated target(s)
cleaner: clean
	$(RM) $(LOGO_ANIM_SMALL) archive.tlrzpq.gpg
# delete intermediate files
clean:
	$(RM) kali*.$(LOGOEXT) shiva*.$(LOGOEXT) \
	      logo-rot-*.$(LOGOEXT) logo-stego-rot-*.$(LOGOEXT) logo-animated-*.$(LOGOEXT) \
	      archive.tar.* archive.tlrzpq archive.tlrzpq.gpg.*

