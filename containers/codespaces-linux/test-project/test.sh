#!/bin/bash
cd $(dirname "$0")

source test-utils.sh codespace

# Run common tests
checkCommon

# Check default extensions
checkExtension "gitHub.vscode-pull-request-github"

# Check Oryx
check "oryx" oryx --version

# Check .NET
check "dotnet" dotnet --list-sdks
check "oryx-install-dotnet-3.1.0" oryx prep --skip-detection --platforms-and-versions dotnet=3.1.0
check "dotnet-3.1.0-installed" bash -c 'dotnet --info | grep -E "\s3\.1\.0\s"'

# Check Python
check "python" python --version
check "pip" pip3 --version
check "pipx" pipx --version
check "pylint" pylint --version
check "flake8" flake8 --version
check "autopep8" autopep8 --version
check "yapf" yapf --version
check "mypy" mypy --version
check "pydocstyle" pydocstyle --version
check "bandit" bandit --version
check "virtualenv" virtualenv --version

# Check Java tools
check "java" java -version
check "sdkman" bash -c ". /usr/local/sdkman/bin/sdkman-init.sh && sdk version"
check "gradle" gradle --version
check "maven" mvn --version

# Check Ruby tools
check "ruby" ruby --version
check "rvm" bash -c ". /usr/local/rvm/scripts/rvm && rvm --version"
check "rbenv" bash -c 'eval "$(rbenv init -)" && rbenv --version'
check "rake" rake --version

# Check Jekyll dynamic install
mkdir jekyll-test
cd jekyll-test
touch _config.yml
check "oryx-build-jekyll" oryx build --apptype static-sites --manifest-dir /tmp
check "jekyll" jekyll --version
cd ..
rm -rf jekyll-test

# Node.js
check "node" node --version
check "nvm" bash -c ". /home/codespace/.nvm/nvm.sh && nvm --version"
check "nvs" bash -c ". /home/codespace/.nvs/nvs.sh && nvs --version"
check "yarn" yarn --version
check "npm" npm --version

# PHP
check "php" php --version
check "Xdebug" php --version | grep 'Xdebug'

# Rust
check "cargo" cargo --version
check "rustup" rustup --version
check "rls" rls --version
check "rustfmt" rustfmt --version
check "clippy" cargo-clippy --version
check "lldb" which lldb

# Check utilities
checkOSPackages "additional-os-packages" vim xtail software-properties-common
check "az" az --version
check "gh" gh --version
check "git-lfs" git-lfs --version
check "docker" docker --version
check "kubectl" kubectl version --client
check "helm" helm version

# Check expected shells
check "bash" bash --version
check "fish" fish --version
check "zsh" zsh --version

# Check expected commands
check "git-ed" [ ! -z "${GIT_EDITOR}" ]

# Check that we can run a puppeteer node app.
yarn
check "run-puppeteer" node puppeteer.js

# Report result
reportResults
