#!/bin/bash
#
#This is to learn error handling
#THere is no try and catch so we use if else statements with exit 1




create_directory()
{
	mkdir demo

}


if ! create_directory; then
	echo "The code is being exited as the dirctory already exists"
	exit 1
fi


echo "This should not print as the code is interrupted"


