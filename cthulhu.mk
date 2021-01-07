.PHONY: all distclean cleaner clean \
        logos apple-touch-icons boot-splashes favicons profiles wallpapers release stego test
.PRECIOUS:  cthulhu-rot-*.png
.SECONDARY: cthulhu-rot-*.png

# infinite recursion, optional
LOL ?= 0

#VISIBLE=0.9
#INVISIBLE=0.6
VISIBLE=60
#VISIBLE=40
MIDVISIBLE=30
INVISIBLE=10

TRANCE=7.83
SCALE=2
FPS=20
DEG=$(shell  echo 'scale=$(SCALE); 360 * $(TRANCE) / $(FPS)' | bc)
NROT=$(shell echo 'scale=$(SCALE); 360 * $(TRANCE) / $(DEG)' | bc)

QUALITY?=100
QUAL=-quality $(QUALITY)
LOWQUALITYARGS=-quality $$(($(QUALITY) < 10 ? $(QUALITY) : 10)) -fuzz  7%
LOWQUALITY=convert $(LOWQUALITYARGS)
STRIPEQUALITY=-quality  $$(($(QUALITY) < 5  ? $(QUALITY) : 5))  -fuzz 19%

LOGOEXT=png
LOGO=cthulhu-logo.$(LOGOEXT)
LOGO_VISIBLE=cthulhu-logo-visible.$(LOGOEXT)
LOGO_MIDVISIBLE=cthulhu-logo-midvisible.$(LOGOEXT)
ANIMEXT=gif
LOGO_ANIM=cthulhu-logo-animated.$(ANIMEXT)
LOGO_ANIM_SMALL=cthulhu-logo-small-animated.$(ANIMEXT)

WGET=[ -f $@ ] || curl -o $@ `cat $^`
#WGET=[ -f $@ ] || pcurl `cat $^` $@
RM=rm -fv
IDENTIFY=identify -ping -format

CONVERT=convert $(QUAL)
TRANSPARENT=-fuzz 70% -transparent white -background 'rgba(0,0,0,0)'
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

all: logos 
#test: logo-stego-animated.$(LOGOEXT)
test:
	# extract frames
	convert -coalesce cthulhu-logo-stego-animated.$(ANIMEXT) cthulhu-logo-stego-rot-%02d.$(LOGOEXT)
	# de-stego
	for k in `seq -w 0 1 $$(($(NROT) - 1))` ; do \
	  stegosuite -x -f archive.tlrzpq.gpg.part$(D) cthulhu-logo-stego-rot-%02d.$(LOGOEXT) || exit 2 ; \
	done
	# unsplit
	cat `ls -v archive.tlrzpq.gpg.part*` > archive.tlrzpq.gpg
	# decrypt/verify
	gpg --decrypt -o archive.tlrzpq --yes  archive.tlrzpq.gpg
	# extract
	mv -v            archive.tlrzpq archive.tar.lrz.zpaq
	zpaq x                          archive.tar.lrz.zpaq -f
	lrunzip -f                      archive.tar.lrz
	# run
	chmod -v +x                     archive.tar
	./archive.tar
release:
	LOL=$(LOL) ./quine.sh
	$(MAKE) stego
	[ $(LOL) -eq 0 ] || $(MAKE) test
#logo-stego-animated.$(LOGOEXT): stego
stego:
	$(MAKE) -f stego.mk




favicons: favicon.ico
favicon.ico: favicon-8x8.ico   \
             favicon-16x16.ico \
             favicon-32x32.ico \
             favicon-64x64.ico
	$(CONVERT) $^ $@
favicon-%.ico: $(LOGO_MIDVISIBLE)
	DIM=$(patsubst favicon-%.ico,%,$@) $(SHELL) -c \
	'$(CONVERT) -resize $$DIM -gravity center -crop $$DIM+0+0 -flatten -colors 256 $^ $@'



logos: $(LOGO) $(LOGO_VISIBLE) $(LOGO_MIDVISIBLE)
# $(LOGO_ANIM) $(LOGO_ANIM_SMALL)

#$(LOGO): kali.$(LOGOEXT) cthulhu-resize.$(LOGOEXT)
$(LOGO): cthulhu-resize.$(LOGOEXT) kali-resize.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
#$(LOGO_VISIBLE): kali.$(LOGOEXT) cthulhu-resize.$(LOGOEXT)
$(LOGO_VISIBLE): cthulhu-resize.$(LOGOEXT) kali-resize.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'
$(LOGO_MIDVISIBLE): cthulhu-resize.$(LOGOEXT) kali-resize.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'

cthulhu-logo.txt: cthulhu-logo-visible.$(LOGOEXT)
	img2txt $^ > $@

kali-resize.$(LOGOEXT): kali.$(LOGOEXT) cthulhu.dim
	$(RESIZE) -resize `cat cthulhu.dim`^ -extent `cat cthulhu.dim` $< $@

cthulhu.dim:
	echo 2000x2000 > $@

#cthulhu-resize.$(LOGOEXT): cthulhu-transparent.$(LOGOEXT) cthulhu.dim
cthulhu-resize.$(LOGOEXT): cthulhu-2.$(LOGOEXT) cthulhu.dim
	$(RESIZE) -resize `cat cthulhu.dim`^ -extent `cat cthulhu.dim` $< $@

cthulhu-transparent.$(LOGOEXT): cthulhu.$(LOGOEXT)
	$(CONVERT) $^ $(TRANSPARENT) $@
cthulhu-2.$(LOGOEXT): cthulhu.$(LOGOEXT)
	$(CONVERT) $< -colorspace gray -colors 2 -type bilevel $@

%.$(LOGOEXT): %.jpg
	$(CONVERT) $^ $@
kali.jpg: kali.url
	$(WGET)
cthulhu.jpg: cthulhu.url
	$(WGET)



distclean: cleaner
	$(RM) cthulhu.jpg kali.jpg
	$(MAKE) -f stego.mk distclean
cleaner: clean
	$(RM) $(LOGO) $(LOGO_VISIBLE) $(LOGO_MIDVISIBLE) \
	      $(LOGO_ANIM) $(LOGO_ANIM_SMALL)            \
	      apple-touch-icon-*.png                     \
	      syslinux-splash.bmp grub-splash.xpm.gz     \
	      favicon*.ico github.$(LOGOEXT)             \
	      youtube-banner.$(LOGOEXT)                  \
	      twitter-banner.$(LOGOEXT)                  \
	      linkedin-banner.$(LOGOEXT)                 \
	      soundcloud-banner.$(LOGOEXT)               \
	      doxygen-cthulhu-logo.$(LOGOEXT)                    \
              gpg-cthulhu-logo.jpg avatar.$(LOGOEXT)             \
	      sphinx-cthulhu-logo.$(LOGOEXT)                     \
	      stackoverflow-cthulhu-logo.$(LOGOEXT)              \
	      small-thumbnail.$(LOGOEXT)                 \
	      large-thumbnail.$(LOGOEXT)                 \
	      wallpaper*.$(LOGOEXT) stripe.jpg           \
	      stripe-icon.$(LOGOEXT) cthulhu-logo.txt            \
	      google-cover-cthulhu-logo.$(LOGOEXT)               \
	      youtube-watermark-cthulhu-logo.$(LOGOEXT)          \
	      dtube-banner.$(LOGOEXT)                    \
	      tumblr-banner.$(LOGOEXT)                   \
	      gab-banner.$(LOGOEXT) gab.$(LOGOEXT)       \
	      opencollective-banner.$(LOGOEXT)           \
	      bitbucket.$(LOGOEXT)                       \
	      bitbucket-banner.$(LOGOEXT)                \
	      hashvault-banner.$(LOGOEXT)                \
	      patreon.$(LOGOEXT)                         \
	      patreon-banner.$(LOGOEXT)                  \
	      facebook-banner.$(LOGOEXT)
	$(MAKE) -f stego.mk cleaner
clean:
	$(RM) *.dim kali*.$(LOGOEXT) cthulhu*.$(LOGOEXT)         \
	      cthulhu-logo-rot-*.$(LOGOEXT) cthulhu-logo-animated-*.$(LOGOEXT) \
	      favicon-*.ico grub-splash.xpm *boot.$(LOGOEXT)   \
              tmp*.$(LOGOEXT)
	$(MAKE) -f stego.mk clean

