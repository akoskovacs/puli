target:
	@echo "Nothing to do. Just run 'make install' as root to install."

samples:
	$(MAKE) -C samples/

install:
	cp pulic /usr/bin/pulic

remove:	
	rm /usr/bin/pulic
