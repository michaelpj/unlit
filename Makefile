test: install test/ghcunlit
	runhaskell test/TestUnlit.hs

test/ghcunlit: test/ghcunlit.c
	gcc -O2 -o ghcunlit ghcunlit.c

dist: src/Main.hs src/Unlit/Text.lhs src/Unlit/String.hs
	cabal sdist

build: src/Main.hs src/Unlit/Text.lhs src/Unlit/String.hs
	cabal build

install: src/Main.hs src/Unlit/Text.lhs src/Unlit/String.hs
	cabal install

src/Unlit/String.hs: src/Unlit/Text.lhs Makefile
	cat src/Unlit/Text.lhs		                       \
	| unlit				                       \
	| gsed '7d;12,14d'  		                       \
	| gsed 's/Text/String/g;s/unpack/id/g;s/pack/id/g'     \
	| gsed '7i import Prelude hiding \(all, or\)'          \
	| gsed '8i import Data.List \(isPrefixOf, isInfixOf\)' \
	> src/Unlit/String.hs


.phony: test dist build install