#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Rust (cargo and rustc)
install_rust() {
    echo "Installing Rust (cargo and rustc)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
}

# Function to install Python
install_python() {
    echo "Installing Python..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y python3 python3-pip
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command_exists brew; then
            echo "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install python
    else
        echo "Unsupported OS. Please install Python manually."
        exit 1
    fi
}

# Function to install pre-commit
install_pre_commit() {
    echo "Installing pre-commit..."
    if command_exists python3; then
        python3 -m pip install --user pre-commit
    elif command_exists python; then
        python -m pip install --user pre-commit
    else
        echo "Python is not installed. Installing Python..."
        install_python
        if command_exists python3; then
            python3 -m pip install --user pre-commit
        elif command_exists python; then
            python -m pip install --user pre-commit
        else
            echo "Failed to install Python. Please install Python manually."
            exit 1
        fi
    fi
}

# Check for cargo
if command_exists cargo; then
    echo "cargo is already installed."
else
    echo "cargo is not installed."
    install_rust
fi

# Check for rustc
if command_exists rustc; then
    echo "rustc is already installed."
else
    echo "rustc is not installed."
    install_rust
fi

# Check for Python (required for pre-commit)
if command_exists python3; then
    echo "Python 3 is already installed."
elif command_exists python; then
    echo "Python is already installed."
else
    echo "Python is not installed. Installing Python..."
    install_python
fi

# Check for pre-commit
if command_exists pre-commit; then
    echo "pre-commit is already installed."
else
    echo "pre-commit is not installed."
    install_pre_commit
fi

echo "All required tools are installed."
