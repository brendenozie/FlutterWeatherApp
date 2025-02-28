# FlutterWeatherApp

## Updated to Flutter 3.0 & New Updated Design

A simple weather app created using [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/), utilizing the API from [OpenWeatherMap](https://openweathermap.org/).

<p align="center">
  <img src="https://github.com/brendenozie/FlutterWeatherApp/blob/main/assets/images/img.png" width="50%" alt="screenshot">
</p>

---

## App Features

- Display current weather and a **5-day forecast** for a selected city.
- Users can **search** for a city and view its weather details.
- **Loading indicator** while fetching data from the API.
- **Offline support**: Cache weather data for offline access.
- Show **last updated timestamp** when viewing cached data.
- **Error handling** for network issues and API failures.
- **Modern UI/UX** with appropriate icons, typography, and color schemes.
- Responsive design for different screen sizes.

---

## API Docs

> **Important:**
> This project uses **version 3.0** of the OpenWeatherMap API.
>
> **APIs used in this project:**
>
> - [Current Weather API Docs](https://openweathermap.org/current#one)
> - [One Call API Docs](https://openweathermap.org/api/one-call-api#data)
> - [Geocoding API Docs](https://openweathermap.org/api/geocoding-api)

---

## How to Run

1. Create an account at [OpenWeatherMap](https://openweathermap.org/).
2. Get your API key from [OpenWeatherMap API Keys](https://home.openweathermap.org/api_keys).
   - Sometimes, API keys take time to activate.
   - To test your API key, paste the following link into your browser:
     ```
     https://api.openweathermap.org/data/3.0/weather?lat=53.4794892&lon=-2.2451148&units=metric&appid=YOUR_API_KEY
     ```
     Replace `YOUR_API_KEY` with your actual API key.
3. Clone the repository:
   ```sh
   git clone https://github.com/brendenozie/FlutterWeatherApp.git
   ```
4. Install dependencies:
   ```sh
   flutter pub get
   ```
5. Add your API key:
   - Navigate to **lib/provider/weatherProvider.dart** and update the `apiKey` variable:
     ```dart
     String apiKey = 'Paste Your API Key Here';
     ```
6. Run the app:
   ```sh
   flutter run
   ```

---

## Approach & Challenges

### Approach

- Used **Flutter & Dart** to develop the application.
- Integrated **OpenWeather API** for fetching weather data.
- Implemented **local storage** to save weather data for offline access.
- Designed a **responsive UI** to work across different screen sizes.

### Challenges & Solutions

1. **Handling API Errors:**
   - Implemented error handling to display user-friendly messages.
   - Added retry mechanisms when fetching data fails.
2. **Offline Support:**
   - Used **local storage** to save and display cached weather data.
   - Indicated when data was last updated to inform users.
3. **UI/UX Optimization:**
   - Designed a modern and clean interface with appropriate colors and typography.
   - Ensured responsiveness across different screen sizes.

---

## License

Distributed under the **MIT License**. See the `LICENSE` file for more information.

---

## Submission

- The source code is available in this GitHub repository.
- This README contains setup instructions and implementation details.
