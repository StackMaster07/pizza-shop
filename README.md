# Pizza Shop

## Overview
Pizza Shop is a full-featured restaurant management application built with **Ruby on Rails 7**. It provides an intuitive interface for managing orders, menu items, and staff roles while ensuring a seamless user experience with **Turbo Streams and Hotwire**.

## Features
- **Menu Management** – Add, edit, and remove pizzas and toppings
- **Order Processing** – Create, update, and track orders
- **User Roles** – Owner and Chef roles with different access levels
- **Turbo Streams** – Real-time updates for a dynamic user experience
- **Authentication & Authorization** – Secure access for staff members
- **Cloud Deployment** – Hosted on **Koyeb** with **NeonDB** for PostgreSQL

## Tech Stack
- **Backend:** Ruby on Rails 7 (without Webpacker)
- **Frontend:** Hotwire (Turbo, Stimulus)
- **Database:** PostgreSQL (via **NeonDB**)
- **Deployment:** Koyeb
- **Styling:** Bootstrap 5

## Setup & Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/StackMaster07/pizza-shop.git
   cd pizza-shop
   ```
2. Install dependencies:
   ```sh
   bundle install
   ```
3. Setup the database:
   ```sh
   rails db:create db:migrate db:seed
   ```
4. Start the server:
   ```sh
   rails s
   ```

## Environment Variables
Ensure you set up the following environment variables:
```sh
DATABASE_URL=your_postgresql_url
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key
```

The application is live at:
 **[Pizza Shop on Koyeb](https://vocational-isabelle-individual3-dba185ce.koyeb.app)**

## License
MIT License. Feel free to contribute!
