# My Flutter Project

This is a Flutter application that demonstrates the use of various features and best practices in Flutter development.

## Project Structure

```
my_flutter_project
├── lib
│   ├── main.dart                # Entry point of the application
│   ├── bloc
│   │   └── project.dart         # Business logic for project management
│   ├── datamodel
│   │   ├── donation_entity.dart # Data model for donations
│   │   ├── project_entity.dart  # Data model for projects
│   │   ├── repository.dart      # Repository for managing data
│   │   └── user_entity.dart     # Data model for users
│   ├── screens
│   │   └── home_screen.dart     # Home screen of the app
│   ├── widgets
│   │   └── custom_widget.dart   # Reusable custom widget
│   └── extensions
│       └── date_time_formatting.dart # Utility extensions for DateTime
├── assets
│   └── data
│       ├── project_days.json    # JSON data for project days
│       ├── projects.json        # JSON data for projects
│       └── donations.json       # JSON data for donations
├── pubspec.yaml                 # Project configuration and dependencies
├── analysis_options.yaml        # Dart analyzer configuration
└── README.md                    # Project documentation
```

## Getting Started

To run this project, ensure you have Flutter installed on your machine. You can clone this repository and run the following commands:

```bash
flutter pub get
flutter run
```

## Features

- **Project Management**: Manage projects with detailed information, including donations and assigned users.
- **Donations Tracking**: Track donations by users for specific projects and project days.
- **Custom Widgets**: Reusable widgets for consistent UI across the app.
- **Data Models**: Comprehensive data models for projects, donations, and users.
- **Utility Extensions**: Helpful extensions for working with `DateTime` and lists.

## Contributing

Feel free to fork the repository and submit pull requests for any improvements or features you would like to add.

## License

This project is licensed under the MIT License. See the LICENSE file for details.