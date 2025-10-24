#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/dorkitude/linctl"
TOOL_NAME="linctl"
TOOL_TEST="linctl --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if linctl is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$GH_REPO/archive/refs/tags/v${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	# Check if Go is installed
	if ! command -v go &>/dev/null; then
		fail "Go is required to build $TOOL_NAME. Please install Go first."
	fi

	(
		mkdir -p "$install_path"

		# Build linctl from source
		echo "* Building $TOOL_NAME $version from source..."
		cd "$ASDF_DOWNLOAD_PATH"

		# Build with version information injected via ldflags (matching Homebrew formula)
		go build -ldflags="-s -w -X github.com/dorkitude/linctl/cmd.version=${version}" \
			|| fail "Failed to build $TOOL_NAME"

		# Move the built binary to the install path
		mv "$TOOL_NAME" "$install_path/$TOOL_NAME" || fail "Failed to move binary to $install_path"
		chmod +x "$install_path/$TOOL_NAME"

		# Verify the binary is executable
		test -x "$install_path/$TOOL_NAME" || fail "Expected $install_path/$TOOL_NAME to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
