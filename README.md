# StreetBite

StreetBite is a Phoenix LiveView application that allows users to search and discover various food trucks.

---

## Table of Contents

- [Getting Started](#getting-started)
- [Running the Application](#running-the-application)
- [Running the Tests](#running-the-tests)
- [Features](#features)
- [Decisions And Trade-offs](#decisions-and-trade-offs)
- [Future Improvements](#future-improvements)

---

## Getting Started

### Prerequisites

You will need the following tools installed on your machine:

- Elixir version 1.14
- Phoenix version 1.7.2
- PostgreSQL version 14

### Installation

1. Clone the repository:

    ```sh
    git clone https://github.com/paulsullivanjr/street_bite.git
    ```

2. Navigate to the project directory:

    ```sh
    cd street_bite
    ```

3. Fetch the dependencies:

    ```sh
    mix setup
    ```

### Running the Application

To start the Phoenix server:

   ```sh
   mix phx.server or iex -S mix phx.server
```

Now you can visit localhost:4000 from your browser.

### Running the tests

```sh
MIX_ENV=test mix test
```

### Features

- Search for food trucks by location and/or food type.
- List view of food trucks with details such as name, types of food, location, and status.

### Decision-Making Process

In the design phase of this project, my aim was to achieve simplicity without compromising on functionality. I chose Phoenix LiveView for the user interface to leverage its real-time capabilities and maintain a stateful connection with the client. This allowed me to create an interactive user experience without the need for complex client-side JavaScript.

I believed it was essential to offer users the ability to search food trucks based on their location and/or food type. This feature provides the fundamental functionality of the application and forms the basis for potential future enhancements.

### Trade-offs

In the pursuit of simplicity and a rapid development cycle, we made certain trade-offs. Rather than building out a more complex system for real-time data retrieval from an API, I chose to rely on a static dataset for our search functionality. This allowed me to focus on creating a robust and responsive search feature without the added complexity of handling real-time data updates.

While this decision reduces potential data volatility, it does limit the systems ability to reflect real-time changes. I considered this trade-off worthwhile for this initial version of the project, with the understanding that subsequent versions could include enhancements such as real-time API integration for more dynamic data.

If I had more time, I'd work on adding more tests and making the search feature stronger. I would also include more ways to filter the results. This means making sure the app works like it should, improving how users can search for information, and giving them more options to sort and filter their results. These changes would make the app better and easier to use.

### Future Improvements

- Additional search filters (e.g., driving distance, radius).
- An interactive map to display food truck locations.
- Research other data sets to incorporate to enhance available data.
- Retrieve datasets via API
