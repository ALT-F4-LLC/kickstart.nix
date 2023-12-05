from setuptools import setup, find_packages

setup(
    entry_points={"console_scripts": ["start=example.main:main"]},
    name="example",
    packages=find_packages(),
    version="1.0.0",
)
