# WIP: This is readme driven development in progress. They tool may not yet do what the readme says.

**Status**: Working on it. Still missing essential features, so not using for my own development yet.

**High level roadmap: What we need to use this at work**
- [x] Environment scoping
- [x] Installing software dependencies
- Plugin support
  - [x] Very basic plugin support, be able to load /devbox/plugins
- Shell
  - [x] zsh support
- VM
  - [x] VM hostname "devbox"
  - [x] Local username instead of "vagrant" (though not in the example Vagrantfile, OSX specific, etc.)
- Plugins
  - [ ] Plugins for all things our projects depend upon
  - [x] System dependencies (like regular ones but will be available in all projects, like a custom build of vim)
- Caching
  - [x] Local caching
  - [ ] Project specific gem and database caching
  - [ ] Remote caching
- Configuration
  - [ ] Project configuration
  - [ ] Global configuration fallback (use for default values)
  - [ ] Autodetection for various dependencies
- Services
  - [ ] Generic service support (run any docker image, but no envs)

**High level roadmap: 1.0: public release**
- [ ] Full plugin support.
  - [x] Flatter directory structure plugins/python/python\_dependency.rb instead of plugins/python/dependencies/python\_dependency.rb.
- [ ] More consitent and very stable APIs. Follow semver from 1.0.
- [ ] "dev update" should probably require version instead of getting latest master.
- [ ] Service plugins for redis and postgres.
- [ ] Most things should work out of the box for a classic rails app.
- More things.

**Screenshot: installing dependencies and restoring from cache**

![](https://s3.amazonaws.com/f.cl.ly/items/3Z193D3v0J302x051d42/Screen%20Shot%202015-02-11%20at%2022.09.54.png)


## Actual readme below...

Deploying to heroku is just a few short commands, why isn't setting up a development box that easy?

devbox-tools is a toolset that run within a [Vagrant](https://www.vagrantup.com/) VM that attempts to **autodetect and install** the right things with a single command letting you get right to work instead of messing around with installations.

As an added benefit you can run **multiple projects within the same VM**, even if they depend on different versions of software or services. It's all scoped to each project (as far as possible).

When autodetection isn't possible, you can of course specify what you need installed.

All you need to get started is [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

### Services

This tool uses [docker](https://www.docker.com/) to run services like postgres or redis. It can run any docker image and you can find docker images on [docker hub](https://registry.hub.docker.com/) or even [make your own](https://docs.docker.com/reference/builder/).

Some of these services have special support in the form of service dependency plugins that among other things adds environment variables you can use to configure projects. As far as possible these variables use standard names like REDIS\_URL.

### Setting up your devbox repo

Set up your devbox repo.

    mkdir devbox && cd devbox && git clone https://github.com/joakimk/devbox-tools.git && devbox-tools/bootstrap

Then customize `Vagrantfile` and run:

    vagrant up

When inside the VM, add the plugins you need.

    dev plugins:list
    dev plugins:add https://github.com/joakimk/devbox-tools-ruby.git
    dev plugins:add https://github.com/joakimk/devbox-tools-postgres.git
    dev plugins:add https://github.com/joakimk/devbox-tools-redis.git
    dev plugins:add https://github.com/joakimk/devbox-tools-procfile.git

Plugins are added as git submodules in `plugins/`. You can add your own local plugins there as well.

### Running the VM on other computers

    git clone git@github.com:YOUR_ORG/devbox.git && cd devbox && vagrant up

### Daily workflow

Example for a ruby project.

    vagrant up
    vagrant ssh

    # Inside the VM
    cd /path/to/project

    dev
    >> Checking dependency ruby: 2.2.0 installed (autodetected).
    >> Checking dependency bundler: 1.7.12 installed (devbox-tools default).
    >> Checking dependency postgres: postgres:9.2 (configured in project).
    >> Starting services.... done.
    >> Development environment ready.

    rake spec
    ...

### Less frequently used commands

Stopping services

    cd /path/to/project
    dev stop

Listing running services:

    cd /path/to/project
    dev ps

Caching to make installs quicker:

    cd /path/to/project
    dev cache
    >> Checking cache for ruby... none
    >> Checking cache for bundler... 60 mb on disk
    >> Checking cache for postgres... 1500 mb on disk
    >> Do you want to cache postgres? (it's 1500mb) y/n: n
    >> Caching bundler... done.
    >> Caching complete.

Restoring caches:

    cd /path/to/project
    dev restore
    >> Checking cache for ruby... none
    >> Checking cache for bundler... 45mb compressed
    >> Checking cache for postgres... 1000mb compressed
    >> Do you want to download cache for postgres? (it's 1000mb) y/n: n
    >> Restoring bundler... done.
    >> Restoring complete.

### Gotchas to be aware of...

devbox-tools will change envs when navigating between directories in order to do it's job. It does it's best not to clear away anything you may have set, but may still do so, so keep that in mind. PATH is handled extra carefully, so it should still work like you expect it to.

Any environment variables the dependencies do not need to set are not touched by devbox-tools.

So in practice this means that devbox-tools may change envs like GEM\_PATH but will leave EDITOR alone and handle PATH gracefully.

### Offline and/or slow connection support

Setting OFFLINE=true will make devbox-tools attempt to not use an internet connection by trying to use local files and exiting early if that isn't possible.

    # The ruby version has been updated in the project, but you don't have it locally
    # and you're on a train with a bad connection, so you opt for using OFFLINE=true...

    OFFLINE=true dev
    >> Checking dependency ruby: 2.2.0 unavailable (autodetected).
    >> Development environment could not be setup.

    # You revert to an older ruby version in your repo (e.g. in Gemfile or .rvmrc)...

    OFFLINE=true dev
    >> Checking dependency ruby: 2.1.0 installed (autodetected).
    >> Checking dependency postgres: postgres:9.2 (configured in project).
    >> Starting services.... done.
    >> Development environment ready.

    # You're ready to go

### Developing plugins

Plugins are structured like this:

    plugins/devbox-tools-foo/
      commands/
        foo_command.rb
      caches/
        foo_cache.rb
      dependencies/
        foo_dependency.rb

Command files are expected to contain... TODO

Creating a plugin:

    dev plugin:create plugins/devbox-tools-foo
    # add things to the plugin and run dev commands
    # publish somewhere and send me a link

### Developing devbox-tools

Change things, run tests, and send a pull request.

But before you do, consider making the change into a plugin. Most of devbox-tools is implemented using it's own plugin system. See the above plugin section.

    ./test up
    ./test test
    ./test ssh # optional, to debug or run tests quicker with 'dev test'
    ./test destroy

### What is mruby and...

[mruby](http://www.mruby.org/) is a lightweight implementation of the Ruby language and it's the runtime for devbox-tools. devbox-tools uses [mruby](http://www.mruby.org/) because:

* It compiles to a stand alone binary. This avoids environment collisions with other ruby installs.
* Keeps this tool simple. You can always shell out to more complex tools.
* It's fun to try out new things.

The mruby build configuration (and the "mrbgems" we build into it) is listed in [support/mruby\_build\_config.rb](support/mruby_build_config.rb) and the version is set by [support/install\_dependencies](support/install_dependencies).

### Credits and license

By [Joakim Kolsjö](https://github.com/joakimk) under the MIT license:

>  Copyright © 2015 Joakim Kolsjö
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
