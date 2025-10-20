# Contributing to Data Engineer Learning Path

Thank you for your interest in contributing! This document provides guidelines for contributing to this learning repository.

## How to Contribute

### Reporting Issues
- Check if the issue already exists
- Provide a clear description
- Include relevant details (lesson number, code snippets, etc.)

### Suggesting Improvements
- Open an issue with the "enhancement" label
- Describe the improvement clearly
- Explain why it would be valuable

### Adding Content

#### Adding Lessons
1. Fork the repository
2. Create a new branch (`git checkout -b add-lesson-topic`)
3. Add your lesson in the appropriate directory
4. Follow the existing lesson format
5. Include examples and exercises
6. Update the section README.md
7. Submit a pull request

#### Adding Examples
- Place in the appropriate `examples/` folder
- Include comments explaining the code
- Make sure code runs without errors
- Add a docstring at the top of the file

#### Adding Exercises
- Place in the appropriate `exercises/` folder
- Include clear problem description
- Provide sample input/output
- Include solution in a separate file (e.g., `exercise_name_solution.py`)

## Code Style Guidelines

### Python Code
- Follow PEP 8 style guide
- Use meaningful variable names
- Add comments for complex logic
- Include docstrings for functions
- Keep functions focused and small

### SQL Code
- Use uppercase for SQL keywords
- Indent subqueries
- Add comments explaining complex queries
- Format for readability

### Markdown
- Use headers appropriately (# for main title, ## for sections, etc.)
- Include code blocks with language specification
- Add blank lines between sections
- Use bullet points for lists

## Content Guidelines

### Lessons
- Start with clear learning objectives
- Progress from simple to complex
- Include practical examples
- End with exercises or a project
- Link to additional resources

### Examples
- Should be runnable without modification (when possible)
- Include error handling
- Demonstrate best practices
- Keep focused on one concept

### Exercises
- Should reinforce lesson concepts
- Provide varying difficulty levels
- Include hints for difficult problems
- Solution should include explanation

## Pull Request Process

1. **Create a descriptive PR title**
   - Good: "Add lesson on pandas groupby operations"
   - Bad: "Update files"

2. **Describe your changes**
   - What was added/changed
   - Why the change is needed
   - Any relevant context

3. **Ensure quality**
   - Code runs without errors
   - Markdown renders correctly
   - No typos or grammar issues
   - Links work correctly

4. **Wait for review**
   - Respond to feedback
   - Make requested changes
   - Be patient and respectful

## Testing Your Contributions

### Python Code
```bash
# Run the code to ensure it works
python your_script.py

# Check for syntax errors
python -m py_compile your_script.py
```

### SQL Code
- Test queries in a database
- Verify results are correct
- Check for syntax errors

### Markdown
- Preview in VS Code or GitHub
- Verify links work
- Check formatting

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Provide constructive feedback
- Focus on the content, not the person
- Help create a positive learning environment

## Questions?

If you have questions about contributing:
1. Check existing issues and discussions
2. Open a new issue with your question
3. Tag it with "question"

## Recognition

Contributors will be acknowledged in the repository. Thank you for helping others learn!

## License

By contributing, you agree that your contributions will be licensed under the same license as this project (MIT License).
