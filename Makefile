.PHONY: all distclean cleaner clean \
        logos apple-touch-icons boot-splashes favicons profiles
.PRECIOUS:  shiva-rot-*.png
.SECONDARY: shiva-rot-*.png

#VISIBLE=0.9
#INVISIBLE=0.6
VISIBLE=30
INVISIBLE=10

TRANCE=7.83
SCALE=2
FPS=20
DEG=$(shell  echo 'scale=$(SCALE); 360 * $(TRANCE) / $(FPS)' | bc)
NROT=$(shell echo 'scale=$(SCALE); 360 * $(TRANCE) / $(DEG)' | bc)

QUALITY?=100
QUAL=-quality $(QUALITY)

LOGOEXT=png
LOGO=logo.$(LOGOEXT)
LOGO_VISIBLE=logo-visible.$(LOGOEXT)
ANIMEXT=gif
LOGO_ANIM=logo-animated.$(ANIMEXT)

WGET=[ -f $@ ] || wget -nc -O $@ `cat $^`
RM=rm -fv
IDENTIFY=identify -ping -format

CONVERT=convert $(QUAL)
TRANSPARENT=-fuzz 90% -transparent white
RESIZE=$(CONVERT) -gravity center $(TRANSPARENT)
GENLOGO=composite $(QUAL) -blend $$BLEND -gravity center $^ $@
#GENLOGO=$(CONVERT) $^ -gravity center             \
#        \( -clone 0 -alpha extract \)             \
#        \( -clone 1 -clone 2 -alpha off           \
#           -compose copy_opacity -composite       \
#           -alpha on -channel a                   \
#           -evaluate multiply $$BLEND +channel \) \
#        -delete 1,2 -compose overlay -composite $@

all: logos apple-touch-icons boot-splashes favicons profiles



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



profiles: github.$(LOGOEXT)
github.$(LOGOEXT): $(LOGO_VISIBLE)
	$(RESIZE) -resize 500x500\< -extent 500x500 $< $@



logos: $(LOGO) $(LOGO_VISIBLE) $(LOGO_ANIM)

#$(LOGO): kali.$(LOGOEXT) shiva-resize.$(LOGOEXT)
$(LOGO): shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
#$(LOGO_VISIBLE): kali.$(LOGOEXT) shiva-resize.$(LOGOEXT)
$(LOGO_VISIBLE): shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'

$(LOGO_ANIM): logo-rot-0.$(LOGOEXT) $(foreach d,$(shell seq $(NROT)),logo-rot-$(shell echo 'scale=$(SCALE); $(d) * -$(DEG)' | bc).$(LOGOEXT))
	$(CONVERT) $^ -loop 0 -delay $(FPS) $@

#logo-rot-%.$(LOGOEXT): kali.$(LOGOEXT) shiva-rot-%.$(LOGOEXT)
logo-rot-%.$(LOGOEXT): shiva-rot-%.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'
shiva-rot-%.$(LOGOEXT): shiva-small.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -rotate $(patsubst shiva-rot-%.$(LOGOEXT),%,$@) $^ $@
shiva-small.$(LOGOEXT): shiva-2.$(LOGOEXT) kali-small.dim
	$(RESIZE) $(TRANSPARENT) -resize `cat kali-small.dim`\< -extent `cat kali-small.dim` $< $@

kali-small.dim: kali-d.dim
	D=`cat $<` \
	$(SHELL) -c 'echo $${D}x$${D}' > $@
kali-d.dim: kali.dim
	W=`awk 'BEGIN{FS="x"}{print $$1}' $<` \
	H=`awk 'BEGIN{FS="x"}{print $$2}' $<` \
	D=$$((W < H ? W : H))                 \
	$(SHELL) -c 'echo "scale=0; sqrt($$D * $$D / 2)" | bc' > $@

#shiva-resize.$(LOGOEXT): shiva-transparent.$(LOGOEXT) kali.dim
shiva-resize.$(LOGOEXT): shiva-2.$(LOGOEXT) kali.dim
	$(RESIZE) $(TRANSPARENT) -resize `cat kali.dim`\< -extent `cat kali.dim` $< $@
kali.dim: kali.$(LOGOEXT)
	$(IDENTIFY) '%wx%h' $< > $@

shiva-transparent.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $^ $(TRANSPARENT) $@
shiva-2.$(LOGOEXT): shiva.$(LOGOEXT)
	$(CONVERT) $< -colorspace gray -colors 2 -type bilevel $@

%.$(LOGOEXT): %.jpg
	$(CONVERT) $^ $@
kali.jpg: kali.url
	$(WGET)
shiva.jpg: shiva.url
	$(WGET)



distclean: cleaner
	$(RM) shiva.jpg kali.jpg
cleaner: clean
	$(RM) $(LOGO) $(LOGO_VISIBLE) $(LOGO_ANIM)   \
	      apple-touch-icon-*.png                 \
	      syslinux-splash.bmp grub-splash.xpm.gz \
	      favicon*.ico github.$(LOGOEXT)
clean:
	$(RM) *.dim kali.$(LOGOEXT) shiva*.$(LOGOEXT)          \
	      logo-rot-*.$(LOGOEXT) logo-animated-*.$(LOGOEXT) \
	      favicon-*.ico grub-splash.xpm

