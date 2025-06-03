# Enforce conventional commits git hooks

Enforcer commit-meldinger til å følge [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).

Hooks-katalogen tas som kjent ikke med når du kloner, så
for å få sjekkene lokalt, må de legges inn i hooks-katalogen i hvert repo du vil ha de i.

## Installasjon uten å klone repoet

### Standard utgave som ikke krever issueref

#### Linux

For ett repo, når du står i rotkatalogen, kjør følgende:

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

### Strict utgave som krever issueref

#### Linux

For ett repo, når du står i rotkatalogen, kjør følgende:

```bash
curl -sf https://raw.githubusercontent.com/statens-pensjonskasse/team-applikasjonsplattform-git-hooks/refs/heads/main/commit-msg-strict >| .git/hooks/commit-msg && chmod 755 .git/hooks/commit-msg
```

For å legge til i alle utsjekkede repoer du har under stående katalog:

```bash
TMPDIR=$(mktemp -d) ;
curl -sf https://raw.githubusercontent.com/statens-pensjonskasse/team-applikasjonsplattform-git-hooks/refs/heads/main/commit-msg-strict > "$TMPDIR/commit-msg" ;
chmod 755 "$TMPDIR/commit-msg" ;
find . -type d -name .git -execdir cp -p -v "$TMPDIR/commit-msg" .git/hooks/ \; ;
unset TMPDIR
```

## Installasjon dersom du har klonet repoet

Kjør `./install.sh` fra dette repoets katalog.

Bruk `-h` for hjelp, men kort fortalt kan du angi `-s` for å få strict-utgaven (som krever issueref)
og `-r` for å installere rekursivt under angitt katalog. F.eks.

```bash
# Strict-versjon i ett repo
./install.sh -s ~/src/INFRA/puppet-control
# Strict-versjon i alle repos under INFRA-katalogen
./install.sh -s -r ~/src/INFRA
# Standard-versjon i alle repos under src-katalogen
./install.sh -r ~/src
```

## Global lokal config

Det er også mulig å legge til dette repoet globalt i din git config ved å klone dette repoet og sette:

`git config --global core.hooksPath /sti/til/dette/repoet`

Merk at dette vil disable alle hooks du har lagt til i dine lokale repos, og gjøre det vanskelig å ha hooks fra andre kilder.

## Lokal utvikling

Kjør `make test`for noen enkle tester av commit-meldingene.

Legg evt. til nye tester som filer i `test/`.

## GitHub Repository Rulesets

commit-msg / conventional-commits (valgfritt issue ref i slutten)

```sh
^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([\w\-\.]+\))?(!)?: [^()]+(\(([A-Z]+-[0-9]+|#[0-9]+|noref)\))?(.+)?|Merge pull request #\d+ from .+
```

commit-msg-strict / conventional-commits-strict (må ha issue ref eller eksplisit noref i slutten)

```sh
^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([\w\-\.]+\))?(!)?: [^()]+(\(([A-Z]+-[0-9]+|#[0-9]+|noref)\))(.+)?|Merge pull request #\d+ from .+
```
