🐦 twitter_clone

A Twitter-inspired social media application built using Flutter and Firebase, focusing on real-time interactions, clean UI, and scalable architecture.

This project demonstrates core social media features such as authentication, posting tweets, liking, deleting posts, and user profiles, implemented using modern Flutter development practices.

✨ Features

🔐 Firebase Authentication

Secure email & password login

📝 Create Tweets

Post text-based tweets instantly

❤️ Like & Unlike Tweets

Real-time like count updates

🗑️ Delete Tweets

Feed updates immediately after deletion

👤 User Profiles

View & update bio

See user’s tweet history

🔄 Real-time Feed

Firestore listeners for instant updates

📱 Mobile-first UI

Clean and responsive Flutter design

🛠️ Tech Stack

Flutter (Dart) – Frontend framework

Firebase Authentication – User login & signup

Cloud Firestore – Real-time database

GetX – State management & navigation

📂 Project Structure
lib/
├── modules/        # Feature-based modules (GetX)
├── models/         # Data models
├── services/       # Firebase services
├── widgets/        # Reusable UI components
└── main.dart       # App entry point


This project follows a modular GetX architecture, ensuring separation of UI, business logic, and bindings.

🚀 Getting Started

This project is a fully functional Flutter application.
Follow the steps below to run it locally.

🔁 Clone the Repository
git clone https://github.com/navtej21/twitter_clone.git
cd twitter_clone

📦 Install Dependencies
flutter pub get

🔥 Firebase Setup

Create a Firebase project

Enable:

Firebase Authentication (Email/Password)

Cloud Firestore

Add your Android/iOS app to Firebase

Download:

google-services.json (Android)

GoogleService-Info.plist (iOS)

Place them in the respective platform folders

▶️ Run the App
flutter run

🧪 Firestore Data Model (Overview)
users
 └── userId
     ├── username
     ├── email
     ├── bio

posts
 └── postId
     ├── content
     ├── authorId
     ├── likes
     ├── timestamp

📸 Screenshots

📌 Add screenshots here to showcase:

Login & Signup

Home Feed

Tweet Creation

Profile Page

Like / Delete Actions

Screenshots greatly improve first impressions 👀

🧠 Learning Outcomes

Real-time data handling with Firestore

Flutter + Firebase integration

GetX state management & modular design

Social media app architecture

Clean UI & responsive layouts

🛣️ Future Enhancements

🖼️ Image uploads in tweets

💬 Comment system

🔔 Push notifications

👥 Follow / Unfollow feature

🔍 Search users & tweets

📚 Resources

If you’re new to Flutter, these resources can help:

Lab: Write your first Flutter app

Cookbook: Useful Flutter samples

Flutter Documentation

📝 License

This project is licensed under the MIT License.

👨‍💻 Author

Navtej S. Nair
M.Tech (Integrated) Software Engineering
VIT Chennai

If you want next:

⭐ GitHub badges

📸 Screenshot layout

🧱 Enterprise-level README

🧠 Resume-optimized wording
