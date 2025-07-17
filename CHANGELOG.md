# Changelog

All notable changes to this project will be documented in this file.

## [0.0.2] - 2024-07-17

### Fixed
- Updated screenshot package dependency from ^2.1.0 to ^3.0.0 for Flutter compatibility
- Fixed build errors related to ViewConfiguration parameters
- Improved compatibility with latest Flutter versions

### Changed
- Updated minimum Flutter version requirement to 3.0.0
- Enhanced package stability and performance

## [0.0.1] - 2024-07-17

### Added
- Initial release of telegram_logger package
- Send error reports to Telegram with `sendError()` method
- Send custom log messages with `sendLog()` method
- Optional screenshot support for both error reports and logs
- Customizable message templates
- Global Flutter error handling support
- UI overflow error detection
- Comprehensive documentation and examples

### Features
- 🚨 Error reporting with stack traces
- 📋 Custom logging capabilities
- 📸 Screenshot integration using screenshot package
- 🎨 Customizable message templates
- 🔧 Easy initialization and setup
- 📱 Cross-platform support (Android, iOS, Web, Desktop)
- 🛡️ Built-in error handling for common Flutter errors

### Documentation
- Complete setup guide with Telegram bot creation
- Video tutorial links for bot setup and chat ID retrieval
- Security best practices
- API reference documentation
- Multiple usage examples