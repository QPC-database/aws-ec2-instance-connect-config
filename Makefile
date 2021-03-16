VERSION_FILE=./VERSION
pkgver=$(shell cat $(VERSION_FILE))
version = $(firstword $(subst -, ,$(pkgver)))
release = $(lastword $(subst -, ,$(pkgver)))

default: clean ;

deb:
	./bin/make_deb.sh $(version) $(release)

rpm:
	./bin/make_rpm.sh $(version) $(release)

docker-build-rpm:
	mkdir -p out
	docker build -f docker/generic/Dockerfile . -t eic-rpm-builder -q
	docker run -i --mount type=bind,source="$(shell pwd)/out",target=/out eic-rpm-builder

docker-build-deb:
	mkdir -p out
	docker build -f docker/ubuntu/Dockerfile . -t eic-deb-builder -q
	docker run -i --mount type=bind,source="$(shell pwd)/out",target=/out eic-deb-builder

docker-build:: docker-build-rpm docker-build-deb

clean:
	$(shell rm -rf ec2-instance-connect*)
	$(shell rm -rf ./rpmbuild/SOURCES)
	$(shell rm -rf ./deb-src)
	$(shell rm -rf ./srpm_results)
	$(shell rm -rf ./rpm_results)
	$(shell rm -rf ./out)
