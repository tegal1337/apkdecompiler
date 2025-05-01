#!/bin/bash

echo "Building APK Decompiler for Linux..."

BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$BUILD_DIR")"

cd "$PROJECT_ROOT" || { echo "Error: Failed to navigate to project root directory"; exit 1; }

if ! command -v mvn &> /dev/null; then
    echo "Maven is not installed. Please install Maven first."
    echo "On Ubuntu/Debian: sudo apt install maven"
    echo "On Fedora: sudo dnf install maven"
    echo "On Arch Linux: sudo pacman -S maven"
    exit 1
fi

if ! command -v java &> /dev/null; then
    echo "Java is not installed. Please install Java JDK first."
    echo "On Ubuntu/Debian: sudo apt install openjdk-11-jdk"
    echo "On Fedora: sudo dnf install java-11-openjdk-devel"
    echo "On Arch Linux: sudo pacman -S jdk11-openjdk"
    exit 1
fi

echo "Compiling the project with Maven..."
mvn clean package

if [ $? -ne 0 ]; then
    echo "Build failed. Please check the errors above."
    exit 1
fi

echo "Creating launcher script..."
cat > apkdecompiler << 'EOF'
#!/bin/bash

# Find the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Full path to the JAR file
JAR_PATH="$SCRIPT_DIR/target/apkdecompiler-1.0-SNAPSHOT-jar-with-dependencies.jar"

# Check if the JAR file exists
if [ ! -f "$JAR_PATH" ]; then
    echo "Error: JAR file not found at $JAR_PATH"
    echo "Please run the build script first."
    exit 1
fi

# Check if arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <input.apk> <output_folder>"
    exit 1
fi

# Run the JAR file with the provided arguments
java -jar "$JAR_PATH" "$@"
EOF

chmod +x apkdecompiler

echo
echo "Do you want to create a symlink in /usr/local/bin for system-wide access? (y/n)"
read -r answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    if sudo ln -sf "$(pwd)/apkdecompiler" /usr/local/bin/apkdecompiler; then
        echo "Symlink created at /usr/local/bin/apkdecompiler"
        echo "You can now run 'apkdecompiler' from anywhere."
    else
        echo "Failed to create symlink. You may need to run with sudo."
    fi
fi

echo
echo "Build completed successfully!@"
echo "You can now decompile APK files using:"
echo "./apkdecompiler <input.apk> <output_folder>"
echo
echo "Example:"
echo "./apkdecompiler path/to/app.apk output-directory"