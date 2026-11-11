# Expedito Olimi — personal website

A minimal static site built from Markdown with pandoc and make, adapted from
[markdownhomepage](https://github.com/markdownhomepage/markdownhomepage.github.io), the setup
described in Stephen Turner's post
[A personal website](https://blog.stephenturner.us/p/personal-website).

## Build and preview

```sh
make            # builds every .md into .html, plus sitemap.xml
make preview    # builds and opens index.html
```

Edit the `.md` files, never the generated `.html`.

## Files

```
site.yaml        site URL, name, structured data (edit `url` when you have a domain)
index.md         homepage (bio + link buttons)
p/research.md    research themes and methods
p/publications.md full publication list
p/cv.md          positions, education, funding, teaching, service
p/pub-*.md       one summary page per paper, linked from p/publications.md and llms.txt
llms.txt         index of every page's .md address for AI agents
template.html    pandoc template
style.css        light/dark styles
_redirects       short links (/cv, /scholar, ...); `make` turns them into
                 <path>/index.html forwarding pages for GitHub Pages
.nojekyll        stops GitHub Pages from re-processing the .md files
files/           static files (put headshot.jpg here)
```

## Hosting

Published with GitHub Pages from the `main` branch of `kaboyo/kaboyo.github.io` at
https://kaboyo.github.io. To update: edit the `.md` files, then

```sh
make && git add . && git commit -m "Update site" && git push
```

Optional: add `files/headshot.jpg` and uncomment the `image` line in `index.md` and
`social-image` in `site.yaml`.
