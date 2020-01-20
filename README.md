# Cashier&nbsp;🛒

Main module `Cashier`.

This is a minimal elixir application that implements the Kantox technical test
requirements:

* I used elixir instead of ruby, I hope this is okay.
* I used TDD in all of the implementation process, you can navigate through the
 commit history, you might laugh at some summaries.
* I used a github private repository, I wanted to keep this process low
 profile, I hope you understand.
* I did not use a DB.

![Elixi CI status](https://github.com/gilacost/kantox/workflows/Elixir%20CI/badge.svg)&nbsp;[![Coverage Status](https://coveralls.io/repos/github/gilacost/cashier/badge.svg?branch=master&t=3Anqcg)](https://coveralls.io/github/gilacost/cashier?branch=master)
## Installation&nbsp;🚀

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


## Hooks&nbsp;⚓️

To ensure a fast and secure development and to avoid mistakes, using hooks is
encouraged. If you want to do so, you can install them by running `make hooks`.
This will install [pre-commit](https://pre-commit.com/), which is a python
package; so you will need to have python already installed.

## Documentation&nbsp;🗃

[Ex doc](https://github.com/elixir-lang/ex_doc) has been added as a depenency in
order to generate documentation for the codebase. If you fancy review the
different modules and their function run `make docs`.

## Continuous Integration&nbsp;🔁

[Elixir CI](https://github.com/actions/setup-elixir) github action has been
set up. It runs the next tasks.

```yaml
- name: Check Formatting
  run: mix format --check-formatted

- name: Run Tests
  run: mix test

- name: Check Typespec
  run: mix dialyzer --halt-exit-status

- name: Run Coveralls
  run: mix coveralls.github
```
Here is the action [yaml](/.github/workflows/elixir.yml).

* Code coverage has also been set up with [coveralls](https://coveralls.io/github/gilacost/cashier).
