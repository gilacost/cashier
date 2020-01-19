![](https://github.com/gilacost/kantox/workflows/.github/workflows/pre-commit.yml/badge.svg)

# Cashier  🛒

This is a minimal elixir application that implements the Kantox technical test
requirements:

* I used elixir instead of ruby, I hope this is okay.
* I used TDD in all of the implementation process, you can navigate through the
 commit history, you might laugh at some summaries.
* I used a github private repository, I wanted to keep this process low
 profile, I hope you understand.
* I did not use a DB.

## Installation  🚀

So that the teams local environments can be as similar as possible and all of
the same versions of each package are used, I have used [asdf](https://github.com/asdf-vm/asdf). If you don't have it already installed you can just run `make asdf`
and `make install`.

By doing this you will be running:

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.2

asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git
```

```bash
asdf install
```

These bash commands have been redirected to `/dev/null`, so don't worry if you have
previously installed any of the packages.

If you don't have asdf in your dot-files, add it like this:

```bash
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
```

If you use zsh, you  should add it to your `.zshrc` file.


### Hooks  ⚓️

To ensure a fast and secure development and to avoid mistakes, using hooks is
encouraged. If you want to do so, you can install them by running `make hooks`.
This will install [pre-commit](https://pre-commit.com/), which is a python
package; so you will need to have python already installed.
