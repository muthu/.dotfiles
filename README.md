# Dotfiles
This is my personal repo for dotfiles I use.

## The idea
I need a lean way to store, backup and version dotfiles on my machines.  

This is the orginal article I followed: [Best way to store dotfiles](https://www.atlassian.com/git/tutorials/dotfiles).  
I adapted it a little bit to better match my taste about command names and folders.

## How it works
The technique consists in storing dotfiles in a _Git bare_ repository, but in a customized `$HOME/.dotfiles` folder instead of the usual `.git` folder.  
Then, using a special Git alias command, I'm able to add and commit files I want to track in the repo, and pushing them to a remote.

## Repository structure
I use a different Git branch for every machine; on `master` branch there are only common file I use as a template.

### Master branch
Contains:
* common ignore file
* common shell aliases I always use
* other common files and configurations I like to have on all my machines

## Starting from scratch
If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:

~~~ bash
1) git init --bare $HOME/.dotfiles
2) alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
3) dotfiles config --local status.showUntrackedFiles no
4) dotfiles config --local core.excludesFile=.dotfilesignore
5) echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.config/zsh/.zsh_aliases
~~~

1. The first line creates a folder `~/.dotfiles` which is a Git bare repository that will track your files.
2. Then we create a new command `dotfiles` that is nothing else than a customized alias to `git` command, configured to work only with your `.dotfiles` repo. We will use it instead of the regular `git` command when we want to interact with our configuration repository.
3. We set the flag `status.showUntrackedFiles no` - local to the repository - to hide files we are not explicitly tracking yet. This is so that when you type `dotfiles status` and other commands later, files you are not interested in tracking will not show up as untracked.
4. To make things more coherent, I use a custom `.dotfilesignore` as Git ignore file instead of the common `.gitignore` one. This way it's easier to remember where to write your exclusions.
5. Add the `dotfiles` alias definition by hand or use the the command provided for convenience. 

As a Zsh user, in these example I worked with `.zshrc` and `.zsh_aliases` files; feel free to substitute them with `.bashrc` and `.bash_aliases` if you plan to use Bash as your preferred shell: they works the same way.

After you've executed the setup, any file within the `$HOME` folder can be versioned with normal Git commands, replacing `git` with your newly created `dotfiles` alias:

~~~ bash
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add vimrc"
dotfiles add .bashrc
dotfiles commit -m "Add bashrc"
dotfiles push
~~~

## Install your dotfiles onto a new system
Prior to the installation make certain you have committed the `dotfiles` alias as in step 5.

Then be sure your repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:
~~~ bash
echo ".dotfiles" >> .dotfilesignore
~~~

Now clone your Dotfiles repository into a bare repository in the `.dotfiles` dot folder of your `$HOME`:
~~~ bash
git clone --bare --recurse-submodules <git-repo-url> $HOME/.dotfiles
~~~

Define the alias in the current shell scope:
~~~ bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
~~~

Checkout the actual content from the bare repository to your `$HOME`:
~~~ bash
dotfiles checkout master
~~~

The step above might fail with a message like this:
~~~ bash
error: The following untracked working tree files would be overwritten by checkout:
    .zshrc

Please move or remove them before you can switch branches.

Aborting
~~~

This is because your `$HOME` folder might already have some stock configuration files which would be overwritten by Git (like `.zshrc` in my case). The solution is simple: back up the files if you care about them, remove them if you don't care. Nicola provided us with a possible rough shortcut to move all the offending files automatically to a backup folder:
~~~ bash
mkdir -p .dotfiles-backup && \
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .dotfiles-backup/{}
~~~

Re-run the check out if you had problems:
~~~ bash
dotfiles checkout master
~~~

Set the flag `showUntrackedFiles` to `no` on this specific (local) repository:
~~~ bash
dotfiles config --local status.showUntrackedFiles no
~~~

Set the flag `core.excludesFile` to `.dotfilesignore` on this specific (local) repository:
~~~ bash
dotfiles config --local core.excludesFile=.dotfilesignore
~~~ 

Now you have two options: create a new branch for the brand new machine you are installing, or checkout an existing branch and use it.

### Create a new branch
~~~ bash
dotfiles checkout -b <my-new-machine-branch-name>
~~~
At this point you can start customizing your dotfiles and the commit them to this new branch. You can also diff your files form other branches and _cherry-pick_ stuff you like form other branches.

### Checkout an existing branch
In the previous steps we checked out `master` branch, that in my personal dotfiles repo contains only shared file and configurations I like to have on all my machines (my machines are not all 100% equal).  
But you can commit all the dotfiles you like in `master` branch and always use it, or checkout an existing (other machine) into the new one if you like: simply switch branch like this:
~~~ bash
dotfiles checkout <existing-machine-branch-name>
~~~

Of course, you will have some conflicts like we mentioned before: handle them with the provided script or delete current dotfiles you planned to override.

## Summary
You're done, from now on you can now type `dotfiles` commands to add and update your dotfiles:

~~~ bash
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add vimrc"
dotfiles add .bashrc
dotfiles commit -m "Add bashrc"
dotfiles push
~~~

