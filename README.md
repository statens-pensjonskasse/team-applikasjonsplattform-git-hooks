# Team applikasjonsplattform git hooks

Enforcer teamets commit-meldinger

Husk at hooks-katalogen ikke tas med når du kloner, så
for å få sjekkene lokalt, er et alternativ å:

## Legge til i hvert repo loalt

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
```

## Global lokal config

Det er også mulig å legge til dette repoet globalt i lokal git config med noe ala:

`git config --global core.hooksPath /path/to/my/centralized/hooks`

Merk at dette vil disable alle hooks du har lagt til i dine lokale repos.

## Lokal utvikling

Kjør `make test`for noen enkle tester av commit-meldingene.

Legg evt. til nye tester som filer i `test/`.
