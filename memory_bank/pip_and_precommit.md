# Making this Project Pip Installable and Integrating with Pre-commit

## 1. Packaging for pip

1. Add or verify your package layout:
   ```text
   sql_analyzer/
   ├── setup.py
   ├── setup.cfg      # optional
   ├── pyproject.toml
   ├── src/
   │   └── sql_analyzer/
   │       ├── __init__.py
   │       └── main.py
   └── ...
   ```
2. Create `setup.py` at the root:
   ```python
   from setuptools import setup, find_packages

   setup(
       name="sql-analyzer",
       version="0.1.0",
       package_dir={"": "src"},
       packages=find_packages(where="src"),
       install_requires=[
           # e.g., "sqlparse>=0.4.2"
       ],
       entry_points={
           "console_scripts": [
               "sql-analyzer=sql_analyzer.main:cli",
           ],
       },
       python_requires=">=3.7",
   )
   ```
3. Optionally, add a `pyproject.toml` with build-system settings:
   ```toml
   [build-system]
   requires = ["setuptools", "wheel"]
   build-backend = "setuptools.build_meta"
   ```
4. Build and publish:
   ```bash
   python -m build        # creates dist/
   twine upload dist/*    # uploads to PyPI
   ```

## 2. Integrating with pre-commit

1. Install `pre-commit` if not already:
   ```bash
   pip install pre-commit
   ```
2. Add a `.pre-commit-config.yaml` at the project root:
   ```yaml
   repos:
     - repo: local
       hooks:
         - id: sql-analyzer
           name: Run SQL Analyzer
           entry: sql-analyzer
           language: system
           files: "\\.sql$"
   ```
3. Install the hook in your repo:
   ```bash
   pre-commit install
   ```
4. Run hooks manually or on commit:
   ```bash
   pre-commit run --all-files
   ```
5. (Optional) Publish your hook to a remote repo so other projects can include it:
   ```yaml
   repos:
     - repo: https://github.com/yourusername/sql-analyzer
       rev: v0.1.0
       hooks:
         - id: sql-analyzer
   ```