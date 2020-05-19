.PHONY: all distclean cleaner clean \
        logos apple-touch-icons boot-splashes favicons
.PRECIOUS: shiva-rot-*.png

LOGOEXT=png
LOGO=logo.$(LOGOEXT)
LOGO_VISIBLE=logo-visible.$(LOGOEXT)
ANIMEXT=gif
LOGO_ANIM=logo-animated.$(ANIMEXT)

WGET=wget -nc -O $@
CONVERT=convert -quality 100
RM=rm -fv

all: logos apple-touch-icons boot-splashes favicons



apple-touch-icons: apple-touch-icon-152x152.png \
                   apple-touch-icon-120x120.png \
                   apple-touch-icon-76x76.png   \
                   apple-touch-icon-60x60.png
apple-touch-icon-%.png: $(LOGO)
	$(CONVERT) -resize $(patsubst apple-touch-icon-%.png,%,$@) $^ $@



boot-splashes: grub-splash.xpm.gz \
               syslinux-splash.bmp
grub-splash.xpm.gz: grub-splash.xpm
	pigz -c9 $^ > $@
grub-splash.xpm: $(LOGO_VISIBLE)
	$(CONVERT) -resize 640x480 -colors 14 $^ $@

syslinux-splash.bmp: $(LOGO_VISIBLE)
	$(CONVERT) -resize 640x480 -colors 14 -depth 16 $^ $@



favicons: favicon.ico
favicon.ico: favicon-8x8.ico   \
             favicon-16x16.ico \
             favicon-32x32.ico \
             favicon-64x64.ico
	$(CONVERT) $^ $@
favicon-%.ico: $(LOGO_VISIBLE)
	DIM=$(patsubst favicon-%.ico,%,$@) $(SHELL) -c \
	'$(CONVERT) -resize $$DIM -gravity center -crop $$DIM+0+0 -flatten -colors 256 $^ $@'



logos: $(LOGO) $(LOGO_VISIBLE) $(LOGO_ANIM)

GENLOGO=composite -quality 100 -blend $$BLEND -gravity center $^ $@

$(LOGO): shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=10 $(SHELL) -c '$(GENLOGO)'
$(LOGO_VISIBLE): shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=50 $(SHELL) -c '$(GENLOGO)'

TRANCE=7.83
SCALE=2
FPS=20
DEG=$(shell  echo 'scale=$(SCALE); 360 * $(TRANCE) / $(FPS)' | bc)
NROT=$(shell echo 'scale=$(SCALE); 360 * $(TRANCE) / $(DEG)' | bc)

$(LOGO_ANIM): $(foreach d,$(shell seq $(NROT)),logo-rot-$(shell echo 'scale=$(SCALE); $(d) * $(DEG)' | bc).$(LOGOEXT))
	$(CONVERT) $^ -loop 0 -delay 20 $@

logo-rot-%.$(LOGOEXT): shiva-rot-%.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=30 $(SHELL) -c '$(GENLOGO)'
shiva-rot-%.$(LOGOEXT): shiva-resize.$(LOGOEXT)
	$(CONVERT) -rotate $(patsubst shiva-rot-%.$(LOGOEXT),%,$@) $^ $@

#shiva-resize.$(LOGOEXT): shiva-transparent.$(LOGOEXT) kali.dim
shiva-resize.$(LOGOEXT): shiva-2.$(LOGOEXT) kali.dim
	$(CONVERT) $< -resize `cat kali.dim`\< -gravity center -extent `cat kali.dim` -fuzz 90% -transparent white $@
kali.dim: kali.$(LOGOEXT)
	identify -ping -format '%wx%h' $< > $@

shiva-transparent.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $^ -fuzz 90% -transparent white $@
shiva-2.$(LOGOEXT): shiva.$(LOGOEXT)
	$(CONVERT) $< -colorspace gray -colors 2 -type bilevel $@

%.$(LOGOEXT): %.jpg
	$(CONVERT) $^ $@
kali.jpg:
	$(WGET) http://www.kalibhakti.com/wp-content/uploads/2012/09/kali-yantra-effects.jpg
shiva.jpg:
	$(WGET) https://clipartstation.com/wp-content/uploads/2018/10/natraj-clipart-7.jpg



distclean: cleaner
	$(RM) shiva.jpg kali.jpg
cleaner: clean
	$(RM) $(LOGO) $(LOGO_VISIBLE) $(LOGO_ANIM)
	$(RM) apple-touch-icon-*.png
	$(RM) syslinux-splash.bmp grub-splash.xpm.gz
	$(RM) favicon*.ico
clean:
	$(RM) kali.dim kali.$(LOGOEXT) shiva*.$(LOGOEXT) logo-rot-*.$(LOGOEXT) shiva-rot-*.$(LOGOEXT) logo-animated-*.$(LOGOEXT) favicon-*.ico
	$(RM) grub-splash.xpm

