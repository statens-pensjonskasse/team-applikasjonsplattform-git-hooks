#! /bin/bash

#===========================================================
# Deklarasjon av variable + evt. debug
#===========================================================
[[ -n "$DEBUG" ]] && set -x # turn -x on if DEBUG is set to a non-empty string
#set -n # Utfører ikke kommandoene, men sjekker syntaks
set -o nounset # Feiler hvis man prøver å bruke en uinitialisert variabel
set -o errexit # Avslutter umiddelbart hvis et statement returnerer false. Trengs for at trap skal fungere

FLG_QUIET=false
RECURSIVE=false
STRICT_VERSION=false

#===========================================================
# Funksjoner
#===========================================================

Fail() {
    echo "${1:-}"
    exit 1
}

PromptToContinue () {
    # Skriver ut prompt dersom FLG_QUIET ikke er satt
    # 0=ja, 1=nei
    local text="$1"
    if [[ "$FLG_QUIET" != "true" ]] ; then
        read -p "$text (j/n) " svar
        [[ "$svar" != j ]] && return 1
    fi
    return 0
}

Usage() {
    local rc=${1:-}
    echo "NAME"
    echo "    $(basename "$0") - installerer eller oppdaterer git hooks i ett eller flere git-repos"
    echo
    echo "SYNOPSIS"
    echo "    $(basename "$0") [TODO]"
    echo
    echo "BESKRIVELSE"
    echo "    Installerer hook-fila fra lokalt repo, slik at du evt. kan gjøre ikke-commitede"
    echo "    tilpasninger hvis du ønsker det."
    echo "    Du må angi stien til git-repoet du ønsker å installere i."
    echo "    Du kan også angi -r for rekursiv installasjon, hvor scriptet installerer i alle .-git.kataloger under valgt"
    echo
    echo "PARAMETRE"
    echo "    -h         - viser hjelp og avslutter"
    echo "    -r         - rekursiv installasjon. Installerer i alle .git-kataloger under angitt installasjonskatalog"
    echo "    -s         - installerer strict-utgaven av hooks-scriptet, som krever en issueref"
    echo "                 eller teksten \"noref\""
    echo
    echo "Eksempler"
    echo "    $(basename "$0") $HOME/src/INFRA/puppet-control"
    echo "        Installerer \"avslappet\" utgave i puppet-repoet"
    echo "    $(basename "$0") -r -s $HOME/src/INFRA"
    echo "        Installerer \"avslappet\" utgave rekursivt i alle .git-kataloger under $HOME/src/INFRA"
    echo "    $(basename "$0") -q -s -r ~/src/"
    echo "        Installerer \"strict\" utgave rekursivt i alle .git-kataloger under ~/src/"
    exit "$rc"
}

#===========================================================
# Hovedprogram
#===========================================================

while getopts hm:qrs OPT ; do
    case "$OPT" in
        h)
            Usage 0;;
        q)
            FLG_QUIET=true;;
        r)
            RECURSIVE=true;;
        s)
            STRICT_VERSION=true;;
        ?)
            Usage 1;;
    esac
done
shift $((OPTIND - 1))

INSTALLDIR="${1:-}"

[[ -z "$INSTALLDIR" ]] && Fail "Installasjonskatalog må angis. -h for hjelp."
[[ -d "$INSTALLDIR" ]] || Fail "Installasjonskatalog $INSTALLDIR eksisterer ikke."

if [[ "$STRICT_VERSION" = true ]]; then
    FILENAME="$(dirname "$(realpath "$0")")/commit-msg-strict"
else
    FILENAME="$(dirname "$(realpath "$0")")/commit-msg"
fi

if [[ $RECURSIVE = true ]] ; then
    RECURSIVE_TEXT="REKURSIVT"
fi
if ! PromptToContinue "Ønsker du å installere hooken $FILENAME ${RECURSIVE_TEXT:-} i $INSTALLDIR?" ; then
    exit 1
fi

if [[ $RECURSIVE = false ]] ; then
    cp -v $FILENAME "$INSTALLDIR/.git/hooks/commit-msg" && chmod 755 "$INSTALLDIR/.git/hooks/commit-msg"
else
    find "$INSTALLDIR" -name ".git" -type d -exec cp -v "$FILENAME" {}/hooks/commit-msg \; && find "$INSTALLDIR" -name ".git" -type d -exec chmod 755 {}/hooks/commit-msg \;
fi
