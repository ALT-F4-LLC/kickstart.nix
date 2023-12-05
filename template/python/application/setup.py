from setuptools import setup, find_packages

setup(
    entry_points={
        "console_scripts": [
            "start=myapp.main:main",
        ],
    },
    install_requires=["mylib==1.0.0"],
    name="myapp",
    packages=find_packages(),
    version="1.0.0",
)
