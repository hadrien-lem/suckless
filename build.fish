#!/bin/fish

# Install directory path
set DIR "/opt/"
# Git directory path
set GDIR (dirname (status -f))
[ $GDIR = . ] && set GDIR $PWD

function main
	# Cleanup dir
	echo -e "\n===== $argv - CLEANUP DIR ====="
	if test -d $DIR$argv
		make -C $DIR$argv uninstall
		rm -rf $DIR$argv
	end
	# Clone
	echo -e "\n===== $argv - CLONING ====="
	mkdir -p $DIR$argv
	git clone https://git.suckless.org/$argv $DIR$argv
	# Patches
	echo -e "\n===== $argv - PATCHING ====="
	for file in $GDIR/$argv/patches/*
		echo $file
		patch -p1 -d $DIR$argv < $file
	end
	# Config file
	[ -f $GDIR/$argv/config/config.h ] && cp $GDIR/$argv/config/config.h $DIR$argv/ && echo "Config file copied"
	# Install
	echo -e "\n===== $argv - INSTALLATION ====="
	make -C $DIR$argv install clean
end

if test -z $argv # If an arg is given when the script is called, install the given app
	main $argv
else # Else install everything
	for i in "dmenu" "dwm" "st"
		main $i
	end
end
