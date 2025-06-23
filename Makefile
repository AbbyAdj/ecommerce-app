PROJECT_NAME = ecommerce-app
PYTHON_INTERPRETER = python
WD=$(shell pwd)
PYTHONPATH=${WD}
SHELL := /bin/bash
PIP:=pip

# Set this to your existing venv folder (e.g., .venv used by PyCharm)
VENV_DIR ?= .venv
ACTIVATE_ENV := source ${VENV_DIR}/bin/activate


# Execute python related functionalities from within the project's environment
define execute_in_env
	$(ACTIVATE_ENV) && $1
endef


# Create python interpreter environment.
create-environment:
	@echo ">>> Checking for existing virtual environment at $(VENV_DIR)..."
	@if [ -d "$(VENV_DIR)" ]; then \
		echo ">>> Virtual environment already exists at $(VENV_DIR)"; \
	else \
		echo ">>> Creating new virtual environment in $(VENV_DIR)..."; \
		$(PYTHON_INTERPRETER) -m venv $(VENV_DIR); \
	fi

## Build the environment requirements
requirements: create-environment
	$(call execute_in_env, $(PIP) install -r ./requirements.txt)
	$(call execute_in_env, $(PIP) install -r ./requirements-dev.txt)

################################################################################################################
# Set Up
# Install bandit
bandit:
	$(call execute_in_env, $(PIP) install bandit)

## Install coverage
coverage:
	$(call execute_in_env, $(PIP) install coverage)

# Set up dev requirements (bandit & coverage)
checks-setup: bandit coverage

# Build / Run

## Run the security test (bandit)
security-test:
	$(call execute_in_env, bandit -r ${WD}/*.py || true)

## Run the black code check
run-black:
	$(call execute_in_env, black -v ${WD})

run-terraform-formatter:
	terraform fmt -recursive

## Run the tests
run-tests:
	$(call execute_in_env, PYTHONPATH=${PYTHONPATH} pytest -vvrP || true)

## Run the coverage check
check-coverage:
	$(call execute_in_env, PYTHONPATH=${PYTHONPATH} coverage run -m pytest && coverage report -m || true)

## Run all checks
run-checks: security-test run-black run-tests check-coverage

run-all : requirements checks-setup run-checks

