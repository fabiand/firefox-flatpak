
# http://flatpak.org/hello-world.html
# http://docs.flatpak.org/en/latest/

all: run-app

build-clean:
	rm -rf build/ repo/

clean: build-clean
	rm -rf sources/

firefox-nightly-latest-l10n-ssl.tar.gz:
	curl -L -o $@ "https://download.mozilla.org/?product=firefox-nightly-latest-l10n-ssl&os=linux64&lang=de"

sources: firefox-nightly-latest-l10n-ssl.tar.gz
	mkdir -p sources/files/lib sources/export
	tar xf $<
	mv firefox/ sources/files/bin
	cp /usr/lib64/libdbus-glib-1.so.* sources/files/lib
	cp metadata sources/

install-ifdo-runtime: sources
	flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak --user install flathub runtime/org.freedesktop.Platform/x86_64/1.6 || :

install-runtime: sources
	flatpak --user remote-add --if-not-exists --from gnome https://sdk.gnome.org/gnome.flatpakrepo
	flatpak --user install gnome runtime/org.gnome.Platform/x86_64/3.26 || :

repo: install-runtime
	flatpak build-export repo sources

install-app: repo
	flatpak --user remote-add --if-not-exists --no-gpg-verify local-firefox-repo repo 
	flatpak --user uninstall org.mozilla.Firefox ; flatpak --user install local-firefox-repo org.mozilla.Firefox || :

run-app: install-app
	flatpak run org.mozilla.Firefox --new-instance
