# Site URL comes from site.yaml so there is one place to change it.
SITE  := $(shell sed -n 's/^url:[[:space:]]*//p' site.yaml)
PAGES := $(filter-out README.md CLAUDE.md,$(wildcard *.md)) $(wildcard p/*.md)
HTML  := $(PAGES:.md=.html)

# Map an output path to its canonical URL: index.html -> SITE/, p/x.html -> SITE/p/x
canon = $(SITE)/$(patsubst index,,$(1:.html=))

all: $(HTML) sitemap.xml redirects

%.html: %.md template.html site.yaml
	pandoc $< --template=template.html --metadata-file=site.yaml --wrap=none --css=$(if $(findstring /,$@),../style.css,style.css) -V site="$(SITE)" -V canonical="$(call canon,$@)" -V mdpath="/$(@:.html=.md)" --output=$@

sitemap.xml: $(HTML)
	@echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	@echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> $@
	@for f in $(HTML); do \
	  case "$$f" in \
	    index.html) url="$(SITE)/" ;; \
	    *) url="$(SITE)/$${f%.html}" ;; \
	  esac; \
	  lastmod=$$(date -r "$$f" +%Y-%m-%d); \
	  echo "  <url><loc>$$url</loc><lastmod>$$lastmod</lastmod></url>" >> $@; \
	done
	@echo '</urlset>' >> $@

# GitHub Pages ignores _redirects, so turn each short link in it (lines without a
# trailing !) into a tiny <path>/index.html that forwards to the target.
redirects: _redirects
	@grep -vE '^[[:space:]]*(#|$$)' _redirects | grep -v '!' | while read -r from to _; do \
	  mkdir -p ".$$from"; \
	  printf '<!DOCTYPE html>\n<html lang="en"><head><meta charset="utf-8"><title>Redirecting</title><link rel="canonical" href="%s"><meta http-equiv="refresh" content="0; url=%s"></head><body><p><a href="%s">%s</a></p></body></html>\n' "$$to" "$$to" "$$to" "$$to" > ".$$from/index.html"; \
	done

# Opens with `open` on macOS; use xdg-open on Linux.
preview: all
	open index.html

clean:
	rm -f $(HTML) sitemap.xml

.PHONY: all preview clean redirects
