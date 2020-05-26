COQMAKEFILE ?= Makefile.coq

all: $(COQMAKEFILE)
	$(MAKE) -f $^ $@

test: all
	$(MAKE) -C example -B

install: $(COQMAKEFILE) all
	$(MAKE) -f $^ $@

uninstall: $(COQMAKEFILE)
	$(MAKE) -f $^ $@

clean: $(COQMAKEFILE)
	$(MAKE) -f $^ cleanall
	$(RM) $^ $^.conf

$(COQMAKEFILE): _CoqProject
	$(COQBIN)coq_makefile -f $^ -o $@
