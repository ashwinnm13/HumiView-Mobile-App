# HumiView Mobile App 🌡️💧

HumiView is a comprehensive Flutter-based mobile and tablet monitoring application designed for healthcare environments (like ICUs). It provides real-time tracking of patient ventilator environments, including temperature, relative humidity, absolute humidity, and smart heater status.

The application securely connects to a Spring Boot backend (with a MySQL database) to offer live sensor polling, historical data rendering, and a robust alert notification system.

---

## ✨ Features Implemented So Far

### 1. Live Sensor Monitoring & Data Visualization 📈
- **Real-time Polling Engine:** Automatically polls the backend every 3 seconds for new sensor data, updating the UI smoothly without rebuilding the entire screen.
- **Dynamic Line Charts:** Integrated with `fl_chart` to render historical and live sensor trends.
  - Automatically handles single data points safely.
  - Dynamically auto-scales Y-axis bounds if real room data falls outside predicted norms.
- **Patient Dashboard Cards:** Instantly fetches the latest sensor reading for all patients on the dashboard, displaying live temperature, humidity, and heater metrics right on the home screen.

### 2. Comprehensive Alert System 🔔
- **Global Alert Synchronization:** Fetches critical and warning alerts directly from the Spring Boot backend (`/alerts` endpoint).
- **Interactive Badge Notifications:** Unread alerts trigger red notification badges seamlessly integrated into both the Top App Bar and the Bottom Navigation Bar/Side Rail.
- **Actionable Alerts:** Users can "Acknowledge" or "Dismiss" alerts, which instantly sends a `PUT` request to update the database state in real-time.

### 3. Patient Management & State Management 🏥
- **Decoupled Architecture:** Clean separation of concerns using `Provider` for state management (`PatientProvider`, `MonitoringProvider`, `AlertProvider`) and HTTP service classes (`SensorApiService`, `AlertApiService`).
- **Data Integrity:** Safely maps between Flutter's custom string identifiers and the database's internal numeric Primary Keys to ensure flawless foreign-key relationships.

### 4. Adaptive & Responsive UI 📱💻
- **Cross-Platform Navigation:** Automatically uses a `NavigationBar` on mobile phones and expands into a `NavigationRail` for tablets/desktops to maximize screen real estate.
- **Heater Control:** Dedicated UI to toggle heater modes (Manual vs Auto) dynamically.

---

## 🚀 Technical Stack
* **Frontend:** Flutter & Dart
* **State Management:** Provider
* **Charts:** fl_chart
* **Networking:** http (REST API)
* **Backend Compatibility:** Designed for a Java Spring Boot backend with JPA/Hibernate connected to MySQL.
* **IoT Readiness:** Fully architected to accept continuous live streaming from an ESP32 microcontroller publishing data to the backend.

---

## 🛠️ Getting Started

### Prerequisites
* Flutter SDK (Latest stable version)
* An active instance of the HumiView Spring Boot backend running locally or on a server.
* Ensure your mobile device and backend server are on the same local network if testing via local IPs.

### Running the App
1. Update your backend IP address in `lib/core/constants/api_constants.dart`:
   ```dart
   static const String baseUrl = 'http://<YOUR_LOCAL_IP>:8080';
   ```
2. Get the dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```
