from setuptools import setup, find_packages
import os

# Read the contents of the README file
with open("README.md", encoding="utf-8") as f:
    long_description = f.read()

setup(
    name="ksub",
    version="0.1.3",
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        "typer[all]",  # CLI with colors
        "pyyaml",  # YAML generation
        "kubernetes",  # Kubernetes Python SDK
        "python-dotenv",  # .env file support
        "rich",  # Rich text and formatting in terminal
        "duckdb",  # Optional local database for job tracking
    ],
    extras_require={
        "dev": [
            "pytest",  # Testing framework
            "pytest-cov",  # Coverage reporting
        ],
    },
    entry_points={
        "console_scripts": [
            "krun=ksub.cli.shorthand:main",
            "kstat=ksub.cli.shorthand:main",
            "klogs=ksub.cli.shorthand:main",
            "kdesc=ksub.cli.shorthand:main",
            "kdel=ksub.cli.shorthand:main",
            "kls=ksub.cli.shorthand:main",
            "klist=ksub.cli.shorthand:main",
            "klint=ksub.cli.shorthand:main",
            "kconfig=ksub.cli.shorthand:main",
            "kversion=ksub.cli.shorthand:main",
            "kinit=ksub.cli.shorthand:main",
        ],
    },
    python_requires=">=3.8",
    author="John Kitonyo",
    author_email="johnkitonyo@outlook.com",
    description="A Kubernetes job submission tool for batch processing",
    long_description=long_description,
    long_description_content_type="text/markdown",
    keywords="kubernetes, batch, jobs, cli, hpc, grid-engine, uge, job-scheduler",
    url="https://github.com/kilonzi/ksub",
    project_urls={
        "Documentation": "https://github.com/kilonzi/ksub",
        "Source": "https://github.com/kilonzi/ksub",
        "Bug Tracker": "https://github.com/kilonzi/ksub/issues",
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Intended Audience :: Science/Research",
        "Intended Audience :: System Administrators",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: System :: Clustering",
        "Topic :: System :: Distributed Computing",
        "Topic :: Scientific/Engineering",
        "Operating System :: OS Independent",
    ],
    # Using SPDX license identifier as recommended by setuptools
    license="MIT",
)
