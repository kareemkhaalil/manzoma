<div align="center">

  <img src="https://raw.githubusercontent.com/MaiiMagdy/Book-My-Movie-App/master/assets/images/logo.png" alt="manzoma logo" width="150"/>

  <h1>manzoma | منظومة</h1>

  <p>
    <strong>An All-in-One HR, Attendance, and Payroll Management System.</strong>
  </p>
  <p>
    Built with Flutter & Supabase for a seamless experience on Web, Mobile, and Desktop.
  </p>

  <!-- Badges -->
  <p>
    <a href="https://github.com/kareemkhaalil/manzoma/stargazers"><img src="https://img.shields.io/github/stars/your-username/manzoma?style=for-the-badge&logo=github&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41" alt="Stars"></a>
    <a href="https://github.com/kareemkhaalil/manzoma/issues"><img src="https://img.shields.io/github/issues/your-username/manzoma?style=for-the-badge&logo=github&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41" alt="Issues"></a>
    <a href="https://github.com/kareemkhaalil/manzoma/blob/main/LICENSE"><img src="https://img.shields.io/github/license/your-username/manzoma?style=for-the-badge&logo=github&color=B5E8E0&logoColor=D9E0EE&labelColor=302D41" alt="License"></a>
    <img src="https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter" alt="Flutter Version">
    <img src="https://img.shields.io/badge/Supabase-Backend-green?style=for-the-badge&logo=supabase" alt="Supabase">
  </p>

</div>

---

**manzoma (منظومة )** is a powerful, modern, and responsive Human Resources Management System designed to streamline and automate core HR operations. From tracking employee attendance to managing payroll, manzoma provides a centralized platform for businesses of all sizes.

The system is built using a **Clean Architecture** approach with **Flutter** for the frontend and **Supabase** for the backend, ensuring scalability, maintainability, and a consistent user experience across all platforms.

## ✨ Core Features

| Feature                 | Status      | Description                                                                                             |
| ----------------------- | ----------- | ------------------------------------------------------------------------------------------------------- |
| 🔐 **Authentication**       | ✅ Complete | Secure user login, registration, and session management using Supabase Auth.                            |
| 👤 **User Management**      | ✅ Complete | Create, update, and manage user profiles with role-based access control (Super Admin, Admin, Employee). |
| 🏢 **Client & Branch Mgmt** | ✅ Complete | Manage multiple clients and company branches, assigning users and resources accordingly.                |
| ⏰ **Attendance Tracking**  | ✅ Complete | Real-time employee check-in/check-out, with detailed daily and monthly attendance logs.                 |
| 💸 **Payroll Management**  | 🚧 In-Progress | Automate salary calculations, deductions, and generate payslips based on attendance and contracts.      |
| 📊 **Reporting & Analytics**| 🚧 In-Progress | Generate insightful reports for attendance, payroll, and user activity. Exportable to PDF & CSV.      |
| 📱 **Responsive UI**        | ✅ Complete | A single codebase delivering a beautiful, adaptive UI for Web, iOS, Android, and Desktop.               |
| 🔔 **Notifications**        | 📅 Planned  | Real-time alerts for important events like leave approvals and attendance reminders.                   |

---

## 🛠️ Tech Stack & Architecture

-   **Frontend**: [Flutter](https://flutter.dev/ ) (for cross-platform development)
-   **Backend**: [Supabase](https://supabase.com/ ) (Postgres Database, Authentication, Storage, and Edge Functions)
-   **Architecture**: Clean Architecture (Domain, Data, Presentation layers)
-   **State Management**: [BLoC / Cubit](https://bloclibrary.dev/ ) (for predictable state management)
-   **Navigation**: [GoRouter](https://pub.dev/packages/go_router ) (for declarative, URL-based routing)
-   **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it ) (for service location and inversion of control)
-   **Testing**: [Mockito](https://pub.dev/packages/mockito ) & [bloc_test](https://pub.dev/packages/bloc_test ) (for robust unit and widget testing)

---

## 🚀 Getting Started

Follow these steps to get the project up and running on your local machine.

### Prerequisites

-   [Flutter SDK](https://docs.flutter.dev/get-started/install ) (version >= 3.0.0)
-   A [Supabase](https://supabase.com ) account for the backend.

### Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/manzoma.git
    cd manzoma
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Supabase:**
    -   Create a new project on [supabase.com](https://supabase.com ).
    -   Go to `Project Settings` > `API`.
    -   Find your `Project URL` and `anon (public) key`.
    -   Create a `.env` file in the root of the project and add your keys:
        ```env
        SUPABASE_URL=YOUR_SUPABASE_URL
        SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
        ```
    -   **Important**: Run the SQL scripts located in the `supabase/migrations` directory in your Supabase SQL Editor to set up the database tables and roles.

4.  **Run the application:**
    ```bash
    flutter run
    ```

---

## 🧪 Running Tests

To ensure the stability and reliability of the codebase, run the full test suite:

```bash
flutter test
🤝 How to Contribute
We welcome contributions from the community! Whether it's fixing a bug, adding a new feature, or improving documentation, your help is appreciated.
Fork the repository.
Create a new branch (git checkout -b feature/YourAmazingFeature).
Make your changes and commit them (git commit -m 'Add some AmazingFeature').
Push to the branch (git push origin feature/YourAmazingFeature).
Open a Pull Request.
📄 License
This project is licensed under the MIT License. See the LICENSE file for more details.
<div align="center"> <p>Made with ❤️ by <strong>Kareem Khalil</strong></p> </div> ```
