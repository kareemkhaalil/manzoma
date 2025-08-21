
```markdown
# manzoma

**manzoma** is a modern, responsive **Attendance & HR Management System** built with **Flutter** and **Supabase**.  
It provides companies and organizations with a streamlined solution to manage employees, branches, clients, and attendance records all in one place.  

---

## 🚀 Features

- 🔐 **Authentication & Authorization**
  - Role-based access control (Admin, Manager, Employee)
  - Secure login & signup via Supabase  

- 👥 **User Management**
  - Create, update, and deactivate users
  - Assign roles & permissions
  - Profile management  

- 🏢 **Branch Management**
  - Add and manage company branches
  - Associate users with branches  

- 🤝 **Client Management**
  - Create and manage client records
  - Associate projects/attendance with specific clients  

- ⏰ **Attendance Tracking**
  - Employee check-in / check-out
  - Daily and monthly reports
  - Export options (CSV, Excel, PDF)  

- 📱 **Responsive UI**
  - Works seamlessly on **Web, Mobile, and Desktop**  
  - Built with Flutter’s responsive widgets and adaptive design  

---

## 🛠️ Tech Stack

- **Frontend**: [Flutter](https://flutter.dev/) (Clean Architecture, BLoC, GoRouter)
- **Backend**: [Supabase](https://supabase.com/) (Postgres, Auth, Storage)
- **State Management**: BLoC / Cubit
- **Dependency Injection**: GetIt
- **Testing**: Mockito, Unit Tests

---

## 📂 Project Structure

```

lib/
│── core/                # Core utilities, constants, base classes
│── features/            # Modular features (auth, users, clients, branches...)
│   ├── auth/
│   ├── users/
│   ├── clients/
│   ├── branches/
│   └── attendance/
│── shared/              # Shared widgets & helpers
│── main.dart            # Entry point

````

---

## ⚡ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.0.0)
- [Dart](https://dart.dev/get-dart)
- Supabase project (database + API keys)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/manzoma.git
   cd manzoma
````

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Supabase**

   * Create a Supabase project at [supabase.com](https://supabase.com)
   * Copy your `SUPABASE_URL` and `SUPABASE_ANON_KEY`
   * Add them to your environment config (e.g. `.env` file or constants)

4. **Run the project**

   ```bash
   flutter run
   ```

---

## 🧪 Running Tests

```bash
flutter test
```

---

## 📌 Roadmap

* [ ] Notifications & alerts
* [ ] Payroll integration
* [ ] Advanced reporting & analytics
* [ ] Multi-language support (EN/AR)

---

## 🤝 Contributing

Contributions are welcome! Please fork the repo and submit a pull request.

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Kareem Khalil**
Flutter Developer | Clean Architecture Enthusiast

```

---

تحب أجهزلك كمان **شعار (banner)** بسيط بصيغة Markdown يتعرض في أول الـ README (مثلاً فيه كلمة manzoma + Attendance System)؟
```
