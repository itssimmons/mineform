# Contributing Guidelines

Thank you for considering contributing to this project. Your involvement is most welcome.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Branching Strategy](#branching-strategy)
- [Commit Messages](#commit-messages)
- [Pull Requests](#pull-requests)
- [Reporting Issues](#reporting-issues)
- [Style Guidelines](#style-guidelines)

## Code of Conduct

Please be respectful and constructive in all interactions. Harassment or inappropriate behavior will not be tolerated.


## Getting Started

1. Fork the repository
2. Clone your fork:
```bash
git clone https://github.com/<your-username>/<repo-name>.git
```
3. Create a new branch:
```bash
git checkout -b feature/your-feature-name
```

## Development Workflow

* Keep your branch up to date with main
* Write clear, maintainable code
* Add or update tests when applicable
* Ensure the project builds and tests pass before submitting changes
* Branching Strategy

## Use descriptive branch names:

* feature/... for new features
* fix/... for bug fixes
* chore/... for maintenance
* docs/... for documentation changes

## Commit Messages

Follow a consistent format:

```
type(scope): short description
```

Examples:

* `feat(auth): add JWT authentication`
* `fix(api): handle null response error`

Types:

* `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`

## Pull Requests

Before opening a pull request:

* Ensure your code compiles and passes tests
* Rebase your branch onto the latest main
* Keep PRs focused and minimal

## Reporting Issues

When creating an issue, include:

* Clear description
* Steps to reproduce
* Expected vs actual behavior
* Environment details (OS, version, etc.)
* Style Guidelines
* Follow existing code style
* Prefer readability over cleverness
* Keep functions small and focused
* Document non-obvious logic

---

Thank you for contributing 🤠.
