#!/usr/bin/env bash
# Enqueue a PR into the GitHub merge queue. Called by `mq generate` via `merge.run` in
# .config/mq.toml.
#
# A PR on the default branch uses `--auto`, which adds it to the queue once its required checks
# pass. GitHub rejects auto-merge for stacked PRs ("Auto-merge is not supported for stacked pull
# requests"), so for a stack tip (base is another PR's branch) this retries a plain enqueue until
# the checks on the stack have passed. Enqueueing the tip queues every PR in the stack.
#
# Always exits 0: mq aborts the whole generate run if the enqueue command fails, and one PR that
# could not be enqueued should not stop the load.
set -uo pipefail

pr="$1"
base=$(gh pr view "${pr}" --json baseRefName --jq .baseRefName)
default=$(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name)

if [[ ${base} == "${default}" ]]; then
	auto=(--auto)
	attempts=5
else
	auto=()
	attempts=20
fi

for attempt in $(seq "${attempts}"); do
	if gh pr merge "${pr}" "${auto[@]}" --squash; then
		exit 0
	fi
	# A PR that was just created can briefly report an unknown mergeable state, and a stack tip
	# can't be enqueued until the PR checks below it have passed.
	sleep $((attempt < 3 ? attempt * 5 : 15))
done

echo "failed to enqueue PR ${pr} into the GitHub merge queue" >&2
exit 0
