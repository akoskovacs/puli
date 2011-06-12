target:
	@echo "Nothing to do. Just run 'make install' as root to install."

samples: samples/
	$(MAKE) -C samples/

syntax:
	mkdir ~/.vim/syntax
	mkdir ~/.vim/ftdetect
	cp syntax/pu.vim ~/.vim/sytax/
	cp syntax/puli.vim ~/.vim/ftdetect/

help:
	@echo "make install - Install the pulic complier to the /usr/bin/"
	@echo "make remove - Remove the pulic complier from the /usr/bin/"
	@echo "make syntax - Install the vim syntax files for the user"
install:
	cp pulic /usr/bin/pulic

remove:	
	rm /usr/bin/pulic
