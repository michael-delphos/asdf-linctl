<div align="center">

# asdf-linctl [![Build](https://github.com/michael-delphos/asdf-linctl/actions/workflows/build.yml/badge.svg)](https://github.com/michael-delphos/asdf-linctl/actions/workflows/build.yml) [![Lint](https://github.com/michael-delphos/asdf-linctl/actions/workflows/lint.yml/badge.svg)](https://github.com/michael-delphos/asdf-linctl/actions/workflows/lint.yml)

[linctl](https://github.com/dorkitude/linctl) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- **[Go](https://golang.org/)** - Required to build linctl from source. Install via your package manager or asdf (`asdf plugin add golang && asdf install golang latest`).

# Install

Plugin:

```shell
asdf plugin add linctl
# or
asdf plugin add linctl https://github.com/michael-delphos/asdf-linctl.git
```

linctl:

```shell
# Show all installable versions
asdf list-all linctl

# Install specific version
asdf install linctl latest

# Set a version globally (on your ~/.tool-versions file)
asdf global linctl latest

# Now linctl commands are available
linctl --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/michael-delphos/asdf-linctl/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [michael-delphos](https://github.com/michael-delphos/)
