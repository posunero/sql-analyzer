from setuptools import setup, find_packages

setup(
    name="sql-analyzer",
    version="0.1.0",
    packages=find_packages(),
    package_data={"sql_analyzer": ["py.typed"]},
    include_package_data=True,
    install_requires=[
        "lark>=1.0.0",
        "sqlglot",
        "Jinja2",
    ],
    entry_points={
        "console_scripts": [
            "sql-analyzer=sql_analyzer.main:main",
        ],
    },
    python_requires=">=3.8",
) 