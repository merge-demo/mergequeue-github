#!/usr/bin/env bash
# Enqueue a PR into the GitHub merge queue. Called by `mq generate` via `merge.run` in
# .config/mq.toml. `--auto` adds the PR to the queue once its required checks pass.
#
# Always exits 0: mq aborts the whole generate run if the enqueue command fails, and one PR that
# could not be enqueued should not stop the load.
set -uo pipefail

pr="$1"
for attempt in 1 2 3 4 5; do
	if gh pr merge "${pr}" --auto --squash; then
		exit 0
	fi
	# A PR that was just created can briefly report an unknown mergeable state.
	sleep $((attempt * 5))
done

echo "failed to enqueue PR ${pr} into the GitHub merge queue" >&2
exit 0
