# MyESCParty

**MyESCParty** is a private Eurovision voting app that allows you to vote together with friends or larger communities — just like a real jury!

Whether you're hosting a small party or joining an international fan group, this app helps you bring the excitement of Eurovision voting into your own circle.

---

## 📱 Requirements

- iOS 17.6+
- Xcode 15+

---

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/mpiechota92/MyESCParty.git
   ```
2. Open the project in Xcode and build the app.
3. On your iOS device, enable "Demo Mode" for the app in system settings.
4. Log in with any valid credentials (must match field types), e.g.  
   **Email:** `test@test.com`  
   **Password:** `123456789`

---

## ✨ Features

- 🔐 Create and join **public or private** voting rooms
- 🗳 Vote across **each stage** of the Eurovision contest
- 📊 View **results per room** and compare with **global** results

---

## 🎥 Demo


> 📌 Note: GIFs recorded from simulator – performance may vary on real device.

---

## 🧱 Tech Stack

- **Swift**, **SwiftUI**
- **Supabase** (PostgreSQL backend with authentication)
- **PostgREST**
- **SwiftUIIntrospect** (UI customization layer)

---

## 🧠 Architecture

The app follows the **MVVM** (Model-View-ViewModel) pattern:

- Views are implemented with SwiftUI
- ViewModels contain state logic and user interactions
- Services are responsible for communicating with the Supabase backend (fetching data, authentication, real-time updates)

---

## 📌 To Do / Roadmap

- [ ] User profile editing
- [ ] Voting animations
- [ ] Live voting results with auto-refresh
- [ ] QR code invitations for private rooms
