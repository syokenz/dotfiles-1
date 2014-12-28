DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: help

test: deploy
	@$(foreach val, $(DOTFILES_FILES), bash ./test.sh $(val);)

help:
	@echo "make list             #=> list the files"
	@echo "make deploy           #=> create symlink"
	@echo "make update           #=> fetch changes"
	@echo "make install          #=> setup environment"
	@echo "make clean            #=> remove the files"

list:
	@$(foreach val, $(DOTFILES_FILES), ls -dF $(val);)

deploy:
	@echo 'Start deploy dotfiles current directory.'
	@echo 'If this is "dotdir", curretly it is ignored and copy your hand.'
	@echo ''
	@$(foreach var, $(DOTFILES_FILES), ln -sfnv $(abspath $(var)) $(HOME)/$(val);)

update:
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

install:
	@$(foreach val, $(wildcard ./etc/init/*.sh), bash $(val);)

clean:
	@echo 'Remove dot files in your home directory...'
	@-$(foreach var, $(DOTFILES_FILES), rm -vrf $(HOME)/$(var);)
	-rm -rf $(DOTFILES_DIR)
