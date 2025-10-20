# Getting Started with Python

## What is Python?

Python is a high-level, interpreted programming language known for its simplicity and readability. It's one of the most popular languages for data engineering, data science, and general-purpose programming.

## Why Python for Data Engineering?

- **Easy to Learn**: Clear and readable syntax
- **Extensive Libraries**: Rich ecosystem for data manipulation (Pandas, NumPy)
- **Cross-platform**: Works on Windows, Mac, and Linux
- **Large Community**: Extensive resources and support
- **Integration**: Works well with databases and data tools

## Installing Python

### Windows
1. Download Python from [python.org](https://www.python.org/downloads/)
2. Run the installer (check "Add Python to PATH")
3. Verify installation: `python --version`

### Mac
```bash
# Using Homebrew
brew install python3
python3 --version
```

### Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip

# Verify
python3 --version
```

## Your First Python Program

Create a file called `hello.py`:

```python
print("Hello, Data Engineer!")
```

Run it:
```bash
python hello.py
```

## Python Interactive Shell

You can also use Python interactively:

```bash
python
>>> print("Hello!")
Hello!
>>> 2 + 2
4
>>> exit()
```

## Setting Up Your Development Environment

### Option 1: VS Code (Recommended)
1. Install [VS Code](https://code.visualstudio.com/)
2. Install Python extension
3. Create a workspace for your projects

### Option 2: PyCharm
1. Install [PyCharm Community Edition](https://www.jetbrains.com/pycharm/)
2. Create a new Python project

### Option 3: Jupyter Notebook
Great for data exploration:
```bash
pip install jupyter
jupyter notebook
```

## Virtual Environments

Always use virtual environments for your projects:

```bash
# Create a virtual environment
python -m venv myenv

# Activate it
# Windows:
myenv\Scripts\activate
# Mac/Linux:
source myenv/bin/activate

# Install packages
pip install pandas

# Deactivate
deactivate
```

## Basic Python Syntax

### Comments
```python
# This is a single-line comment

"""
This is a
multi-line comment
or docstring
"""
```

### Print Statement
```python
print("Hello World")
print("Value:", 42)
```

### Basic Arithmetic
```python
# Addition
print(5 + 3)  # 8

# Subtraction
print(10 - 4)  # 6

# Multiplication
print(3 * 4)  # 12

# Division
print(15 / 3)  # 5.0

# Integer Division
print(15 // 4)  # 3

# Modulus
print(15 % 4)  # 3

# Exponentiation
print(2 ** 3)  # 8
```

## Next Steps

Now that you have Python installed and running, proceed to the next lesson on variables and data types.

## Practice Exercise

1. Install Python on your computer
2. Set up VS Code or your preferred editor
3. Create a Python file that prints your name
4. Use the Python interactive shell to calculate: (10 + 5) * 3
5. Create a virtual environment for this course

## Additional Resources

- [Python.org Beginner's Guide](https://wiki.python.org/moin/BeginnersGuide)
- [Real Python - Installation & Setup](https://realpython.com/installing-python/)
