
build:
	jpm build

build-app:
	jpm --local build

run:
	jpm -l janet -d main.janet


clean:
	rm -rf build


