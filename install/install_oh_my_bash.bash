#!/usr/bin/env bash
OSH="${HOME}/.oh-my-bash"

sparse_download() {
	tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'tmpdir')
	pushd $tmpdir

	git init
	git remote add origin https://github.com/ohmybash/oh-my-bash.git
	git sparse-checkout init
	git sparse-checkout set /README.md
	git sparse-checkout add /CODE_OF_CONDUCT.md
	git sparse-checkout add /CONTRIBUTING.md
	git sparse-checkout add /LICENSE.md
	git sparse-checkout add /aliases
	git sparse-checkout add /cache
	git sparse-checkout add /completions
	git sparse-checkout add /custom
	git sparse-checkout add /lib
	git sparse-checkout add /log
	git sparse-checkout add /oh-my-bash.sh
	git sparse-checkout add /plugins/bashmarks
	git sparse-checkout add /plugins/git
	git sparse-checkout add /plugins/kubectl
	git sparse-checkout add /templates
	git sparse-checkout add /themes/font
	git sparse-checkout add /themes/THEMES.md
	git sparse-checkout add /themes/base.theme.sh
	git sparse-checkout add /themes/colours.theme.sh
	git sparse-checkout add /tools

	git pull --ff-only --depth 1 origin master

	rm -rf .git
	popd
	mv $tmpdir $OSH
}
export -f sparse_download

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh"\
    "| sed -e '1h;2,$H;$!d;g' -e 's/env git clone[^{]*{[^}]*}/sparse_download/')"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     sed -i '' 's/# DISABLE_AUTO_UPDATE="true"/DISABLE_AUTO_UPDATE="true"/' "${HOME}/.bashrc";;
    Darwin*)    sed -i '' 's/# DISABLE_AUTO_UPDATE="true"/DISABLE_AUTO_UPDATE="true"/' "${HOME}/.bashrc";;
    CYGWIN*)    ;;
    MINGW*)     ;;
    *)          ;;
esac
echo ${machine}