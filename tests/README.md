# Tests for ksubmit

This directory contains tests for the ksubmit package. The tests are organized to mirror the structure of the ksubmit package.

## Structure

```
tests/
├── cli/            # Tests for ksubmit.cli
├── config/         # Tests for ksubmit.config
├── examples/       # Tests for ksubmit.examples
├── kubernetes/     # Tests for ksubmit.kubernetes
├── parsers/        # Tests for ksubmit.parsers
└── utils/          # Tests for ksubmit.utils
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