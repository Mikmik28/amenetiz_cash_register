# Amenitiz Cash Register

A small Rails cash register that scans product **codes** into a cart.

## Features
- **Dynamic Pricing**: Multiple discount rules including BOGO, bulk discounts, and threshold multipliers  
- **Real-time Cart**: Live cart updates with add/remove functionality

# Discount rules
The system supports three types of discount rules:

1. **Buy One Get One Free (BOGO)**: Buy 1, get 1 free
2. **Bulk Discount**: 3+ items at a reduced price (e.g., 3+ strawberries for €4.50 each)
3. **Threshold Multiplier**: 3+ items at 2/3 price (e.g., 3+ coffees at 2/3 price)

Bonus: The Threshold for all of these rules can be adjustable

## Getting Started

### Prerequisites

- Ruby 3.2+
- Node.js 18+
- PostgreSQL
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd amenitiz_cash_register
   ```

2. **Install dependencies**
   ```bash
   bundle install
   npm install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Build assets**
   ```bash
   npm run build
   npm run build:css
   ```

5. **Start the server**
   ```bash
   rails server
   # or for development with auto-reload:
   bin/dev
   ```

6. **Visit the application**
   ```
   http://localhost:3000
   ```
