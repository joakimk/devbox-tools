**Status**: Not working on this project. Might build separate tools instead, like <https://github.com/joakimk/docker_services>.

# WIP: This is readme driven development in progress. They tool may not yet do what the readme says.

devbox-tools is a toolset for installing and updating development dependencies within [Vagrant](https://www.vagrantup.com/) VMs with as little configuration as possible.

The idea is that you log in to your VM, enter a project, and type "dev" to install everything the project needs. The dependencies and their versions can often be autodetected but can also be configured and versioned within each project.

No chef of puppet needed. The project defines its environment instead of the other way around.

### Get started

Set up your devbox repo:

    mkdir devbox && cd devbox && git clone https://github.com/joakimk/devbox-tools.git && devbox-tools/bootstrap

Then customize `Vagrantfile` and run: (this step requires [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/)).

    vagrant up
    vagrant ssh

When logged in:

    cd path/to/your/project
    dev

### Services

This tool uses [docker](https://www.docker.com/) to run services like postgres or redis. It can run many of the docker images you can find on [docker hub](https://registry.hub.docker.com/) and you can also [make your own](https://docs.docker.com/reference/builder/).

To be supported a docker image needs to export one network port [like this](https://github.com/docker-library/postgres/blob/8f80834e934b7deaccabb7bf81876190d72800f8/9.4/Dockerfile#L49) and optionally declare one or more [volumes](https://github.com/docker-library/postgres/blob/8f80834e934b7deaccabb7bf81876190d72800f8/9.4/Dockerfile#L43) that will be persisted when the docker container is not running. It also needs to run a [process](https://github.com/docker-library/postgres/blob/8f80834e934b7deaccabb7bf81876190d72800f8/9.4/Dockerfile#L50) by default. Luckly, this is what most docker images containing services like postgres, mongodb, mysql, redis, memcached, etc. already do.

Every service adds an environment variable for the network port which you can use to configure projects. If you have a service named "redis" then you will have an environment variable named "REDIS_PORT".

Some of these services have specific plugins that adds even more environment variables (e.g. REDIS_URL, ..).

### Plugins

Plugins are the way you extend devbox-tools. They let you add support for new dependencies (ex: mongodb, java, erlang, ...) by specifying how they are installed, how they affect the environment variables, how to start or stop them and so on.

You can make a local plugin, use plugins other people have made or publish your own.

You can find out more on plugins further down in this readme.

### Many projects in the same VM

One of the main goals with this tool is to be able to develop many projects within the same VM. This might seem a bit odd given that vagrant is meant to make it easy to have one VM for each project. But what if you don't need that much isolation for every project?

We've found being able to run multiple projects in one VM very useful at [auctionet](http://dev.auctionet.com/). This allowed us to reduce about 5 VMs down to one while still having good enough isolation between projects. Switching between projects is now much more conventient.

### Reliability

Having a stable development environment is just as important as having all the latest tools. This tool is versioned using [semver](http://semver.org/) and is [well tested](test/).

### Running the VM on other computers

    git clone git@github.com:YOUR_ORG/devbox.git && cd devbox && git submodule update --init && vagrant up && vagrant ssh

### Less frequently used commands

Stopping services

    cd /path/to/project
    dev stop

### Gotchas to be aware of...

#### Environment

devbox-tools will change envs when navigating between directories in order to do it's job. It does it's best not to clear away anything you may have set, but may still do, so keep that in mind. PATH is handled extra carefully, so it should still work like you expect it to.

Any environment variables the dependencies do not need to set are not touched by devbox-tools.

So in practice this means that devbox-tools may change envs like GEM\_PATH but will leave EDITOR alone and handle PATH gracefully.

#### Optimizations

devbox-tools will cache some information, like ports for docker services, for later use. It does this mostly so that changing envs when navigating the filesystem remains fast enough to not be noticeable (below ~200ms).

Normally this should not be a problem, but if something behaves a bit odd, then try "dev stop" and "dev" (and if you like: fix the bug or report it).

### Developing plugins

See todo list below :)

### Developing devbox-tools

Change things, run tests, and send a pull request.

But before you do, consider making the change into a plugin. Most of devbox-tools is implemented using it's own plugin system. See the above plugin section.

    ./testvm up
    ./testvm test
    ./testvm ssh # optional, to debug or run tests quicker with 'dev test'
    ./testvm destroy

### What is mruby and...

**Note: There is a ruby22 branch where I'm changing over to the regular ruby version**

[mruby](http://www.mruby.org/) is a lightweight implementation of the Ruby language and it's the runtime for devbox-tools. devbox-tools uses [mruby](http://www.mruby.org/) because:

* It compiles to a stand alone binary. This avoids environment collisions with other ruby installs.
* Keeps this tool simple. You can always shell out to more complex tools.
* It's fun to try out new things.

The mruby build configuration (and the "mrbgems" we build into it) is listed in [support/mruby\_build\_config.rb](support/mruby_build_config.rb) and the version is set by [support/install\_dependencies](support/install_dependencies).

### Status

**Screenshot: communicating with a docker service**

![](https://pbs.twimg.com/media/B-Jo06oIgAAkkZE.png)

**Screenshot: configuration**

![](https://s3.amazonaws.com/f.cl.ly/items/210D391o3w0S0z2A2a3W/Screen%20Shot%202015-02-16%20at%2022.14.31.png)

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
- Caching
  - [x] Local caching
- Configuration
  - [x] Project configuration
  - [x] Global configuration fallback (use for default values)
- Plugins
  - [x] System dependencies (like regular ones but will be available in all projects, like a custom build of vim)
- Services
  - [x] Generic service support

**High level roadmap: What we need to replace our current internal tools (and beta version)**
- Caching
  - [ ] Project specific gem and database caching (and docs)
  - [ ] Remote caching (and docs)
- Configuration
  - [ ] Autodetection for various dependencies
- Plugins
  - [ ] Plugins for all things our projects depend upon
- OS
  - [x] Rebase on ubuntu 14.04 so we don't need to change the default base os for a long time
- VM
  - [x] Import all refinements from the internal auctionet devbox Vagrantfile (it's easier to try things out in a real environment first and import it here later)
    - Rename support/Vagrantfile to support/Vagrantfile.template (or .erb? and use templating where needed)
- Cleanup
  - [x] Remove offline support for now (seems to add lots of complexity and have little value)
  - [ ] See if replacing mruby with regular ruby is practical. Would simplify a few things.
  - [ ] Make all tests pass again

**High level roadmap: 1.0: public release**

Overall goal: Support most ruby and elixir apps with as little configuration as possible.

- Docs
  - [ ] How configuration works. Conventions around version and checksum. How to use free form options.
  - [ ] Plugin development
- CLI
  - [ ] Prefix tools commands. "dev tools:update", etc.
  - [ ] "dev update" should probably require version instead of getting latest master.
- Services
  - [ ] Service plugins for redis and postgres.
- Configuration
  - [ ] Be able to have config on more levels (devbox root, home?)
  - [ ] Be able to disable defaults
- More things
  - [ ] Full plugin support.
    - [x] Flatter directory structure plugins/python/python\_dependency.rb instead of plugins/python/dependencies/python\_dependency.rb.
  - [ ] More consitent and very stable APIs. Follow semver from 1.0.
  - [ ] Most things should work out of the box for a classic rails app.
  - [ ] TODO: this list is far from complete

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
