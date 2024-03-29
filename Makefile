.PHONY: all distclean cleaner clean parts release test stego logos   \
        apple-touch-icons boot-splashes favicons profiles wallpapers \
        aperture baphomet cthulhu e-corp fawkes hermes kabuto lucy   \
        maltese maltese-round sauron sith umbrella wolfram           \
	shellcheck dist stego-helper test-parts test-run             \
	icons android-chrome-icons mstile-icons anim stego-parts     \
	apple-touch-icons-precomposed
#.PRECIOUS: archive.tar archive.tar.lrz archive.tar.lrz.zpaq          \
#           archive.tlrzpq archive.tlrzpq.gpg                         \
#           shiva-small.png kali-small.png shiva-2.png shiva.png      \
#           kali.png shiva.jpg kali.jpg
#.SECONDARY: shiva-rot-*.png kali-*.png

# infinite recursion, optional
LOL ?= 0

# optional
ifdef RECP
RECP := --encrypt -r $(RECP)
endif

STEGEXT ?= ppm
#STEGEXT ?= bmp

#ifdef PW
#PW := -k$(PW)
PW ?= InnovAnon
#endif

SLOGAN  ?= Free Code for a Free World!
CAPTION ?= -caption "$(SLOGAN)"
COMMENT ?= -comment "$(SLOGAN)"

#VISIBLE=0.9
#INVISIBLE=0.6
#VISIBLE=60
##VISIBLE=40
#MIDVISIBLE=30
#INVISIBLE=10
VISIBLE=65
MIDVISIBLE=40
INVISIBLE=15
INVISIBLER=5

TRANCE=8
#TRANCE=4
SCALE=2
#ITER=$(TRANCE)
ITER=2
FPS=32
#FPS=31.32
#DEG=$(shell  echo 'scale=$(SCALE); 360 * $(TRANCE) / $(FPS)' | bc)
#NROT=$(shell echo 'scale=$(SCALE); 360 * $(TRANCE) / $(DEG)' | bc)
#NROT=$(shell echo 'scale=0; 360 * $(TRANCE) / $(DEG)' | bc)

# 360 degrees / 30 frames / 4 cycles = 7.5
DEG=$(shell  echo 'scale=$(SCALE); 360 / $(TRANCE) / $(FPS)' | bc)
NROT=$(shell echo 'scale=0; $(TRANCE) * $(FPS) * $(ITER)' | bc)

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
LOGO_ANIM_STEGO=logo-stego-animated.$(ANIMEXT)

# TODO
WGET=[ -f $@ ] || { sleep 31 ; curl --proxy "$(SOCKS_PROXY)" -o $@ "$$(cat $<)" || exit $$? ; }
#WGET=touch $@
#WGET=if [ ! -f $@ ] ; then sleep 31 && curl --proxy "$(SOCKS_PROXY)" -o $@ "$$(cat $<)" || echo $@ 1>&2 ; fi && touch $@
#WGET=[ -f $@ ] || pcurl `cat $^` $@
RM=rm -fv
IDENTIFY=identify -ping -format

CONVERT=convert $(QUAL) +compress
#TRANSPARENT=-fuzz 90% -transparent white -background 'rgba(0,0,0,0)'
TRANSPARENT=-fuzz 0% -transparent white -background 'rgba(0,0,0,0)'
RESIZE=$(CONVERT) -gravity center
GENLOGOARGS=$(COMMENT) -blend $$BLEND -gravity center $^ $@
GENLOGO=composite $(QUAL) $(GENLOGOARGS)
#GENLOGO=$(CONVERT) $^ -gravity center             \
#        \( -clone 0 -alpha extract \)             \
#        \( -clone 1 -clone 2 -alpha off           \
#           -compose copy_opacity -composite       \
#           -alpha on -channel a                   \
#           -evaluate multiply $$BLEND +channel \) \
#        -delete 1,2 -compose overlay -composite $@

BLD ?= bld
OUT ?= out
STG ?= stg
TST ?= tst
DLD ?= dld

#all: extra_logos logos apple-touch-icons boot-splashes favicons profiles wallpapers stego
all: extra_logos logos icons boot-splashes profiles wallpapers $(OUT)/archive.tar anim
#all: sign
#sign: extra_logos logos apple-touch-icons boot-splashes favicons profiles wallpapers $(OUT)/archive.tar
#$(OUT)/%.gpg: $(OUT)/%
#	gpg --local-user 53F31F9711F06089\! --sign $<
#extra_logos:       stego-helper
#logos:             stego-helper
#apple-touch-icons: stego-helper
#boot-splashes:     stego-helper
#favicons:          stego-helper
#profiles:          stego-helper
#wallpapers:        stego-helper
#stego-helper: distclean
#	$(MAKE) stego
#dist: distclean
#dist: cleaner
#	. /etc/profile
#	$(MAKE) all stego
dist: all # stego
	#[ ! -d .git ]
	#$(MAKE) stego
	#$(MAKE)
	#$(MAKE) clean
	#$(RM) Makefile .Makefile make support* nohup.out *.url *.jpg hermes.png *.mk archive.* .gitignore \
	#      aperture.png umbrella.png quine.sh dist.sh sauron.png maltese.png
	[ "$(LOL)" -eq 0 ] || $(MAKE) test
	#tar acvf /tmp/logo.txz $(OUT) $(STG)
#test: logo-stego-animated.$(LOGOEXT)
#test: stego
#stegosuite -x -f $(TST)/archive.tlrzpq.gpg.part$(D) $(TST)/logo-stego-rot-%02d.$(LOGOEXT) || exit 2 ;
test: cleaner
	$(MAKE) test-run
test-parts: $(OUT)/logo-stego-animated.$(ANIMEXT) $(TST)/.sentinel
	# extract frames
	convert -coalesce "$<" "$(TST)/logo-stego-rot-%03d.$(STEGEXT)"
$(TST)/archive.tlrzpq.gpg.part%: test-parts
	[ -f "$(patsubst $(TST)/archive.tlrzpq.gpg.part%,$(TST)/logo-stego-rot-%.$(STEGEXT),$@)" ]
	@case "$(STEGEXT)" in \
	  ppm)             \
	    outguess -k "$(PW)" -r "$(patsubst $(TST)/archive.tlrzpq.gpg.part%,$(TST)/logo-stego-rot-%.$(STEGEXT),$@)" "$@"             \
	    ;;             \
	  bmp)             \
	    steghide extract -p "$(PW)" -xf "$@" -sf "$(patsubst $(TST)/archive.tlrzpq.gpg.part%,$(TST)/logo-stego-rot-%.$(STEGEXT),$@)" \
	    ;;             \
	  *)               \
	    exit 1         \
	    stegosuite -k "$(PW)" -d -x -f "$@" "$(patsubst $(TST)/archive.tlrzpq.gpg.part%,$(TST)/logo-stego-rot-%.$(STEGEXT),$@)"      \
	    ;;             \
	esac
	[ -f "$@" ]
# unsplit
$(TST)/archive.tlrzpq.gpg: $(foreach d,$(shell seq -w 0 1 $$(($(NROT) - 1))),$(TST)/archive.tlrzpq.gpg.part$(d))
	cat $^ > "$@"
	#cat `ls -v $(TST)/archive.tlrzpq.gpg.part*` > $(TST)/archive.tlrzpq.gpg
# decrypt/verify
$(TST)/archive.tlrzpq: $(TST)/archive.tlrzpq.gpg
	gpg --decrypt -o "$(TST)/archive.tlrzpq" --yes "$(TST)/archive.tlrzpq.gpg"
# extract
$(TST)/archive.tar.lrz.zpaq: $(TST)/archive.tlrzpq
	mv -v            "$(TST)/archive.tlrzpq" "$(TST)/archive.tar.lrz.zpaq"
$(TST)/archive.tar.lrz: $(TST)/archive.tar.lrz.zpaq
	zpaq x                          "$(TST)/archive.tar.lrz.zpaq" -f
$(TST)/archive.tar: $(TST)/archive.tar.lrz
	lrunzip -f                      "$(TST)/archive.tar.lrz"
	chmod -v +x                     "$(TST)/archive.tar"
# run
test-run: $(TST)/archive.tar
	+"$<"
#release:
#	#LOL=$(LOL) ./quine.sh
#	#$(MAKE) stego
#	[ $(LOL) -eq 0 ] || $(MAKE) test
#logo-stego-animated.$(LOGOEXT): stego
#stego:
#	$(MAKE) -f stego.mk
#stego: cleaner
stego: stego-helper
	#$(RM) $(BLD)/archive.tar
	#$(MAKE) stego-helper
	#find $(OUT)
stego-helper: $(OUT)/logo-stego-animated.$(ANIMEXT)
#$(STG)/logo-stego-animated.$(ANIMEXT): $(OUT)/$(LOGO_ANIM_SMALL) $(STG)/.sentinel
#	cp -v $< $@








icons: apple-touch-icons-precomposed android-chrome-icons mstile-icons favicons $(OUT)/safari-pinned-tab.svg

# TODO $(OUT)/apple-touch-icon-precomposed.png
apple-touch-icons-precomposed: \
                               $(OUT)/precomposed-apple-touch-icon-114x114.png \
                               $(OUT)/precomposed-apple-touch-icon-120x120.png \
                               $(OUT)/precomposed-apple-touch-icon-144x144.png \
                               $(OUT)/precomposed-apple-touch-icon-152x152.png \
                               $(OUT)/precomposed-apple-touch-icon-180x180.png \
                               $(OUT)/precomposed-apple-touch-icon-57x57.png   \
                               $(OUT)/precomposed-apple-touch-icon-60x60.png   \
                               $(OUT)/precomposed-apple-touch-icon-72x72.png   \
                               $(OUT)/precomposed-apple-touch-icon-76x76.png

#$(OUT)/precomposed-apple-touch-icon-%.png: $(OUT)/apple-touch-icon-%.png $(BLD)/RoundFrame-%.png
#	set -e                                             ; \
#	K="$(patsubst $(OUT)/apple-touch-icon-%.png,%,$@)" ; \
#	$(CONVERT) -size "$$K" xc:white "$<" "$(BLD)/RoundFrame$$K.png" -composite -flatten "$@"
#$(BLD)/RoundFrame-%.png: $(BLD)/.sentinel
#	set -e                                                                   ; \
#	K="$(patsubst $(BLD)/rc-nw-%.png,%,$@)"                                  ; \
#	k="$$(echo $$K | sed 's/x.*//')"                                         ; \
#	k="$$(expr $$k - 1)"                                                     ; \
#	$(CONVERT) -size "$$K" xc:black -fill white -draw "roundRectangle 0,0 $${k}x$${k} 8,8" "$@"

$(OUT)/precomposed-apple-touch-icon-%.png: $(OUT)/tmp-precomposed-apple-touch-icon-%.png
	$(CONVERT) $(CAPTION) -transparent white -background 'rgba(0,0,0,0)' "$<" "$@"
$(OUT)/tmp-precomposed-apple-touch-icon-%.png: $(OUT)/apple-touch-icon-%.png \
	                                   $(BLD)/rc-nw-16x16.png        \
	                                   $(BLD)/rc-ne-16x16.png        \
					   $(BLD)/rc-sw-16x16.png        \
					   $(BLD)/rc-se-16x16.png
	set -e                                                         ; \
	K="$(patsubst $(OUT)/apple-touch-icon-%.png,%,$<)"             ; \
	[ -n "$$K" ]                                                   ; \
	$(CONVERT)                                                       \
	  "$<"                                                           \
	    -gravity center -resize "$$K"                                \
	  "$(BLD)/rc-nw-16x16.png"                                       \
	    -gravity northwest -composite                                \
	  "$(BLD)/rc-ne-16x16.png"                                       \
	    -gravity northeast -composite                                \
	  "$(BLD)/rc-sw-16x16.png"                                       \
	    -gravity southwest -composite                                \
	  "$(BLD)/rc-se-16x16.png"                                       \
	    -gravity southeast -composite                                \
	  -flatten -strip "$@"
#$(BLD)/rc-nw-%.png: $(BLD)/rc-nw-16x16.png $(BLD)/.sentinel
#	$(CONVERT) -resize "$(patsubst $(BLD)/rc-nw-%.png,%,$@)" "$<" "$@"
#	set -e                                                                   ; \
#	K="$(patsubst $(BLD)/rc-nw-%.png,%,$@)"                                  ; \
#	echo $$K                                                                 ; \
#	k="$$(echo $$K | sed 's/x.*//')"                                         ; \
#	k="$$(expr $$k - 1)"                                                            ; \
#	echo $$k                                                                 ; \
#	t="$$(echo $$K | sed 's/[^x]*x//')"                                      ; \
#	t="$$(expr $$t - 1)"                                                            ; \
#	echo $$t                                                                 ; \
#	[ "$$k" -eq "$$t" ]                                                      ; \
#	$(CONVERT) -size "$$Kx$$K" xc:none                       \
#	  -draw "fill white rectangle 0,0 $$k,$$k fill black circle $$k,$$k $$k,0" \
#	  -background white -alpha shape "$@"
$(BLD)/rc-ne-16x16.png: $(BLD)/rc-nw-16x16.png
	$(CONVERT) "$<" -flop -strip "$@"
$(BLD)/rc-sw-16x16.png: $(BLD)/rc-nw-16x16.png
	$(CONVERT) "$<" -flip -strip "$@"
$(BLD)/rc-se-16x16.png: $(BLD)/rc-ne-16x16.png
	$(CONVERT) "$<" -flip -strip "$@"
$(BLD)/rc-nw-16x16.png: $(BLD)/.sentinel
	$(CONVERT) -size 16x16 xc:none                       \
	  -draw "fill white rectangle 0,0 15,15 fill black circle 15,15 15,0" \
	  -background white -alpha shape -strip "$@"
#	$(CONVERT) $(TRANSPARENT) -size 16x16 xc:none                       \
#	  -draw "fill white rectangle 0,0 15,15 fill black circle 15,15 15,0" \
#	  -alpha shape -strip "$@"

# TODO apple-touch-icon.png
apple-touch-icons: $(OUT)/apple-touch-icon-180x180.png \
                   $(OUT)/apple-touch-icon-144x144.png \
                   $(OUT)/apple-touch-icon-120x120.png \
                   $(OUT)/apple-touch-icon-152x152.png \
                   $(OUT)/apple-touch-icon-114x114.png \
                   $(OUT)/apple-touch-icon-76x76.png   \
                   $(OUT)/apple-touch-icon-72x72.png   \
                   $(OUT)/apple-touch-icon-60x60.png   \
                   $(OUT)/apple-touch-icon-57x57.png
$(OUT)/apple-touch-icon-%.png: $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize "$(patsubst $(OUT)/apple-touch-icon-%.png,%,$@)" "$<" "$@"

# TODO
android-chrome-icons: $(OUT)/android-chrome-384x384.png \
                      $(OUT)/android-chrome-256x256.png \
                      $(OUT)/android-chrome-192x192.png \
                      $(OUT)/android-chrome-191x191.png \
                      $(OUT)/android-chrome-144x144.png \
                      $(OUT)/android-chrome-96x96.png   \
                      $(OUT)/android-chrome-72x72.png   \
                      $(OUT)/android-chrome-48x48.png   \
                      $(OUT)/android-chrome-36x36.png
$(OUT)/android-chrome-%.png: $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize "$(patsubst $(OUT)/android-chrome-%.png,%,$@)" "$<" "$@"

# TODO
mstile-icons: $(OUT)/mstile-310x310.png         \
              $(OUT)/mstile-310x150.png         \
              $(OUT)/mstile-150x150.png         \
              $(OUT)/mstile-144x144.png         \
              $(OUT)/mstile-70x70.png
$(OUT)/mstile-%.png: $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize "$(patsubst $(OUT)/mstile-%.png,%,$@)" "$<" "$@"

$(OUT)/safari-pinned-tab.svg: $(BLD)/shiva-transparent.$(LOGOEXT)
	$(CONVERT) $(CAPTION) $(TRANSPARENT) -resize 563x563 "$<" "$@"

favicons: $(OUT)/favicon.ico         \
	  $(OUT)/favicon-194x194.png \
          $(OUT)/favicon-64x64.png   \
          $(OUT)/favicon-32x32.png   \
          $(OUT)/favicon-16x16.png   \
          $(OUT)/favicon-8x8.png
$(OUT)/favicon.ico: $(OUT)/favicon-194x194.ico \
                    $(OUT)/favicon-64x64.ico   \
                    $(OUT)/favicon-32x32.ico   \
                    $(OUT)/favicon-16x16.ico   \
                    $(OUT)/favicon-8x8.ico
	$(CONVERT) $^ "$@"
$(OUT)/favicon-%.ico: $(OUT)/$(LOGO_VISIBLE)
	DIM="$(patsubst $(OUT)/favicon-%.ico,%,$@)" $(SHELL) -c \
	'$(CONVERT) $(CAPTION) -resize $$DIM -gravity center -crop $$DIM+0+0 -flatten -colors 256 $< $@'
#$(BLD)/$(LOGO_MIDVISIBLE): $(OUT)/$(LOGO_MIDVISIBLE)
#	cp -v $< $@
$(OUT)/favicon-%.png: $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize "$(patsubst $(OUT)/favicon-%.png,%,$@)" "$<" "$@"



boot-splashes: $(OUT)/grub-splash.xpm.gz \
               $(OUT)/syslinux-splash.bmp
$(OUT)/grub-splash.xpm.gz: $(OUT)/grub-splash.xpm
	pigz -c9 "$<" > "$@"
$(OUT)/grub-splash.xpm: $(BLD)/boot.$(LOGOEXT)
	$(CONVERT) $(CAPTION) -colors 14 "$<" "$@"
	#$(CONVERT) -resize 640x480^ -gravity center -extent 640x480 -colors 14 $^ $@

$(OUT)/syslinux-splash.bmp: $(BLD)/boot.$(LOGOEXT)
	$(CONVERT) $(CAPTION) -colors 14 -depth 16 "$<" "$@"
	#$(CONVERT) -resize 640x480^ -gravity center -extent 640x480 -colors 14 -depth 16 $^ $@

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
$(BLD)/boot.$(LOGOEXT): $(BLD)/shiva-boot.$(LOGOEXT) $(BLD)/kali-boot.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'
BOOTSZ=640x480
BOOTARGS=-gravity center -extent $(BOOTSZ)
$(BLD)/shiva-boot.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(BOOTSZ)\< $(BOOTARGS) "$<" "$@"
$(BLD)/kali-boot.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(BOOTSZ)^ $(BOOTARGS) "$<" "$@"






profiles: $(OUT)/github.$(LOGOEXT) $(OUT)/youtube-banner.$(LOGOEXT) $(OUT)/twitter-banner.$(LOGOEXT) $(OUT)/linkedin-banner.$(LOGOEXT) $(OUT)/soundcloud-banner.$(LOGOEXT) $(OUT)/avatar.$(LOGOEXT) $(OUT)/avatar.$(LOGOEXT) $(OUT)/small-thumbnail.$(LOGOEXT) $(OUT)/large-thumbnail.$(LOGOEXT) $(OUT)/stripe.jpg $(OUT)/stripe-icon.$(LOGOEXT) $(OUT)/patreon.$(LOGOEXT) $(OUT)/patreon-banner.$(LOGOEXT) $(OUT)/youtube-watermark-logo.$(LOGOEXT) $(OUT)/dtube-banner.$(LOGOEXT) $(OUT)/tumblr-banner.$(LOGOEXT) $(OUT)/gab-banner.$(LOGOEXT) $(OUT)/gab.$(LOGOEXT) $(OUT)/opencollective-banner.$(LOGOEXT) $(OUT)/bitbucket.$(LOGOEXT) $(OUT)/bitbucket-banner.$(LOGOEXT) $(OUT)/hashvault-banner.$(LOGOEXT) $(OUT)/facebook-banner.$(LOGOEXT) $(OUT)/htb-banner.$(LOGOEXT) $(OUT)/htb.$(LOGOEXT)

$(OUT)/github.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 500x500^ -gravity center -extent 500x500 "$<" "$@"
$(OUT)/stackoverflow.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 512x512^ -gravity center -extent 512x512 "$<" "$@"
$(OUT)/avatar.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 80x80^ -gravity center -extent 80x80 "$<" "$@"
$(OUT)/patreon.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 256x256^ -gravity center -extent 256x256 "$<" "$@"
$(OUT)/gab.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 400x400^ -gravity center -extent 400x400 "$<" "$@"
$(OUT)/htb.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 1000x1000^ -gravity center -extent 1000x1000 "$<" "$@"
$(OUT)/htb-2.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 900x900^ -gravity center -extent 900x900 "$<" "$@"
$(OUT)/bitbucket.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 2048x2048^ -gravity center -extent 2048x2048 "$<" "$@"

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
$(OUT)/youtube-banner.$(LOGOEXT): $(BLD)/shiva-youtube-banner.$(LOGOEXT) $(BLD)/kali-youtube-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
$(BLD)/shiva-youtube-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize 1546x423\< -gravity center -extent 1546x423 "$<" "$@"
$(BLD)/kali-youtube-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize 2560x1440^ -gravity center -extent 2560x1440 "$<" "$@"

$(OUT)/patreon-banner.$(LOGOEXT): $(BLD)/shiva-patreon-banner.$(LOGOEXT) $(BLD)/kali-patreon-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
$(BLD)/shiva-patreon-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize 1600x400\< -gravity center -extent 1600x400 "$<" "$@"
$(BLD)/kali-patreon-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize 1600x400^ -gravity center -extent 1600x400 "$<" "$@"

$(OUT)/htb-banner.$(LOGOEXT): $(BLD)/shiva-htb-banner.$(LOGOEXT) $(BLD)/kali-htb-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
$(BLD)/shiva-htb-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize 2880x225\< -gravity center -extent 2880x225 "$<" "$@"
$(BLD)/kali-htb-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize 2880x225^ -gravity center -extent 2880x225 "$<" "$@"

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
$(OUT)/twitter-banner.$(LOGOEXT): $(BLD)/shiva-twitter-banner.$(LOGOEXT) $(BLD)/kali-twitter-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
TWITTERSZ=1263x421
TWITTERARGS=-gravity center -extent $(TWITTERSZ)
$(BLD)/shiva-twitter-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(TWITTERSZ)\< $(TWITTERARGS) "$<" "$@"
$(BLD)/kali-twitter-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(TWITTERSZ)^ $(TWITTERARGS) "$<" "$@"

$(OUT)/facebook-banner.$(LOGOEXT): $(BLD)/shiva-facebook-banner.$(LOGOEXT) $(BLD)/kali-facebook-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
# TODO this is still cutting off parts of shiva
FACEBOOKSZ1=720x461.25
FACEBOOKARGS=-gravity center -extent $(FACEBOOKSZ1)
$(BLD)/shiva-facebook-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(FACEBOOKSZ1)\< $(FACEBOOKARGS1) "$<" "$@"
FACEBOOKSZ2=820x461.25
FACEBOOKARGS=-gravity center -extent $(FACEBOOKSZ2)
$(BLD)/kali-facebook-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(FACEBOOKSZ2)^ $(FACEBOOKARGS2) "$<" "$@"

$(OUT)/hashvault-banner.$(LOGOEXT): $(BLD)/shiva-hashvault-banner.$(LOGOEXT) $(BLD)/kali-hashvault-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
HASHVAULTSZ=1133x378
HASHVAULTARGS=-gravity center -extent $(HASHVAULTSZ)
$(BLD)/shiva-hashvault-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(HASHVAULTSZ)\< $(HASHVAULTARGS) "$<" "$@"
$(BLD)/kali-hashvault-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(HASHVAULTSZ)^ $(HASHVAULTARGS) "$<" "$@"

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
$(OUT)/linkedin-banner.$(LOGOEXT): $(BLD)/shiva-linkedin-banner.$(LOGOEXT) $(BLD)/kali-linkedin-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
#LINKEDINSZ=1128x191
#LINKEDINSZ=1536x768
LINKEDINSZ=1584x396
LINKEDINARGS=-gravity center -extent $(LINKEDINSZ)
$(BLD)/shiva-linkedin-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(LINKEDINSZ)\< $(LINKEDINARGS) "$<" "$@"
$(BLD)/kali-linkedin-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(LINKEDINSZ)^ $(LINKEDINARGS) "$<" "$@"

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
$(OUT)/soundcloud-banner.$(LOGOEXT): $(BLD)/shiva-soundcloud-banner.$(LOGOEXT) $(BLD)/kali-soundcloud-banner.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
SOUNDCLOUDSZ=2480x520
SOUNDCLOUDARGS=-gravity center -extent $(SOUNDCLOUDSZ)
$(BLD)/shiva-soundcloud-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(SOUNDCLOUDSZ)\< $(SOUNDCLOUDARGS) "$<" "$@"
$(BLD)/kali-soundcloud-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(SOUNDCLOUDSZ)^ $(SOUNDCLOUDARGS) "$<" "$@"

#$(LOGO_BOOT): kali-boot.$(LOGOEXT) shiva-boot.$(LOGOEXT)
$(OUT)/doxygen-logo.$(LOGOEXT): $(BLD)/shiva-doxygen-logo.$(LOGOEXT) $(BLD)/kali-doxygen-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
DOXYGENSZ=55x200
DOXYGENARGS=-gravity center -extent $(DOXYGENSZ)
$(BLD)/shiva-doxygen-logo.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(DOXYGENSZ)\< $(DOXYGENARGS) "$<" "$@"
$(BLD)/kali-doxygen-logo.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(DOXYGENSZ)^ $(DOXYGENARGS) "$<" "$@"

$(OUT)/small-thumbnail.$(LOGOEXT): $(BLD)/shiva-small-thumbnail.$(LOGOEXT) $(BLD)/kali-small-thumbnail.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
THUMBNAIL_SMALLSZ=150x112
THUMBNAIL_SMALLARGS=-gravity center -extent $(THUMBNAIL_SMALLSZ)
$(BLD)/shiva-small-thumbnail.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(THUMBNAIL_SMALLSZ)\> $(THUMBNAIL_SMALLARGS) "$<" "$@"
	#$(CONVERT) $(TRANSPARENT) -resize $(THUMBNAIL_SMALLSZ)\< $(THUMBNAIL_SMALLARGS) $^ $@
$(BLD)/kali-small-thumbnail.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(THUMBNAIL_SMALLSZ)^ $(THUMBNAIL_SMALLARGS) "$<" "$@"

$(OUT)/large-thumbnail.$(LOGOEXT): $(BLD)/shiva-large-thumbnail.$(LOGOEXT) $(BLD)/kali-large-thumbnail.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
THUMBNAIL_LARGESZ=320x240
THUMBNAIL_LARGEARGS=-gravity center -extent $(THUMBNAIL_LARGESZ)
$(BLD)/shiva-large-thumbnail.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(THUMBNAIL_LARGESZ)\> $(THUMBNAIL_LARGEARGS) "$<" "$@"
	#$(CONVERT) $(TRANSPARENT) -resize $(THUMBNAIL_LARGESZ)\< $(THUMBNAIL_LARGEARGS) $^ $@
$(BLD)/kali-large-thumbnail.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(THUMBNAIL_LARGESZ)^ $(THUMBNAIL_LARGEARGS) "$<" "$@"

$(OUT)/stripe.jpg: $(BLD)/shiva-stripe.$(LOGOEXT) $(BLD)/kali-stripe.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c 'composite $(GENLOGOARGS)' $(STRIPEQUALITY)
STRIPESZ=1000x2000
STRIPEARGS=-gravity center -extent $(STRIPESZ)
$(BLD)/shiva-stripe.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(STRIPESZ)\< $(STRIPEARGS) "$<" "$@"
$(BLD)/kali-stripe.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(STRIPESZ)^ $(STRIPEARGS) "$<" "$@"

$(OUT)/stripe-icon.$(LOGOEXT): $(OUT)/$(LOGO_VISIBLE)
	$(CONVERT) $(CAPTION) -resize 128x128^ -gravity center -extent 128x128 "$<" "$@"



wallpapers: $(OUT)/wallpaper1.$(LOGOEXT) $(OUT)/wallpaper2.$(LOGOEXT) $(OUT)/wallpaper3.$(LOGOEXT) $(OUT)/wallpaper4.$(LOGOEXT)

$(OUT)/wallpaper1.$(LOGOEXT): $(BLD)/shiva-wallpaper1.$(LOGOEXT) $(BLD)/kali-wallpaper1.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
WALLPAPER1SZ=800x600
WALLPAPER1ARGS=-gravity center -extent $(WALLPAPER1SZ)
$(BLD)/shiva-wallpaper1.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(WALLPAPER1SZ)\< $(WALLPAPER1ARGS) "$<" "$@"
$(BLD)/kali-wallpaper1.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(WALLPAPER1SZ)^ $(WALLPAPER1ARGS) "$<" "$@"

$(OUT)/dtube-banner.$(LOGOEXT): $(BLD)/shiva-dtube-banner.$(LOGOEXT) $(BLD)/kali-dtube-banner.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
DTUBE_BANNERSZ=1900x265
DTUBE_BANNERARGS=-gravity center -extent $(DTUBE_BANNERSZ)
$(BLD)/shiva-dtube-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(DTUBE_BANNERSZ)\< $(DTUBE_BANNERARGS) "$<" "$@"
$(BLD)/kali-dtube-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(DTUBE_BANNERSZ)^ $(DTUBE_BANNERARGS) "$<" "$@"

$(OUT)/tumblr-banner.$(LOGOEXT): $(BLD)/shiva-tumblr-banner.$(LOGOEXT) $(BLD)/kali-tumblr-banner.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
TUMBLR_BANNERSZ=3000x1055
TUMBLR_BANNERARGS=-gravity center -extent $(TUMBLR_BANNERSZ)
$(BLD)/shiva-tumblr-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(TUMBLR_BANNERSZ)\< $(TUMBLR_BANNERARGS) "$<" "$@"
$(BLD)/kali-tumblr-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(TUMBLR_BANNERSZ)^ $(TUMBLR_BANNERARGS) "$<" "$@"

$(OUT)/gab-banner.$(LOGOEXT): $(BLD)/shiva-gab-banner.$(LOGOEXT) $(BLD)/kali-gab-banner.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
GAB_BANNERSZ=1500x500
GAB_BANNERARGS=-gravity center -extent $(GAB_BANNERSZ)
$(BLD)/shiva-gab-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(GAB_BANNERSZ)\< $(GAB_BANNERARGS) "$<" "$@"
$(BLD)/kali-gab-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(GAB_BANNERSZ)^ $(GAB_BANNERARGS) "$<" "$@"

$(OUT)/opencollective-banner.$(LOGOEXT): $(BLD)/shiva-opencollective-banner.$(LOGOEXT) $(BLD)/kali-opencollective-banner.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
OPENCOLLECTIVE_BANNERSZ=1268x360
OPENCOLLECTIVE_BANNERARGS=-gravity center -extent $(OPENCOLLECTIVE_BANNERSZ)
$(BLD)/shiva-opencollective-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(OPENCOLLECTIVE_BANNERSZ)\< $(OPENCOLLECTIVE_BANNERARGS) "$<" "$@"
$(BLD)/kali-opencollective-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(OPENCOLLECTIVE_BANNERSZ)^ $(OPENCOLLECTIVE_BANNERARGS) "$<" "$@"

$(OUT)/bitbucket-banner.$(LOGOEXT): $(BLD)/shiva-bitbucket-banner.$(LOGOEXT) $(BLD)/kali-bitbucket-banner.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
BITBUCKET_BANNERSZ=1600x200
#BITBUCKET_BANNERSZ=720x480
BITBUCKET_BANNERARGS=-gravity center -extent $(BITBUCKET_BANNERSZ)
$(BLD)/shiva-bitbucket-banner.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(BITBUCKET_BANNERSZ)\< $(BITBUCKET_BANNERARGS) "$<" "$@"
$(BLD)/kali-bitbucket-banner.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(BITBUCKET_BANNERSZ)^ $(BITBUCKET_BANNERARGS) "$<" "$@"

$(OUT)/wallpaper2.$(LOGOEXT): $(BLD)/shiva-wallpaper2.$(LOGOEXT) $(BLD)/kali-wallpaper2.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
WALLPAPER2SZ=1024x768
WALLPAPER2ARGS=-gravity center -extent $(WALLPAPER2SZ)
$(BLD)/shiva-wallpaper2.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(WALLPAPER2SZ)\< $(WALLPAPER2ARGS) "$<" "$@"
$(BLD)/kali-wallpaper2.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(WALLPAPER2SZ)^ $(WALLPAPER2ARGS) "$<" "$@"

$(OUT)/wallpaper3.$(LOGOEXT): $(BLD)/shiva-wallpaper3.$(LOGOEXT) $(BLD)/kali-wallpaper3.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
WALLPAPER3SZ=1280x1024
WALLPAPER3ARGS=-gravity center -extent $(WALLPAPER3SZ)
$(BLD)/shiva-wallpaper3.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(WALLPAPER3SZ)\< $(WALLPAPER3ARGS) "$<" "$@"
$(BLD)/kali-wallpaper3.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(WALLPAPER3SZ)^ $(WALLPAPER3ARGS) "$<" "$@"

$(OUT)/wallpaper4.$(LOGOEXT): $(BLD)/shiva-wallpaper4.$(LOGOEXT) $(BLD)/kali-wallpaper4.$(LOGOEXT)
	BLEND=$(INVISIBLE) $(SHELL) -c '$(GENLOGO)'
WALLPAPER4SZ=1600x1200
WALLPAPER4ARGS=-gravity center -extent $(WALLPAPER4SZ)
$(BLD)/shiva-wallpaper4.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(WALLPAPER4SZ)\< $(WALLPAPER4ARGS) "$<" "$@"
$(BLD)/kali-wallpaper4.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(WALLPAPER4SZ)^ $(WALLPAPER4ARGS) "$<" "$@"


anim: $(OUT)/$(LOGO_ANIM_SMALL) $(OUT)/$(LOGO_ANIM_STEGO) # $(OUT)/$(LOGO_ANIM)

logos: shiva $(OUT)/doxygen-logo.$(LOGOEXT) $(OUT)/gpg-logo.jpg $(OUT)/logo.txt $(OUT)/sphinx-logo.$(LOGOEXT) $(OUT)/stackoverflow-logo.$(LOGOEXT) $(OUT)/google-cover-logo.$(LOGOEXT) slack
# $(LOGO_ANIM) $(LOGO_ANIM_SMALL)

$(OUT)/sphinx-logo.$(LOGOEXT): $(BLD)/shiva-sphinx-logo.$(LOGOEXT) $(BLD)/kali-sphinx-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
SPHINX_LOGOSZ=200x200
SPHINX_LOGOARGS=-gravity center -extent $(SPHINX_LOGOSZ)
$(BLD)/shiva-sphinx-logo.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(SPHINX_LOGOSZ)\> $(SPHINX_LOGOARGS) "$<" "$@"
	#$(CONVERT) $(TRANSPARENT) -resize $(SPHINX_LOGOSZ)\< $(SPHINX_LOGOARGS) $^ $@
$(BLD)/kali-sphinx-logo.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(SPHINX_LOGOSZ)^ $(SPHINX_LOGOARGS) "$<" "$@"

$(OUT)/stackoverflow-logo.$(LOGOEXT): $(BLD)/shiva-stackoverflow-logo.$(LOGOEXT) $(BLD)/kali-stackoverflow-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
#STACKOVERFLOW_LOGOSZ=2560x2560
STACKOVERFLOW_LOGOSZ=2560x2560
STACKOVERFLOW_LOGOARGS=-gravity center -extent $(STACKOVERFLOW_LOGOSZ)
$(BLD)/shiva-stackoverflow-logo.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(STACKOVERFLOW_LOGOSZ)\< $(STACKOVERFLOW_LOGOARGS) "$<" "$@"
	#$(CONVERT) $(TRANSPARENT) -resize $(STACKOVERFLOW_LOGOSZ)\> $(STACKOVERFLOW_LOGOARGS) $^ $@
$(BLD)/kali-stackoverflow-logo.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(STACKOVERFLOW_LOGOSZ)^ $(STACKOVERFLOW_LOGOARGS) "$<" "$@"

$(OUT)/google-cover-logo.$(LOGOEXT): $(BLD)/shiva-google-cover-logo.$(LOGOEXT) $(BLD)/kali-google-cover-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
#GOOGLE_COVER_LOGOSZ=2560x2560
GOOGLE_COVER_LOGOSZ=2120x1192
GOOGLE_COVER_LOGOARGS=-gravity center -extent $(GOOGLE_COVER_LOGOSZ)
$(BLD)/shiva-google-cover-logo.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(GOOGLE_COVER_LOGOSZ)\< $(GOOGLE_COVER_LOGOARGS) "$<" "$@"
	#$(CONVERT) $(TRANSPARENT) -resize $(GOOGLE_COVER_LOGOSZ)\> $(GOOGLE_COVER_LOGOARGS) $^ $@
$(BLD)/kali-google-cover-logo.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(GOOGLE_COVER_LOGOSZ)^ $(GOOGLE_COVER_LOGOARGS) "$<" "$@"

$(OUT)/youtube-watermark-logo.$(LOGOEXT): $(BLD)/shiva-youtube-watermark-logo.$(LOGOEXT) $(BLD)/kali-youtube-watermark-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
#YOUTUBE_WATERMARK_LOGOSZ=2560x2560
YOUTUBE_WATERMARK_LOGOSZ=150x150
YOUTUBE_WATERMARK_LOGOARGS=-gravity center -extent $(YOUTUBE_WATERMARK_LOGOSZ)
$(BLD)/shiva-youtube-watermark-logo.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(YOUTUBE_WATERMARK_LOGOSZ)\> $(YOUTUBE_WATERMARK_LOGOARGS) "$<" "$@"
	#$(CONVERT) $(TRANSPARENT) -resize $(YOUTUBE_WATERMARK_LOGOSZ)\> $(YOUTUBE_WATERMARK_LOGOARGS) $^ $@
$(BLD)/kali-youtube-watermark-logo.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(YOUTUBE_WATERMARK_LOGOSZ)^ $(YOUTUBE_WATERMARK_LOGOARGS) "$<" "$@"

$(OUT)/gpg-logo.jpg: $(BLD)/tmp-gpg-logo.$(LOGOEXT)
	$(LOWQUALITY) $(CAPTION) "$<" "$@"
$(BLD)/tmp-gpg-logo.$(LOGOEXT): $(BLD)/shiva-gpg-logo.$(LOGOEXT) $(BLD)/kali-gpg-logo.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
GPGSZ=240x288
GPGARGS=-gravity center -extent $(GPGSZ)
$(BLD)/shiva-gpg-logo.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -resize $(GPGSZ)\> $(GPGARGS) "$<" "$@"
	#$(CONVERT) $(TRANSPARENT) -resize $(GPGSZ)\< $(GPGARGS) $^ $@
$(BLD)/kali-gpg-logo.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT)
	$(CONVERT) -resize $(GPGSZ)^ $(GPGARGS) "$<" "$@"

##$(LOGO): kali.$(LOGOEXT) shiva-resize.$(LOGOEXT)
#$(LOGO):            shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
#	BLEND=$(INVISIBLE)  $(SHELL) -c '$(GENLOGO)'
##$(LOGO_VISIBLE): kali.$(LOGOEXT) shiva-resize.$(LOGOEXT)
#$(LOGO_VISIBLE):    shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
#	BLEND=$(VISIBLE)    $(SHELL) -c '$(GENLOGO)'
#$(LOGO_MIDVISIBLE): shiva-resize.$(LOGOEXT) kali.$(LOGOEXT)
#	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'

#$(LOGO_ANIM_SMALL): $(LOGO_ANIM)
#	$(LOWQUALITY) -resize 256x256^ -gravity center -extent 256x256 -layers optimize $^ $@
#$(OUT)/$(LOGO_ANIM): $(BLD)/logo-rot-0.$(LOGOEXT) $(foreach d,$(shell seq $(NROT)),$(BLD)/logo-rot-$(shell echo 'scale=$(SCALE); $(d) * -$(DEG)' | bc).$(LOGOEXT))
#	$(CONVERT) $^ -loop 0 -delay $(FPS) $@
	
	
	
$(OUT)/$(LOGO_ANIM_SMALL): $(foreach d,$(shell seq -w 0 1 $$(($(NROT) - 1))),$(BLD)/logo-rot-$(d).$(STEGEXT))
	$(CONVERT) $(CAPTION) -dispose Background -layers OptimizePlus $$(printf -- '-delay $(FPS) %s ' $^) -loop 0 "$@"
# TODO 00000000000000000000000000
$(OUT)/$(LOGO_ANIM_STEGO): $(foreach d,$(shell seq -w 0 1 $$(($(NROT) - 1))),$(BLD)/logo-stego-rot-$(d).$(STEGEXT))
	$(CONVERT) $(CAPTION) -dispose Background -layers RemoveZero   $$(printf -- '-delay $(FPS) %s ' $^) -loop 0 "$@"

#$(BLD)/logo-small-rot-%.$(LOGOEXT): $(BLD)/logo-rot-%.$(LOGOEXT)
# embed data in logo frames
$(BLD)/logo-stego-rot-%.$(STEGEXT): $(BLD)/logo-rot-%.$(STEGEXT) stego-parts
	[ -f "$(patsubst $(BLD)/logo-stego-rot-%.$(STEGEXT),$(BLD)/stego.tlrzpq.gpg.part%,$@)" ]
	[ "$(STEGEXT)" != ppm ] ||    \
	    outguess                  \
	      -k "$(PW)"              \
	      -d "$(patsubst $(BLD)/logo-stego-rot-%.$(STEGEXT),$(BLD)/stego.tlrzpq.gpg.part%,$@)" \
	      "$<" "$@"
	[ "$(STEGEXT)" != bmp ] ||    \
	    steghide embed          \
	      -p "$(PW)"              \
	      -ef "$(patsubst $(BLD)/logo-stego-rot-%.$(STEGEXT),$(BLD)/stego.tlrzpq.gpg.part%,$@)" \
	      -cf "$<" -sf "$@"        \
	      -e none -Z -N
	[ "$(STEGEXT)" = ppm ] || \
	[ "$(STEGEXT)" = bmp ] ||  \
	    stegosuite              \
	      -k "$(PW)"             \
	      -d -e                 \
	      -f "$(patsubst $(BLD)/logo-stego-rot-%.$(LOGOEXT),$(BLD)/stego.tlrzpq.gpg.part%,$@)" \
	      "$@"
	[ -f "$@" ]

#$(BLD)/logo-rot-%.$(STEGEXT): $(BLD)/logo-rot-%.$(LOGOEXT)
$(BLD)/%.$(STEGEXT): $(BLD)/%.$(LOGOEXT)
	$(CONVERT) "$<" "$@"
	



# generate logo frames
$(BLD)/logo-rot-%.$(LOGOEXT): $(BLD)/shiva-rot-%.$(LOGOEXT) $(BLD)/kali-%.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'
# dancing shiva
$(BLD)/shiva-rot-%.$(LOGOEXT): $(BLD)/shiva-small-2.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -rotate "$(shell echo 'scale=$(SCALE); $(patsubst $(BLD)/shiva-rot-%.$(LOGOEXT),%,$@) * -$(DEG)' | bc)" "$<" "$@"

# kali yantra background with randomized fingerprint
$(BLD)/kali-%.$(LOGOEXT): $(BLD)/random-%.$(LOGOEXT) $(BLD)/kali-small.$(LOGOEXT)
	BLEND=$(INVISIBLER) $(SHELL) -c '$(GENLOGO)'
$(BLD)/random-%.$(LOGOEXT): $(BLD)/random-%.out $(BLD)/small.dim
	convert -depth 8 -size "$$(cat "$(BLD)/small.dim")" RGB:- "$@" < "$<"
$(BLD)/random-%.out: $(BLD)/random-2.sz fingerprint
	head -c "$$(cat "$<")" /dev/urandom > "$@"
	#head -c "$$((3*$$(sed 's/x/*/' $<)))" /dev/urandom > $@
$(BLD)/random-2.sz: $(BLD)/small.dim
	echo $$((3*$$(sed 's/x/*/' "$<"))) | tee "$@"

# animated logo is 256x256
$(BLD)/shiva-small-2.$(LOGOEXT): $(BLD)/shiva-transparent.$(LOGOEXT) $(BLD)/small.dim
	$(RESIZE) $(TRANSPARENT) -resize "$$(cat $(BLD)/small.dim)"\> -extent "$$(cat $(BLD)/small.dim)" "$<" "$@"
$(BLD)/kali-small.$(LOGOEXT): $(BLD)/kali.$(LOGOEXT) $(BLD)/small.dim
	$(RESIZE) -resize "$$(cat $(BLD)/small.dim)"^ -extent "$$(cat $(BLD)/small.dim)" "$<" "$@"	
$(BLD)/small.dim: $(BLD)/.sentinel
	echo 256x256 > "$@"
	
# data to hide
$(BLD)/archive.tlrzpq.gpg.part%: parts
$(BLD)/stego.tlrzpq.gpg.part%: stego-parts
parts: $(BLD)/archive.tlrzpq.gpg
	split -d -n $(NROT) "$<" "$<.part"
stego-parts: $(BLD)/stego.tlrzpq.gpg
	split -d -n $(NROT) "$<" "$<.part"
$(BLD)/%.gpg: $(BLD)/%
	rm -vf "$@"
	gpg --sign $(RECP) -o "$@" "$<"
#gpg --encrypt --sign -r $(RECP) -o $@ $<
$(BLD)/%.tlrzpq: $(BLD)/%.tar.lrz.zpaq
	cp -v "$<" "$@"
$(BLD)/%.zpaq: $(BLD)/%
	zpaq a "$@" "$<" -m511.7
$(BLD)/%.lrz: $(BLD)/%
	lrzip -fUno "$@" "$<"
$(BLD)/stego.tar: quine.sh Makefile *.url $(shell find "$(DLD)" -maxdepth 1)
	TARCHIVE="$@" LOL="$(LOL)" OUT="$(OUT)" DLD="$(DLD)" BLD="$(BLD)" STG="$(STG)" TST="$(TST)" PW="$(PW)" RECP="$(RECP)" "./$<"
#$(BLD)/%.tar: $(BLD)/%
#	tar vcf $@              \
#	  --absolute-names      \
#	  --group=nogroup       \
#	  --mtime=0             \
#	  --no-acls             \
#	  --numeric-owner       \
#	  --owner=nobody        \
#	  --group=nobody        \
#	  --sort=name           \
#	  --sparse              \
#	  --exclude-vcs         \
#	  --exclude=LICENSE     \
#	  --exclude=README.md   \
#	  $^	
#archive.tar: quine.sh make Makefile .Makefile support support-wrapper support.sh *.url $(BLD)/small.dim $(BLD)/slack.dim
#$(OUT)/archive.tar: quine.sh make Makefile .Makefile support support-wrapper support.sh *.url $(shell find "$(DLD)" -maxdepth 1)
$(OUT)/archive.tar: quine.sh Makefile *.url $(shell find "$(DLD)" -maxdepth 1)
	TARCHIVE="$@" LOL="$(LOL)" OUT="$(OUT)" DLD="$(DLD)" BLD="$(BLD)" STG="$(STG)" TST="$(TST)" PW="$(PW)" RECP="$(RECP)" "./$<"
#quine.sh:        shellcheck
#	$< -ax     $@
#make:            shellcheck
#	$< -ax     $@
#support-wrapper: shellcheck
#	$< -ax     $@
#support.sh:      shellcheck
#	$< -axs sh $@
#support:
#	file $@ | \
#	grep 'support: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, no section header'
#shellcheck:
	
	
	
	
	
	

#logo-rot-%.$(LOGOEXT): kali.$(LOGOEXT) shiva-rot-%.$(LOGOEXT)
$(BLD)/logo-rot-%.$(LOGOEXT): $(BLD)/shiva-rot-%.$(LOGOEXT) $(BLD)/kali.$(LOGOEXT)
	BLEND=$(VISIBLE) $(SHELL) -c '$(GENLOGO)'
$(BLD)/shiva-rot-%.$(LOGOEXT): $(BLD)/shiva-small.$(LOGOEXT)
	$(CONVERT) $(TRANSPARENT) -rotate "$(patsubst $(BLD)/shiva-rot-%.$(LOGOEXT),%,$@)" "$<" "$@"
$(BLD)/shiva-small.$(LOGOEXT): $(BLD)/shiva-2.$(LOGOEXT) $(BLD)/kali-small.dim
	$(RESIZE) $(TRANSPARENT) -resize "$$(cat $(BLD)/kali-small.dim)"\< -extent "$$(cat $(BLD)/kali-small.dim)" "$<" "$@"

#logo.txt: logo-visible.$(LOGOEXT)
#	img2txt $^ > $@

$(BLD)/kali-small.dim: $(BLD)/kali-d.dim
	D="$$(cat $<)" \
	$(SHELL) -c 'echo $${D}x$${D}' > "$@"
$(BLD)/kali-d.dim: $(BLD)/kali.dim
	W="$$(awk 'BEGIN{FS="x"}{print $$1}' $<)" \
	H="$$(awk 'BEGIN{FS="x"}{print $$2}' $<)" \
	D=$$((W < H ? W : H))                 \
	$(SHELL) -c 'echo "scale=0; sqrt($$D * $$D / 2)" | bc' | tee "$@"
#
##shiva-resize.$(LOGOEXT): shiva-2.$(LOGOEXT) $(BLD)/kali.dim
#shiva-resize.$(LOGOEXT): shiva-transparent.$(LOGOEXT) $(BLD)/kali.dim
#	$(RESIZE) $(TRANSPARENT) -resize `cat $(BLD)/kali.dim`\< -extent `cat $(BLD)/kali.dim` $< $@



#kali.dim: kali.$(LOGOEXT)
#	$(IDENTIFY) '%wx%h' $< > $@
$(BLD)/%.dim: $(BLD)/%.$(LOGOEXT)
	$(IDENTIFY) '%wx%h' "$<" | tee "$@"

#shiva-transparent.$(LOGOEXT): shiva-2.$(LOGOEXT)
#	$(CONVERT) $^ $(TRANSPARENT) $@
#shiva-2.$(LOGOEXT): shiva.$(LOGOEXT)
#	$(CONVERT) $< -colorspace gray -colors 2 -type bilevel $@
#
#%.$(LOGOEXT): %.jpg
#	$(CONVERT) $^ $@
#kali.jpg: kali.url
#	$(WGET)
#shiva.jpg: shiva.url
#	$(WGET)



extra_logos: aperture baphomet cthulhu e-corp fawkes hermes kabuto lucy maltese maltese-round sauron sith umbrella wolfram

#%:                        $(OUT)/%-$(LOGO)             $(OUT)/%-$(LOGO_VISIBLE)             $(OUT)/%-$(LOGO_MIDVISIBLE)
aperture:           $(OUT)/aperture-$(LOGO)      $(OUT)/aperture-$(LOGO_VISIBLE)      $(OUT)/aperture-$(LOGO_MIDVISIBLE)
baphomet:           $(OUT)/baphomet-$(LOGO)      $(OUT)/baphomet-$(LOGO_VISIBLE)      $(OUT)/baphomet-$(LOGO_MIDVISIBLE)
cthulhu:             $(OUT)/cthulhu-$(LOGO)       $(OUT)/cthulhu-$(LOGO_VISIBLE)       $(OUT)/cthulhu-$(LOGO_MIDVISIBLE)
e-corp:               $(OUT)/e-corp-$(LOGO)        $(OUT)/e-corp-$(LOGO_VISIBLE)        $(OUT)/e-corp-$(LOGO_MIDVISIBLE)
fawkes:               $(OUT)/fawkes-$(LOGO)        $(OUT)/fawkes-$(LOGO_VISIBLE)        $(OUT)/fawkes-$(LOGO_MIDVISIBLE)
hermes:               $(OUT)/hermes-$(LOGO)        $(OUT)/hermes-$(LOGO_VISIBLE)        $(OUT)/hermes-$(LOGO_MIDVISIBLE)
kabuto:               $(OUT)/kabuto-$(LOGO)        $(OUT)/kabuto-$(LOGO_VISIBLE)        $(OUT)/kabuto-$(LOGO_MIDVISIBLE)
lucy:                   $(OUT)/lucy-$(LOGO)          $(OUT)/lucy-$(LOGO_VISIBLE)          $(OUT)/lucy-$(LOGO_MIDVISIBLE)
maltese:             $(OUT)/maltese-$(LOGO)       $(OUT)/maltese-$(LOGO_VISIBLE)       $(OUT)/maltese-$(LOGO_MIDVISIBLE)
maltese-round: $(OUT)/maltese-round-$(LOGO) $(OUT)/maltese-round-$(LOGO_VISIBLE) $(OUT)/maltese-round-$(LOGO_MIDVISIBLE)
sauron:               $(OUT)/sauron-$(LOGO)        $(OUT)/sauron-$(LOGO_VISIBLE)        $(OUT)/sauron-$(LOGO_MIDVISIBLE)
sith:                   $(OUT)/sith-$(LOGO)          $(OUT)/sith-$(LOGO_VISIBLE)          $(OUT)/sith-$(LOGO_MIDVISIBLE)
umbrella:           $(OUT)/umbrella-$(LOGO)      $(OUT)/umbrella-$(LOGO_VISIBLE)      $(OUT)/umbrella-$(LOGO_MIDVISIBLE)
wolfram:             $(OUT)/wolfram-$(LOGO)       $(OUT)/wolfram-$(LOGO_VISIBLE)       $(OUT)/wolfram-$(LOGO_MIDVISIBLE)
shiva:                       $(OUT)/$(LOGO)               $(OUT)/$(LOGO_VISIBLE)               $(OUT)/$(LOGO_MIDVISIBLE)

$(OUT)/%-logo.txt: $(OUT)/%-$(LOGO_VISIBLE)
	img2txt "$<" | tee "$@"
$(OUT)/logo.txt:     $(OUT)/$(LOGO_VISIBLE)
	img2txt "$<" | tee "$@"

slack: $(OUT)/slack-hermes-$(LOGO_VISIBLE) $(OUT)/slack-e-corp-$(LOGO_VISIBLE) $(OUT)/slack-umbrella-$(LOGO_VISIBLE) $(OUT)/slack-sauron-$(LOGO_VISIBLE)
#$(OUT)/slack-hermes-$(LOGO_VISIBLE):   $(OUT)/hermes-$(LOGO_VISIBLE)   $(BLD)/slack.dim
#	$(CONVERT) $(CAPTION) -resize "$$(cat $(BLD)/slack.dim)"^ -gravity center -extent "$$(cat $(BLD)/slack.dim)" "$<" "$@"
#$(OUT)/slack-e-corp-$(LOGO_VISIBLE):   $(OUT)/e-corp-$(LOGO_VISIBLE)   $(BLD)/slack.dim
#	$(CONVERT) $(CAPTION) -resize "$$(cat $(BLD)/slack.dim)"^ -gravity center -extent "$$(cat $(BLD)/slack.dim)" "$<" "$@"
#$(OUT)/slack-umbrella-$(LOGO_VISIBLE): $(OUT)/umbrella-$(LOGO_VISIBLE) $(BLD)/slack.dim
#	$(CONVERT) $(CAPTION) -resize "$$(cat $(BLD)/slack.dim)"^ -gravity center -extent "$$(cat $(BLD)/slack.dim)" "$<" "$@"
$(OUT)/slack-%-$(LOGO_VISIBLE): $(OUT)/%-$(LOGO_VISIBLE) $(BLD)/slack.dim
	$(CONVERT) $(CAPTION) -resize "$$(cat $(BLD)/slack.dim)"^ -gravity center -extent "$$(cat $(BLD)/slack.dim)" "$<" "$@"
$(BLD)/slack.dim: $(BLD)/.sentinel
	echo 1000x1000 > "$@"

$(OUT)/%-$(LOGO):              $(BLD)/%-resize.$(LOGOEXT) $(BLD)/kali-2.$(LOGOEXT)
	BLEND=$(INVISIBLE)  $(SHELL) -c '$(GENLOGO)'
$(OUT)/$(LOGO):            $(BLD)/shiva-resize.$(LOGOEXT) $(BLD)/kali-2.$(LOGOEXT)
	BLEND=$(INVISIBLE)  $(SHELL) -c '$(GENLOGO)'
$(OUT)/%-$(LOGO_VISIBLE):      $(BLD)/%-resize.$(LOGOEXT) $(BLD)/kali-2.$(LOGOEXT)
	BLEND=$(VISIBLE)    $(SHELL) -c '$(GENLOGO)'
$(OUT)/$(LOGO_VISIBLE):    $(BLD)/shiva-resize.$(LOGOEXT) $(BLD)/kali-2.$(LOGOEXT)
	BLEND=$(VISIBLE)    $(SHELL) -c '$(GENLOGO)'
$(OUT)/%-$(LOGO_MIDVISIBLE):   $(BLD)/%-resize.$(LOGOEXT) $(BLD)/kali-2.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'
$(OUT)/$(LOGO_MIDVISIBLE): $(BLD)/shiva-resize.$(LOGOEXT) $(BLD)/kali-2.$(LOGOEXT)
	BLEND=$(MIDVISIBLE) $(SHELL) -c '$(GENLOGO)'

$(BLD)/%-resize.$(LOGOEXT): $(BLD)/%-transparent.$(LOGOEXT) $(BLD)/kali.dim
	$(RESIZE) $(TRANSPARENT) -resize "$$(cat $(BLD)/kali.dim)"\< -extent "$$(cat $(BLD)/kali.dim)" "$<" "$@"
	#$(RESIZE) $(TRANSPARENT) -resize `cat $(BLD)/kali.dim`^ -extent `cat $(BLD)/kali.dim` $< $@
# already transparent
$(BLD)/hermes-resize.$(LOGOEXT): $(BLD)/hermes.$(LOGOEXT) $(BLD)/kali.dim
	$(RESIZE) $(TRANSPARENT) -resize "$$(cat $(BLD)/kali.dim)"\< -extent "$$(cat $(BLD)/kali.dim)" "$<" "$@"
	#$(RESIZE) $(TRANSPARENT) -resize `cat $(BLD)/kali.dim`^ -extent `cat $(BLD)/kali.dim` $< $@
# already transparent
$(BLD)/maltese-resize.$(LOGOEXT): $(BLD)/maltese.$(LOGOEXT) $(BLD)/kali.dim
	$(RESIZE) $(TRANSPARENT) -resize "$$(cat $(BLD)/kali.dim)"\< -extent "$$(cat $(BLD)/kali.dim)" "$<" "$@"
$(BLD)/%-transparent.$(LOGOEXT):         $(BLD)/%-2.$(LOGOEXT)
	$(CONVERT) "$<" $(TRANSPARENT) "$@"
# not a black-and-white image
$(BLD)/sauron-transparent.$(LOGOEXT): $(BLD)/sauron.$(LOGOEXT)
	$(CONVERT) "$<" $(TRANSPARENT) "$@"
	#$(CONVERT) $^ -fuzz 0% -transparent red -background 'rgba(0,0,0,0)'
$(BLD)/%-2.$(LOGOEXT):                         $(BLD)/%.$(LOGOEXT)
	$(CONVERT) "$<" -colorspace gray -colors 2 -type bilevel "$@"

$(BLD)/kali-2.$(LOGOEXT): $(BLD)/random.$(LOGOEXT) $(BLD)/kali.$(LOGOEXT)
	BLEND=$(INVISIBLER) $(SHELL) -c '$(GENLOGO)'
$(BLD)/random.$(LOGOEXT): $(BLD)/random.out $(BLD)/kali.dim
	convert -depth 8 -size "$$(cat $(BLD)/kali.dim)" RGB:- "$@" < "$<"
$(BLD)/random.out: $(BLD)/random.sz fingerprint
	head -c "$$(cat $<)" /dev/urandom > "$@"
$(BLD)/random.sz: $(BLD)/kali.dim
	echo $$((3*$$(sed 's/x/*/' $<))) | tee "$@"
fingerprint: # unique every time

$(BLD)/%.$(LOGOEXT): $(DLD)/%.jpg $(BLD)/.sentinel
	$(CONVERT) -strip "$<" "$@"
$(BLD)/kali.$(LOGOEXT): $(DLD)/kali.jpg $(BLD)/.sentinel
	$(CONVERT) -strip -normalize "$<" "$@"
$(DLD)/%.jpg: %.url $(DLD)/.sentinel
	$(WGET)
$(BLD)/aperture.$(LOGOEXT): $(DLD)/aperture.$(LOGOEXT) $(BLD)/.sentinel
	$(CONVERT) -strip "$<" "$@"
	#cp -v $< $@
$(BLD)/hermes.$(LOGOEXT): $(DLD)/hermes.$(LOGOEXT) $(BLD)/.sentinel
	$(CONVERT) -strip "$<" "$@"
	#cp -v $< $@
$(BLD)/maltese.$(LOGOEXT): $(DLD)/maltese.$(LOGOEXT) $(BLD)/.sentinel
	$(CONVERT) -strip "$<" "$@"
	#cp -v $< $@
$(BLD)/sauron.$(LOGOEXT): $(DLD)/sauron.$(LOGOEXT) $(BLD)/.sentinel
	$(CONVERT) -strip -normalize "$<" "$@"
	#cp -v $< $@
$(BLD)/umbrella.$(LOGOEXT): $(DLD)/umbrella.$(LOGOEXT) $(BLD)/.sentinel
	$(CONVERT) -strip "$<" "$@"
	#cp -v $< $@
$(DLD)/%.png: %.url $(DLD)/.sentinel
	$(WGET)

$(DLD)/.sentinel: # $(OUT)/.sentinel
	[ -d   "$$(dirname $@)" ] || \
	mkdir -v "$$(dirname $@)"
	touch               "$@"
$(BLD)/.sentinel: $(OUT)/.sentinel
	[ -d   "$$(dirname $@)" ] || \
	mkdir -v "$$(dirname $@)"
	touch               "$@"
$(OUT)/.sentinel:
	[ -d   "$$(dirname $@)" ] || \
	mkdir -v "$$(dirname $@)"
	touch               "$@"
$(TST)/.sentinel: $(OUT)/.sentinel
	[ -d   "$$(dirname $@)" ] || \
	mkdir -v "$$(dirname $@)"
	touch               "$@"
$(STG)/.sentinel: $(OUT)/.sentinel
	[ -d   "$$(dirname $@)" ] || \
	mkdir -v "$$(dirname $@)"
	touch               "$@"



distclean: cleaner
	$(RM) -r $(DLD)
cleaner: clean
	$(RM) -r $(OUT) $(STG)
clean:
	$(RM) -r $(BLD) $(TST)

