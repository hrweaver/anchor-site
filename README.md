# anchorph.one — Anchor marketing site

The public site for **Anchor Focus** (the adult accountability app). A lightweight, dark,
single-screen splash plus the hosted legal pages. This repo *is* the site — what's on `main`
is what's live.

## Hosting & deploy

- **Host:** GitHub Pages, from this repo (`hrweaver/anchor-site`), branch `main`.
- **Domain:** `anchorph.one` — the custom domain is set by the `CNAME` file in this repo.
  DNS lives at **Porkbun** (A records → GitHub Pages IPs; `www` CNAME → `hrweaver.github.io`).
  Porkbun also holds the Brevo email records for the domain — **don't touch those.**
- **Deploy = push to `main`.** GitHub Pages rebuilds automatically (~1 min). There is **no build
  step** for the splash; it's static HTML. Verify after a push:
  ```bash
  curl -s -o /dev/null -w "%{http_code}\n" https://anchorph.one/
  ```
  Favicons and browsers cache hard — hard-refresh / use an incognito tab to see changes.

## Layout

```
index.html          splash page (dark, coming-soon style, "Get it on Google Play")
privacy/index.html  Privacy Policy   → https://anchorph.one/privacy
terms/index.html    Terms of Service → https://anchorph.one/terms
build-legal.js      regenerates the two legal pages from ~/anchor-legal (see below)
assets/
  wordmark.png        the "anchor" wordmark (the "o" is an anchor glyph)
  favicon-32/64.png   browser-tab icon = the real app icon (periwinkle anchor on near-black)
  apple-touch-icon.png  180px, for "Add to Home Screen"
CNAME               "anchorph.one" — do not delete (it's what binds the custom domain)
```

Local preview: `python3 -m http.server 8080` in this dir, then open `http://localhost:8080/`.

## Legal pages (Privacy + Terms) — how they're generated

**The source of truth is the `hrweaver/anchor-legal` repo, NOT this one.** The `/privacy` and
`/terms` pages here are *generated* from `~/anchor-legal/PRIVACY.md` and `TERMS.md`, rendered
verbatim (markdown-it, no smart-quote/typographer rewriting) into the site's dark template.

To update the legal text:
1. Edit the markdown in **`~/anchor-legal`** (bump the "Last Updated" line; keep the same
   filenames — see the constraint below).
2. Regenerate the site pages:
   ```bash
   node build-legal.js
   ```
3. Commit + push this repo. Pages redeploys.

## ⚠️ CRITICAL: the GitHub legal URLs must stay alive

The original GitHub URLs are the **legally-submitted** privacy/terms links **and are hardcoded
into every shipped version of both apps** (Settings → legal footer):

- `https://github.com/hrweaver/anchor-legal/blob/main/PRIVACY.md`
- `https://github.com/hrweaver/anchor-legal/blob/main/TERMS.md`

So hosting on `anchorph.one` is **additive, not a replacement**. Rules:

- **Never delete / rename / make-private the `anchor-legal` repo.** Old installed app versions
  link to it forever, and it's the URL the stores currently have on file.
- **To move the stores to the new URLs** (optional, when ready): update **Play Console** (App
  content → Privacy policy → `https://anchorph.one/privacy`) and **App Store Connect** (App
  Information → Privacy Policy URL). The in-app links change only in a **future app build**.
- Keep GitHub as a permanent mirror regardless.

## Notes

- The splash intentionally reads "coming-soon"/minimal: no spinning-anchor video, one calm CTA,
  soft glow, gentle fade-in. It's honest — Android is live on Play, iPhone is "coming soon."
- ⚠️ **Work from a stable clone of this repo** (e.g. `~/anchor-site`), not a temp/scratch copy —
  a scratch working copy corrupted its git objects and lost its `origin` remote mid-session.
