# Flutter Development Commands

.PHONY: install setup run clean build test help

# Install Flutter dependencies
install:
	@echo "Installing Flutter dependencies..."
	flutter pub get

# Setup the project (install dependencies and generate code if needed)
setup: install
	@echo "Setting up the project..."
	@echo "Setup complete!"

# Run the Flutter application
run:
	@echo "Running Flutter application..."
	flutter run

# Run on specific device
run-chrome:
	flutter run -d chrome

run-windows:
	flutter run -d windows

run-android:
	flutter run -d android

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	flutter clean

# Build the application
build:
	@echo "Building Flutter application..."
	flutter build apk

build-windows:
	flutter build windows

build-web:
	flutter build web

# Run tests
test:
	@echo "Running tests..."
	flutter test

# Help command
help:
	@echo "Available commands:"
	@echo "  make install       - Install Flutter dependencies"
	@echo "  make setup         - Setup the project"
	@echo "  make run           - Run the Flutter application"
	@echo "  make run-chrome    - Run on Chrome"
	@echo "  make run-windows   - Run on Windows"
	@echo "  make run-android   - Run on Android"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make build         - Build APK"
	@echo "  make build-windows - Build for Windows"
	@echo "  make build-web     - Build for Web"
	@echo "  make test          - Run tests"


# firebase use farms-2025 && firebase deploy --only firestore:indexes
# firebase deploy --project farms-2025 --only firestore:indexes 2>&1 | head -20
# firebase projects:list
# flutterfire configure
# flutter pub run build_runner build --delete-conflicting-outputs
