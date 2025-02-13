# Team applikasjonsplattform git hooks

Enforcer teamets commit-meldinger

Husk at hooks-katalogen ikke tas med når du kloner, så
for å få sjekkene lokalt, må du legge til i alle repoene dine etter at du har klonet.

For ett repo, når du står i rotkatalogen:

```bash
curl -sf https://raw.githubusercontent.com/statens-pensjonskasse/team-applikasjonsplattform-git-hooks/refs/heads/main/commit-msg >| .git/hooks/commit-msg && chmod 755 .git/hooks/commit-msg
```

For å legge til i alle utsjekkede repoer du har under stående katalog:

```bash
TMPDIR=$(mktemp -d) ;
curl -sf https://raw.githubusercontent.com/statens-pensjonskasse/team-applikasjonsplattform-git-hooks/refs/heads/main/commit-msg > "$TMPDIR/commit-msg" ;
chmod 755 "$TMPDIR/commit-msg" ;
find . -type d -name .git -execdir cp -p -v "$TMPDIR/commit-msg" .git/hooks/ \; ;
unset TMPDIR
