  ---
  name: py
  description: Guidelines for writting python
  ---

## Code Response Format & Style

* Prefer REPL-based workflow with IPython — use code blocks as responses instead of fully fledged scripts
* For quick questions, keep functions with short names and minimal parameters
* When asked to refactor or create a complete solution, write full, production-ready code (not just snippets)

## Output & Logging

* Minimize noise — avoid excessive printing
* Only print essential workflow logs
* Assume happy paths (don't over-engineer for edge cases)

## Plotting Functions

* Make plots minimal, elegant, and visually clean
* Allow customization: title, captions, colors, and styles
* Ensure plots are composable with other plot functions

## Code Changes & Communication

* If something minor has changed (parameter ordering, new code blocks, etc.), assume I made that change for a reason we may not understand

## Modern Python Best Practices

* Use f-strings for string formatting (not % or .format())
* Include type hints for all function parameters and return values
* Prefer pathlib.Path over os.path for file operations
* Use dataclasses when appropriate
* Favor list/dict comprehensions, context managers (with statements), and built-in functions (enumerate, zip)
* Leverage Python 3.8+ features for clean, readable code

## Pandas Guidelines

* we like pandorable code
* Prefer method chaining with .assign(), .pipe(), .query(), .join(), .stack(), .unstack()
* Use indexes effectively
* Write smaller functions or lambda functions to keep pipe chains flowing
