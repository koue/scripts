#!/bin/sh
#
# Depends on:
#	py27-bear
#	llvm60
#
# Note:
# 	llvm60 is needed because the default compiler is statically linked and
#	compile_commands.json file will be empty
#
#	https://github.com/rizsotto/Bear/issues/212
#
bear make CC=/usr/local/bin/clang60
/usr/local/llvm60/share/clang/run-clang-tidy.py \
	-checks="*" \
	-clang-tidy-binary /usr/local/bin/clang-tidy60 > tidy.txt
#	-clang-apply-replacements-binary /usr/local/bin/clang-apply-replacements60 \
#	-fix > tidy.txt
cat tidy.txt | grep warning: | grep -oE '[^ ]+$' | sort | uniq -c
