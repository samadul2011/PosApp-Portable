# Contributing to PosApp-Portable

Thank you for your interest in contributing to PosApp-Portable!

## Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/PosApp-Portable.git
   cd PosApp-Portable
   ```
3. Set up development environment:
   - Install JDK 17 or later
   - Install Maven 3.6 or later
   - Install your favorite IDE (IntelliJ IDEA, Eclipse, VS Code)

## Making Changes

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes to the code

3. Test your changes:
   ```bash
   mvn clean package
   mvn javafx:run
   ```

4. Build the portable package:
   ```bash
   ./build-portable.sh
   ```

5. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

7. Create a Pull Request on GitHub

## Code Style

- Follow Java naming conventions
- Use meaningful variable and method names
- Add comments for complex logic
- Keep methods focused and concise
- Use JavaFX best practices for UI code

## Testing

- Test the application with `mvn javafx:run`
- Test the portable package after building
- Ensure it works without bundled JRE (using system Java)
- Test on different Windows versions if possible

## Reporting Issues

When reporting issues, please include:
- Operating system and version
- Java version (if applicable)
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if relevant

## Feature Requests

We welcome feature requests! Please open an issue with:
- Clear description of the feature
- Use case / why it would be useful
- Proposed implementation (if you have ideas)

## Areas for Contribution

- UI improvements
- New features (inventory management, reporting, etc.)
- Database integration
- Multi-language support
- Documentation improvements
- Bug fixes
- Performance optimizations

## Questions?

Feel free to open an issue for questions or reach out to samadul2011@gmail.com

Thank you for contributing!
