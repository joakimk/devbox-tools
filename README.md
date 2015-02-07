# WIP: This is readme driven development in progress. They tool may not yet do what the readme says.

A tool for vagrant boxes that simplify management of development dependencies.

The main idea is a tool will autodetect and install the right things letting you get right to work instead of messing around with installations. **It's meant to make development box setup as easy as pushing to heroku** and it's not bound to any specific programming language or platform.

As an added benefit you can run multiple projects within the same VM, even if they depend on different versions of services like postgres. It's all scoped to each project (as far as possible).

### Setting up your devbox repo

Set up your devbox repo.

    mkdir devbox && cd devbox && git clone git@github.com:joakimk/devbox-tools.git && devbox-tools/bootstrap

Then customize `Vagrantfile` and run:

    vagrant up

When inside the VM, add the plugins you need.

    dev plugins:list
    dev plugins:add git@github.com:joakimk/devbox-tools-ruby.git
    dev plugins:add git@github.com:joakimk/devbox-tools-postgres.git
    dev plugins:add git@github.com:joakimk/devbox-tools-redis.git

Plugins are added as git submodules in `plugins/plugin-name`. You can add your own local plugins there as well.

### Running the VM on other computers

    git clone git@github.com:YOUR\_ORG/devbox.git && cd devbox && vagrant up

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
    >> Starting services.... done
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
    >> Caching bundler... done
    >> Caching complete.

Restoring caches:

    cd /path/to/project
    dev restore
    >> Checking cache for ruby... none
    >> Checking cache for bundler... 45mb compressed
    >> Checking cache for postgres... 1000mb compressed
    >> Do you want to download cache for postgres? (it's 1000mb) y/n: n
    >> Restoring bundler... done
    >> Restoring complete.

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

Change things, run tests, send pull request.

    ./test up
    ./test integration
    ./test unit
    ./test ssh # optional, to debug
    ./test destroy

### What is mruby and...

[mruby](http://www.mruby.org/) is a lightweight implementation of the Ruby language and it's the runtime for devbox-tools. devbox-tools uses [mruby](http://www.mruby.org/) because:

* It compiles to a stand alone binary. This avoids environment collisions with other ruby installs.
* Keeps this tool simple (you can always shell out to more complex tools).
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
