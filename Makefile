.PHONY: style check_code_quality

export PYTHONPATH = .
check_dirs := roboflow

style:
	ruff format $(check_dirs)
	ruff check $(check_dirs) --fix

check_code_quality:
	ruff format $(check_dirs) --check
	ruff check $(check_dirs)
	# stop the build if there are Python syntax errors or undefined names
	flake8 $(check_dirs) --count --select=E9,F63,F7,F82 --show-source --statistics
	# exit-zero treats all errors as warnings. E203 for black, E501 for docstring, W503 for line breaks before logical operators
	flake8 $(check_dirs) --count --max-line-length=120 --exit-zero  --ignore=D --extend-ignore=E203,E501,W503  --statistics

publish:
	python setup.py sdist bdist_wheel
	twine check dist/*
	twine upload dist/* -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --verbose
