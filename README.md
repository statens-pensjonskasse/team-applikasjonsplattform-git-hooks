# Team applikasjonsplattform git hooks

Enforcer teamets commit-meldinger

Husk at hooks-katalogen ikke tas med når du kloner, så
for å få sjekkene lokalt, må du legge til i alle repoene dine etter at du har klonet.

For ett repo, når du står i rotkatalogen:

```bash
curl https://github.com/statens-pensjonskasse/team-applikasjonsplattform-git-hooks/raw/master/commit-msg > .git/hooks/commit-msg
```

For å legge til i alle utsjekkede repoer du har under stående katalog:

```bash
`curl https://github.com/statens-pensjonskasse/team-applikasjonsplattform-git-hooks/raw/master/commit-msg > /tmp/commit-msg`
find . -type d -name .git -exec pwd;
```
