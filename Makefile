target:
	@echo "Nothing to do. Just run 'make install' as root to install."

examples: samples/
	$(MAKE) -C samples/

vim:
	mkdir -p ~/.vim/syntax
	mkdir -p ~/.vim/ftdetect
	cp syntax/pu.vim ~/.vim/sytax
	cp syntax/puli.vim ~/.vim/ftdetect
	@echo "You must enable plugins and syntax highlighting in your .vimrc"

help:
	@echo "make install - Install the pulic complier to the /usr/bin/"
	@echo "make remove - Remove the pulic complier from the /usr/bin/"
	@echo "make vim - Install the vim syntax files for the user"
	@echo "make examples - Complies the exmaple programs in the /samples directory"

install:
	cp pulic /usr/bin/pulic

remove:	
	rm /usr/bin/pulic
