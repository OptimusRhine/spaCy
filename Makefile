SHELL := /bin/bash
sha = $(shell "git" "rev-parse" "--short" "HEAD")

dist/spacy.pex : spacy/*.pyx spacy/*.pxd spacy/*/*.pyx spacy/*/*.pxd
	python3.6 -m venv env3.6
	source env3.6/bin/activate
	env3.6/bin/pip install wheel
	env3.6/bin/pip install -r requirements.txt --no-cache-dir --no-binary :all:
	env3.6/bin/python setup.py build_ext --inplace
	env3.6/bin/python setup.py sdist
	env3.6/bin/python setup.py bdist_wheel
	env3.6/bin/python -m pip install pex
	env3.6/bin/pex dist/*.whl -e spacy -o dist/spacy-$(sha).pex
	cp dist/spacy-$(sha).pex dist/spacy.pex
	chmod a+rx dist/spacy.pex

.PHONY : clean

clean : setup.py
	source env3.6/bin/activate
	rm -rf dist/*
	python setup.py clean --all
