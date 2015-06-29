.PHONY: docs build test coverage build_rpm

ifndef VTENV_OPTS
VTENV_OPTS = "--no-site-packages"
endif

build:
	virtualenv $(VTENV_OPTS) .
	bin/python setup.py develop

test:	bin/nosetests
	bin/nosetests -x vaurien

coverage: bin/coverage
	bin/nosetests --with-coverage --cover-html --cover-html-dir=html --cover-package=vaurien

docs: bin/sphinx-build
	SPHINXBUILD=../bin/sphinx-build $(MAKE) -C docs html $^

bin/sphinx-build: bin/python
	bin/pip install sphinx
	bin/pip install coverage

bin/nosetests: bin/python
	bin/pip install nose
	bin/pip install webtest

bin/coverage: bin/python
	bin/pip install coverage

clean:
	@find . -iname '*.pyc' -delete
	@find . -iname '*.pyo' -delete
	@find . -iname '*~' -delete
	@find . -iname '*.swp' -delete
	@find . -iname '__pycache__' -delete

cleaneggs:
	@find . -name '*.egg' -print0|xargs -0 rm -rf --
	@rm -rf .eggs/
