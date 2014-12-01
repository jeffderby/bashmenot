set -o pipefail

export BASHMENOT_DIR
BASHMENOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )

source "${BASHMENOT_DIR}/src/date.sh"
source "${BASHMENOT_DIR}/src/sort.sh"
source "${BASHMENOT_DIR}/src/log.sh"
source "${BASHMENOT_DIR}/src/expect.sh"
source "${BASHMENOT_DIR}/src/platform.sh"
source "${BASHMENOT_DIR}/src/line.sh"
source "${BASHMENOT_DIR}/src/file.sh"
source "${BASHMENOT_DIR}/src/hash.sh"
source "${BASHMENOT_DIR}/src/tar.sh"
source "${BASHMENOT_DIR}/src/git.sh"
source "${BASHMENOT_DIR}/src/curl.sh"
source "${BASHMENOT_DIR}/src/s3.sh"


bashmenot_self_update () {
	if (( ${BASHMENOT_NO_SELF_UPDATE:-0} )); then
		return 0
	fi
	if [[ ! -d "${BASHMENOT_DIR}/.git" ]]; then
		return 1
	fi

	local url
	url="${BASHMENOT_URL:-https://github.com/mietek/bashmenot}"

	log_begin 'Self-updating bashmenot...'

	local commit_hash
	if ! commit_hash=$( git_update_into "${url}" "${BASHMENOT_DIR}" ); then
		log_end 'error'
		return 1
	fi
	log_end "done, ${commit_hash:0:7}"

	BASHMENOT_NO_SELF_UPDATE=1 \
		source "${BASHMENOT_DIR}/src.sh"
}


if ! bashmenot_self_update; then
	log_warning 'Cannot self-update bashmenot'
fi
