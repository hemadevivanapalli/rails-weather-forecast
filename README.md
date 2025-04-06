# 🌦 Weather Forecast App (Rails 7.1)

A weather forecast application built with **Ruby on Rails 7.1**, integrating Google's **Geocoding API** and **Weather API**. Users can enter any address to receive a 7-day forecast. Forecasts are cached by ZIP code for performance and cost-efficiency.

---

## 🔧 Features

- 🗺️ Address-to-Coordinates lookup via Google Geocoding API
- 📦 ZIP-code based caching with expiration (30 minutes)
- 📡 7-day forecast via Google Weather API
- ⚡ Turbo + Stimulus for smooth form submission and loading
- ✅ Unit tests for controllers and services using RSpec
- 🎨 Clean, semantic UI using partials and helpers
- 💾 Forecast caching using `Rails.cache`
- 🚨 Cache badge indicator in the UI

---

## 🧱 Tech Stack

- Ruby 3.2.3
- Rails 7.1
- Turbo + Stimulus
- HTTParty (for API integration)
- RSpec (for testing)
- dotenv-rails (for local API keys)
- Caching via `memory_store` (dev)

---

## 🚀 Getting Started

### 1. Clone & Setup

```bash
git clone https://github.com/your-username/weather-forecast-app.git
cd rails-weather-forecast
bundle install
```

### 2. Add Environment Keys

Create a `.env` file in root:

```env
GOOGLE_API_KEY=your_api_key_here
```

### 3. Start the Server

```bash
bin/rails server
```

Access at `http://localhost:3000`

---

## ✅ Run Tests

```bash
bundle exec rspec
```

Specs are located under:

- `spec/requests/forecasts_controller_spec.rb`
- `spec/services/forecast_fetcher_service_spec.rb`
- `spec/views/forecasts/_forecast.html.erb_spec.rb`

---

## 📂 File Structure

```
app/
├── controllers/
│   └── forecasts_controller.rb
├── services/
│   ├── forecast_fetcher_service.rb
│   ├── geocoding_service.rb
│   └── weather_service.rb
├── views/
│   └── forecasts/
│       ├── _form.html.erb
│       ├── _forecast.html.erb
│       └── new.html.erb
├── helpers/
│   └── forecasts_helper.rb
```

---

## 🧠 Decomposition & Design Considerations

### 🧩 Modular Service Objects

- **GeocodingService** – handles address → coordinates and ZIP extraction
- **WeatherService** – makes forecast API requests
- **ForecastFetcherService** – orchestrates logic, including caching

### ♻️ Reusability & Encapsulation

- Business logic is decoupled from controllers
- `Result` object pattern avoids loose nil/error returns
- `forecast_day_summary` helper extracts view logic for better separation

### 📦 Caching Strategy

- Cached per ZIP using `Rails.cache` to reduce API load
- Expiry set to 30 minutes
- Indicator shown if result is from cache

---

## 📌 Future Improvements

- System tests using Capybara
- Add timezone-aware forecast display
- User preferences for °C/°F toggle
- Location-based auto-detect (HTML5 Geo + reverse geocoding)

---

## 🔐 API Usage & Limits

- Ensure you **restrict your Google API key** to allow only:
  - Geocoding API
  - Weather API (for eligible accounts)
  - Correct domains/IPs

---

## 👨‍💻 Author

Hema – [LinkedIn](https://www.linkedin.com/in/hemadevi-vanapalli-21b756260/) | [GitHub](https://github.com/hemadevivanapalli)
