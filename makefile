.PHONY: build
bulid:
	@/usr/bin/rm -rf bin
	@zip -9 -r topdownshooter.love .
	@mkdir bin
	@cat /usr/bin/love topdownshooter.love > bin/topdownshooter
	@/usr/bin/rm -rf topdownshooter.love
	@chmod +x bin/topdownshooter
