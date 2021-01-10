command -v support
support &
P="$!"
support_exit () {
	[ $# -eq 1 ]
	e="$?"
	kill    "$1"
	wait    "$1" || :
	exit    "$e"
	unset     e
}
kill -0 "$P"
# shellcheck disable=SC2064
trap "support_exit $P" 0
unset P

