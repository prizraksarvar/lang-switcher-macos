all: lang-switcher

lang-switcher: lang-switcher.m
	gcc -o $@ -Wall $< -framework Carbon -framework Foundation -framework AppKit
