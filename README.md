# anchorph.one — Anchor marketing site

The **umbrella brand site for Anchor**: the accountability idea, who you can be accountable to
(partners, parents and kids, friends), and both products. Dark, static, one scrolling page plus
the hosted legal pages. This repo *is* the site — what's on `main` is what's live.

It is *not* the kids parent dashboard. That's the separate Next.js app at
`~/anchor_kids_parent/web` (marketing + auth + dashboard, not currently deployed).

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
index.html          the whole marketing page (see "Page + copy rules" below)
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

## Page + copy rules

Sections, in order: hero → why it works → **who's in it with you** (partners / parents and kids /
friends) → four-step how-it-works → the two apps → built on trust, not control → close → footer.
All hand-written HTML/CSS in `index.html`, inline SVG icons, no framework and no build step.

Four rules to keep when editing:

1. **Only claim what ships.** Anchor Android is live on Play; iPhone is TestFlight-only, so it is
   always "coming soon", never "on the App Store". Anchor Kids is "in development" with a
   `mailto:` notify link, not a signup. Don't print a price — the $9.99/mo family plan has no
   billing built yet.
2. **What a partner can see is a legal claim.** As of PRIVACY.md v1.8 (July 2026) partners see
   *setup status* ("your protection is on and holding") and *the requests you send*. They no
   longer see app usage, screen time, or blocked-app attempts. Re-read `~/anchor-legal/PRIVACY.md`
   before writing anything about partner visibility.
3. **Keep the tone positive and non-creepy.** Reviewed line by line 2026-07-27, so don't
   reintroduce: surveillance words (someone "notices" / watches you), late-night temptation
   framing (11pm, midnight, 1am — that register reads like purity accountability, not phone
   habits), "you are bad at this" framing, treating friends as the fallback for people without a
   spouse, or "someone you love" where "someone you trust" covers more people. Say what the
   product gives you, not how you keep failing.
4. **No em dashes in the copy.** House style.

The `:root` custom properties here are deliberately the same set `build-legal.js` uses, so the
page and the legal pages stay one visual system. Change them in both places or neither.
- ⚠️ **Work from a stable clone of this repo** (e.g. `~/anchor-site`), not a temp/scratch copy —
  a scratch working copy corrupted its git objects and lost its `origin` remote mid-session.
