#!/bin/sh
# Launch day for Anchor Dumb Phone: point every call to action on /dumb-phone/ at the Play
# listing, drop the "in review" chip, commit and push. Run once, from ~/anchor-site.
#
#   sh go-live-dumb-phone.sh
#
# Safe to re-run: it does nothing if the mailto is already gone.
set -e
cd "$(dirname "$0")"
P=dumb-phone/index.html
PLAY='https://play.google.com/store/apps/details?id=com.anchorapp.dumbphone&referrer=utm_source%3Danchorph.one%26utm_medium%3Dwebsite%26utm_campaign%3Ddumb-phone'
MAILTO='mailto:support@anchorph.one?subject=Anchor%20Dumb%20Phone%3A%20tell%20me%20when%20it%20is%20live'

if ! grep -q "$MAILTO" "$P"; then echo "already live"; exit 0; fi

python3 - "$P" "$PLAY" "$MAILTO" <<'EOF'
import sys
p, play, mailto = sys.argv[1:]
s = open(p).read()
s = s.replace(mailto, play)
s = s.replace('Tell me when it is on Google Play', 'Get it on Google Play')
s = s.replace('Android · In review on Google Play', 'Android · Live on Google Play')
s = s.replace('<span class="chip"><span class="dot"></span>Android · Live on Google Play</span>',
              '<span class="chip live"><span class="dot"></span>Android · Live on Google Play</span>')
s = s.replace('It is in review on Google Play\n          now.', 'It is on Google Play now.')
s = s.replace('It is in review on Google\n          Play now.', 'It is on Google Play now.')
open(p, 'w').write(s)
print('page updated')
EOF

git add "$P"
git -c user.name="Harry Weaver" -c user.email="harryweaver@Harrys-Air.lan" \
  commit -qm "Dumb Phone page: live on Google Play, buttons point at the listing"
git push origin main
echo "pushed; live at https://anchorph.one/dumb-phone/ in about a minute"
