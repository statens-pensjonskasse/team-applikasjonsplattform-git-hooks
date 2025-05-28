#!/bin/bash

PASS=0
FAIL=1

test_commit_msg() {
    local msg="$1"
    local expected="$2"

    tmpfile=$(mktemp)
    echo "$msg" >"$tmpfile"

    ./commit-msg-strict "$tmpfile" >/dev/null 2>&1
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
    else
        echo "✅ Test passed ($expected_result): \"$msg\""
    fi
}

test_commit_msg "feat: added a cool feature" $FAIL
test_commit_msg "feat!: added a cool feature" $FAIL
test_commit_msg "feat(scope)!: added a cool feature" $FAIL
test_commit_msg "feat: added a cool feature (noref)" $PASS
test_commit_msg "feat: added a cool feature (PLAT-123)" $PASS
test_commit_msg "feat!: added a cool feature (PLAT-123)" $PASS
test_commit_msg "feat(scope): added a cool feature (noref)" $PASS
test_commit_msg "feat(scope): added a cool feature (PLAT-123)" $PASS
test_commit_msg "feat(scope)!: added a cool feature (PLAT-123)" $PASS
test_commit_msg "feat(scope)!: added a cool feature (#42)" $PASS
