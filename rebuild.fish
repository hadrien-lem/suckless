#!/bin/fish
#
# Clone the software and apply a commit after each patch
# The purpose is to easily rebuild the patches

# Install directory path
set DIR "./draft/"
# Git directory path
set GDIR (dirname (status -f))
[ $GDIR = . ] && set GDIR $PWD

function main
	# Cleanup dir
	echo -e "\n===== CLEANING DIR ====="
	if test -d $DIR$argv
		rm -rf $DIR$argv
	end
	# Clone
	echo -e "\n===== CLONING ====="
	mkdir -p $DIR$argv
	git clone https://git.suckless.org/$argv $DIR$argv
	# Patches
	echo -e "\n===== PATCHING ====="
	for file in $GDIR/$argv/patches/*
		set name (echo $file | sed -e 's/.*[0-9]-\(.*\)\.patch/\1/')
		echo "----- $name -----"
		patch -p1 -d $DIR$argv < $file
		git -C $DIR$argv commit -a -m "$name"
	end
end

main $argv
#for i in "dwm"
#	main $i
#end

# To get the patches :
# git format-patch origin/master -o ./patches/
