.PHONY: all distclean cleaner clean \
        logos apple-touch-icons boot-splashes favicons profiles wallpapers
.PRECIOUS:  shiva-rot-*.png
.SECONDARY: shiva-rot-*.png

#VISIBLE=0.9
#INVISIBLE=0.6
VISIBLE=40
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

all: logos apple-touch-icons boot-splashes favicons profiles wallpapers



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
grub-splash.xpm: boot.$(LOGOEXT)
	$(CONVERT) -colors 14 $^ $@
	#$(CONVERT) -resize 640x480^ -gravity center -extent 640x480 -colors 14 $^ $@

syslinux-splash.bmp: boot.$(LOGOEXT)
	$(CONVERT) -colors 14 -depth 16 $^ $@
	#$(CONVERT) -resize 640x480^ -gravity center -extent 640x480 -colors 14 -depth 16 $^ $@

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
boot.$(LOGOEXT): shiva-boot.$(LOGOEXT) kali-boot.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
BOOTSZ=640x480
BOOTARGS=-gravity center -extent $(BOOTSZ)
shiva-boot.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(BOOTSZ)\< $(BOOTARGS) $^ $@
kali-boot.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(BOOTSZ)^ $(BOOTARGS) $^ $@



favicons: favicon.ico
favicon.ico: favicon-8x8.ico   \
             favicon-16x16.ico \
             favicon-32x32.ico \
             favicon-64x64.ico
	$(CONVERT) $^ $@
favicon-%.ico: $(LOGO_MIDVISIBLE)
	DIM=$(patsubst favicon-%.ico,%,$@) $(SHELL) -c \
	'$(CONVERT) -resize $$DIM -gravity center -crop $$DIM+0+0 -flatten -colors 256 $^ $@'



profiles: github.$(LOGOEXT) youtube-banner.$(LOGOEXT) twitter-banner.$(LOGOEXT) linkedin-banner.$(LOGOEXT) soundcloud-banner.$(LOGOEXT) avatar.$(LOGOEXT) avatar.$(LOGOEXT) small-thumbnail.$(LOGOEXT) large-thumbnail.$(LOGOEXT) stripe.jpg stripe-icon.$(LOGOEXT) patreon.$(LOGOEXT) patreon-banner.$(LOGOEXT)
github.$(LOGOEXT): $(LOGO_VISIBLE)
	$(CONVERT) -resize 500x500^ -gravity center -extent 500x500 $^ $@
avatar.$(LOGOEXT): $(LOGO_VISIBLE)
	$(CONVERT) -resize 80x80^ -gravity center -extent 80x80 $^ $@
patreon.$(LOGOEXT): $(LOGO_VISIBLE)
	$(CONVERT) -resize 256x256^ -gravity center -extent 256x256 $^ $@

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
youtube-banner.$(LOGOEXT): shiva-youtube-banner.$(LOGOEXT) kali-youtube-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
shiva-youtube-banner.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize 1546x423\< -gravity center -extent 1546x423 $^ $@
kali-youtube-banner.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize 2560x1440^ -gravity center -extent 2560x1440 $^ $@

patreon-banner.$(LOGOEXT): shiva-patreon-banner.$(LOGOEXT) kali-patreon-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
shiva-patreon-banner.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize 1600x400\< -gravity center -extent 1600x400 $^ $@
kali-patreon-banner.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize 1600x400^ -gravity center -extent 1600x400 $^ $@

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
twitter-banner.$(LOGOEXT): shiva-twitter-banner.$(LOGOEXT) kali-twitter-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
TWITTERSZ=1263x421
TWITTERARGS=-gravity center -extent $(TWITTERSZ)
shiva-twitter-banner.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(TWITTERSZ)\< $(TWITTERARGS) $^ $@
kali-twitter-banner.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(TWITTERSZ)^ $(TWITTERARGS) $^ $@

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
linkedin-banner.$(LOGOEXT): shiva-linkedin-banner.$(LOGOEXT) kali-linkedin-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
#LINKEDINSZ=1128x191
#LINKEDINSZ=1536x768
LINKEDINSZ=1584x396
LINKEDINARGS=-gravity center -extent $(LINKEDINSZ)
shiva-linkedin-banner.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(LINKEDINSZ)\< $(LINKEDINARGS) $^ $@
kali-linkedin-banner.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(LINKEDINSZ)^ $(LINKEDINARGS) $^ $@

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
soundcloud-banner.$(LOGOEXT): shiva-soundcloud-banner.$(LOGOEXT) kali-soundcloud-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
SOUNDCLOUDSZ=2480x520
SOUNDCLOUDARGS=-gravity center -extent $(SOUNDCLOUDSZ)
shiva-soundcloud-banner.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(SOUNDCLOUDSZ)\< $(SOUNDCLOUDARGS) $^ $@
kali-soundcloud-banner.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(SOUNDCLOUDSZ)^ $(SOUNDCLOUDARGS) $^ $@

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
doxygen-logo.$(LOGOEXT): shiva-doxygen-logo.$(LOGOEXT) kali-doxygen-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
DOXYGENSZ=55x200
DOXYGENARGS=-gravity center -extent $(DOXYGENSZ)
shiva-doxygen-logo.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(DOXYGENSZ)\< $(DOXYGENARGS) $^ $@
kali-doxygen-logo.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(DOXYGENSZ)^ $(DOXYGENARGS) $^ $@

small-thumbnail.$(LOGOEXT): shiva-small-thumbnail.$(LOGOEXT) kali-small-thumbnail.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
THUMBNAIL_SMALLSZ=150x112
THUMBNAIL_SMALLARGS=-gravity center -extent $(THUMBNAIL_SMALLSZ)
shiva-small-thumbnail.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(THUMBNAIL_SMALLSZ)\> $(THUMBNAIL_SMALLARGS) $^ $@
	#$(CONVERT) $(TRANSPARENT) -resize $(THUMBNAIL_SMALLSZ)\< $(THUMBNAIL_SMALLARGS) $^ $@
kali-small-thumbnail.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(THUMBNAIL_SMALLSZ)^ $(THUMBNAIL_SMALLARGS) $^ $@

large-thumbnail.$(LOGOEXT): shiva-large-thumbnail.$(LOGOEXT) kali-large-thumbnail.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
THUMBNAIL_LARGESZ=320x240
THUMBNAIL_LARGEARGS=-gravity center -extent $(THUMBNAIL_LARGESZ)
shiva-large-thumbnail.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(THUMBNAIL_LARGESZ)\> $(THUMBNAIL_LARGEARGS) $^ $@
	#$(CONVERT) $(TRANSPARENT) -resize $(THUMBNAIL_LARGESZ)\< $(THUMBNAIL_LARGEARGS) $^ $@
kali-large-thumbnail.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(THUMBNAIL_LARGESZ)^ $(THUMBNAIL_LARGEARGS) $^ $@

stripe.jpg: shiva-stripe.$(LOGOEXT) kali-stripe.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c 'composite $(GENLOGOARGS)' $(STRIPEQUALITY)
STRIPESZ=1000x2000
STRIPEARGS=-gravity center -extent $(STRIPESZ)
shiva-stripe.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(STRIPESZ)\< $(STRIPEARGS) $^ $@
kali-stripe.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(STRIPESZ)^ $(STRIPEARGS) $^ $@

stripe-icon.$(LOGOEXT): $(LOGO_VISIBLE)
	$(CONVERT) -resize 128x128^ -gravity center -extent 128x128 $^ $@



wallpapers: wallpaper1.$(LOGOEXT) wallpaper2.$(LOGOEXT) wallpaper3.$(LOGOEXT) wallpaper4.$(LOGOEXT)

wallpaper1.$(LOGOEXT): shiva-wallpaper1.$(LOGOEXT) kali-wallpaper1.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
WALLPAPER1SZ=800x600
WALLPAPER1ARGS=-gravity center -extent $(WALLPAPER1SZ)
shiva-wallpaper1.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(WALLPAPER1SZ)\< $(WALLPAPER1ARGS) $^ $@
kali-wallpaper1.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(WALLPAPER1SZ)^ $(WALLPAPER1ARGS) $^ $@

wallpaper2.$(LOGOEXT): shiva-wallpaper2.$(LOGOEXT) kali-wallpaper2.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
WALLPAPER2SZ=1024x768
WALLPAPER2ARGS=-gravity center -extent $(WALLPAPER2SZ)
shiva-wallpaper2.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(WALLPAPER2SZ)\< $(WALLPAPER2ARGS) $^ $@
kali-wallpaper2.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(WALLPAPER2SZ)^ $(WALLPAPER2ARGS) $^ $@

wallpaper3.$(LOGOEXT): shiva-wallpaper3.$(LOGOEXT) kali-wallpaper3.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
WALLPAPER3SZ=1280x1024
WALLPAPER3ARGS=-gravity center -extent $(WALLPAPER3SZ)
shiva-wallpaper3.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(WALLPAPER3SZ)\< $(WALLPAPER3ARGS) $^ $@
kali-wallpaper3.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(WALLPAPER3SZ)^ $(WALLPAPER3ARGS) $^ $@

wallpaper4.$(LOGOEXT): shiva-wallpaper4.$(LOGOEXT) kali-wallpaper4.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
WALLPAPER4SZ=1600x1200
WALLPAPER4ARGS=-gravity center -extent $(WALLPAPER4SZ)
shiva-wallpaper4.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(WALLPAPER4SZ)\< $(WALLPAPER4ARGS) $^ $@
kali-wallpaper4.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(WALLPAPER4SZ)^ $(WALLPAPER4ARGS) $^ $@



logos: $(LOGO) $(LOGO_VISIBLE) $(LOGO_MIDVISIBLE) $(LOGO_ANIM) $(LOGO_ANIM_SMALL) doxygen-logo.$(LOGOEXT) gpg-logo.jpg logo.txt sphinx-logo.$(LOGOEXT) stackoverflow-logo.$(LOGOEXT)

sphinx-logo.$(LOGOEXT): shiva-sphinx-logo.$(LOGOEXT) kali-sphinx-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
SPHINX_LOGOSZ=200x200
SPHINX_LOGOARGS=-gravity center -extent $(SPHINX_LOGOSZ)
shiva-sphinx-logo.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(SPHINX_LOGOSZ)\> $(SPHINX_LOGOARGS) $^ $@
	#$(CONVERT) $(TRANSPARENT) -resize $(SPHINX_LOGOSZ)\< $(SPHINX_LOGOARGS) $^ $@
kali-sphinx-logo.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(SPHINX_LOGOSZ)^ $(SPHINX_LOGOARGS) $^ $@

stackoverflow-logo.$(LOGOEXT): shiva-stackoverflow-logo.$(LOGOEXT) kali-stackoverflow-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
#STACKOVERFLOW_LOGOSZ=2560x2560
STACKOVERFLOW_LOGOSZ=2560x2560
STACKOVERFLOW_LOGOARGS=-gravity center -extent $(STACKOVERFLOW_LOGOSZ)
shiva-stackoverflow-logo.$(LOGOEXT): shiva-2.$(LOGOEXT)
	#$(CONVERT) $(TRANSPARENT) -resize $(STACKOVERFLOW_LOGOSZ)\> $(STACKOVERFLOW_LOGOARGS) $^ $@
	$(CONVERT) $(TRANSPARENT) -resize $(STACKOVERFLOW_LOGOSZ)\< $(STACKOVERFLOW_LOGOARGS) $^ $@
kali-stackoverflow-logo.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(STACKOVERFLOW_LOGOSZ)^ $(STACKOVERFLOW_LOGOARGS) $^ $@

gpg-logo.jpg: tmp-gpg-logo.$(LOGOEXT)
	$(LOWQUALITY) $^ $@
tmp-gpg-logo.$(LOGOEXT): shiva-gpg-logo.$(LOGOEXT) kali-gpg-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
GPGSZ=240x288
GPGARGS=-gravity center -extent $(GPGSZ)
shiva-gpg-logo.$(LOGOEXT): shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(GPGSZ)\> $(GPGARGS) $^ $@
	#$(CONVERT) $(TRANSPARENT) -resize $(GPGSZ)\< $(GPGARGS) $^ $@
kali-gpg-logo.$(LOGOEXT): kali.$(LOGOEXT)
	$(CONVERT) -resize $(GPGSZ)^ $(GPGARGS) $^ $@

#$(LOGO): kali.$(LOGOEXT) shiva-resize.$(LOGOEXT)
$(LOGO): shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
#$(LOGO_VISIBLE): kali.$(LOGOEXT) shiva-resize.$(LOGOEXT)
$(LOGO_VISIBLE): shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'
$(LOGO_MIDVISIBLE): shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'

$(LOGO_ANIM_SMALL): $(LOGO_ANIM)
	$(LOWQUALITY) -resize 256x256^ -gravity center -extent 256x256 -layers optimize $^ $@
$(LOGO_ANIM): logo-rot-0.$(LOGOEXT) $(foreach d,$(shell seq $(NROT)),logo-rot-$(shell echo 'scale=$(SCALE); $(d) * -$(DEG)' | bc).$(LOGOEXT))
	$(CONVERT) $^ -loop 0 -delay $(FPS) $@

#logo-rot-%.$(LOGOEXT): kali.$(LOGOEXT) shiva-rot-%.$(LOGOEXT)
logo-rot-%.$(LOGOEXT): shiva-rot-%.$(LOGOEXT) kali.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'
shiva-rot-%.$(LOGOEXT): shiva-small.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -rotate $(patsubst shiva-rot-%.$(LOGOEXT),%,$@) $^ $@
shiva-small.$(LOGOEXT): shiva-2.$(LOGOEXT) kali-small.dim
	$(RESIZE) -resize `cat kali-small.dim`\< -extent `cat kali-small.dim` $< $@

logo.txt: logo-visible.$(LOGOEXT)
	img2txt $^ > $@

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
	$(RESIZE) -resize `cat kali.dim`\< -extent `cat kali.dim` $< $@
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
	$(RM) $(LOGO) $(LOGO_VISIBLE) $(LOGO_MIDVISIBLE) \
	      $(LOGO_ANIM) $(LOGO_ANIM_SMALL)            \
	      apple-touch-icon-*.png                     \
	      syslinux-splash.bmp grub-splash.xpm.gz     \
	      favicon*.ico github.$(LOGOEXT)             \
	      youtube-banner.$(LOGOEXT)                  \
	      twitter-banner.$(LOGOEXT)                  \
	      linkedin-banner.$(LOGOEXT)                 \
	      soundcloud-banner.$(LOGOEXT)               \
	      doxygen-logo.$(LOGOEXT)                    \
              gpg-logo.jpg avatar.$(LOGOEXT)             \
	      sphinx-logo.$(LOGOEXT)                     \
	      stackoverflow-logo.$(LOGOEXT)              \
	      small-thumbnail.$(LOGOEXT)                 \
	      large-thumbnail.$(LOGOEXT)                 \
	      wallpaper*.$(LOGOEXT) stripe.jpg           \
	      stripe-icon.$(LOGOEXT) logo.txt
clean:
	$(RM) *.dim kali*.$(LOGOEXT) shiva*.$(LOGOEXT)         \
	      logo-rot-*.$(LOGOEXT) logo-animated-*.$(LOGOEXT) \
	      favicon-*.ico grub-splash.xpm *boot.$(LOGOEXT)   \
              tmp*.$(LOGOEXT)

