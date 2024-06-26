# [make all] compiles this benchmark.
# Using --profile release ensures that debug assertions are turned off.

.PHONY: all
all:
	@ dune build --profile release

.PHONY: clean
clean:
	git clean -fX

P4 := _build/4.14.0/main.exe
P5 := _build/5.1.0/main.exe

.PHONY: test
test: all
	hyperfine -N --min-runs 30 --warmup 10 \
	  "$(P4)" -n "4.14" \
	  "$(P5)" -n "5.1" \
	  "$(P4) --unsafe" -n "4.14 unsafe"\
	  "$(P5) --unsafe" -n "5.1 unsafe"\
	  "$(P4) --unrolled" -n "4.14 unrolled" \
	  "$(P5) --unrolled" -n "5.1 unrolled" \
	  "$(P4) --unsafe --unrolled" -n "4.14 unsafe, unrolled" \
	  "$(P5) --unsafe --unrolled" -n "5.1 unsafe, unrolled" \

.PHONY: once
once: all
	@ echo "# On 4.14"
	@ echo
	@ echo "## Running safe:"
	@ echo
	@ $(P4)
	@ echo
	@ echo "## Running unsafe:"
	@ echo
	@ $(P4) --unsafe
	@ echo
	@ echo "## Running unrolled:"
	@ echo
	@ $(P4) --unrolled
	@ echo
	@ echo "## Running unsafe unrolled:"
	@ echo
	@ $(P4) --unsafe --unrolled
	@echo
	@ echo "# On 5.1"
	@ echo
	@ echo "## Running safe:"
	@ echo
	@ $(P5)
	@ echo
	@ echo "## Running unsafe:"
	@ echo
	@ $(P5) --unsafe
	@ echo
	@ echo "## Running unrolled:"
	@ echo
	@ $(P5) --unrolled
	@ echo
	@ echo "## Running unsafe unrolled:"
	@ echo
	@ $(P5) --unsafe --unrolled

.PHONY: assembly
assembly:
	@ dune clean
	@ make all
	@ open -a /Applications/Emacs.app _build/default/.main.eobjs/native/dune__exe__Main.s
