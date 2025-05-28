#!/bin/bash

PASS=0
FAIL=1
EXIT_CODE=0

test_commit_msg_strict() {
    test_msg "$1" "$2" "./commit-msg-strict"
}

test_commit_msg() {
    test_msg "$1" "$2" "./commit-msg"
}

test_msg() {
    local msg="$1"
    local expected="$2"

    tmpfile=$(mktemp)
    echo "$msg" >"$tmpfile"

    $($3 "$tmpfile" >/dev/null 2>&1)

    result=$?

    rm -f "$tmpfile"

    if [ $expected -eq 0 ]; then
        expected_result="VALID MSG"
    else
        expected_result="INVALID MSG"
    fi

    if [ $result -ne $expected ]; then
        echo "❌ Test failed for commit message:"
        echo "   \"$msg\""
        EXIT_CODE=1
    else
        echo "✅ Test passed ($expected_result): \"$msg\""
        return $PASS
    fi
}

test_commit_msg "jalla: #1 ikke-godkjent scope" $FAIL
test_commit_msg "feat #1 mangler kolon" $FAIL
test_commit_msg "feat(cool stuff): PLAT-123 med scope og jiraref" $PASS
test_commit_msg "fix(not so cool stuff): #42 med scope og github issueref" $PASS
test_commit_msg "feat: # uten scope, med eksplisitt 'no issueref'" $PASS
test_commit_msg "Merge branch 'hotfix/PLAT-5307-rabbitmq-prometheus-metrics' into test" $PASS
test_commit_msg "feat: har ikke issueref, men funker" $PASS

test_commit_msg_strict "feat: added a cool feature" $FAIL
test_commit_msg_strict "feat!: added a cool feature" $FAIL
test_commit_msg_strict "feat(scope)!: added a cool feature" $FAIL
test_commit_msg_strict "feat: added a cool feature (noref)" $PASS
test_commit_msg_strict "feat: added a cool feature (PLAT-123)" $PASS
test_commit_msg_strict "feat!: added a cool feature (PLAT-123)" $PASS
test_commit_msg_strict "feat(scope): added a cool feature (noref)" $PASS
test_commit_msg_strict "feat(scope): added a cool feature (PLAT-123)" $PASS
test_commit_msg_strict "feat(scope)!: added a cool feature (PLAT-123)" $PASS
test_commit_msg_strict "feat(scope)!: added a cool feature (#42)" $PASS

return $EXIT_CODE
