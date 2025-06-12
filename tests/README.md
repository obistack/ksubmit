# Tests for ksub

This directory contains tests for the ksub package. The tests are organized to mirror the structure of the ksub package.

## Structure

```
tests/
├── cli/            # Tests for ksub.cli
├── config/         # Tests for ksub.config
├── examples/       # Tests for ksub.examples
├── kubernetes/     # Tests for ksub.kubernetes
├── parsers/        # Tests for ksub.parsers
└── utils/          # Tests for ksub.utils
```

## Running Tests

To run all tests:

```bash
python -m pytest
```

To run tests for a specific module:

```bash
python -m pytest tests/config/
```

To run a specific test file:

```bash
python -m pytest tests/config/test_config_set.py
```

To run a specific test function:

```bash
python -m pytest tests/config/test_config_set.py::test_slugify_key
```

## Installing Test Dependencies

The test dependencies are specified in setup.py as extras_require. To install them:

```bash
pip install -e ".[dev]"
```

This will install pytest and pytest-cov, which are required to run the tests.