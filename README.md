# HomeOwners Flutter APP

This is a guide to set up a Flask server and a Flutter app for communication. Please follow the steps below to get started.

## Prerequisites

Before proceeding, make sure you have the following installed:

1. Python (version 3.11.x) and Flask
2. Flutter (version 3.10.x)

## Flask Server Setup

1. Install Python and Flask:
   - If you don't have Python installed, download it from the official website: https://www.python.org/downloads/
   - To install Flask, open a terminal (command prompt on Windows) and run the following command:
     ```
     pip install Flask
     ```

2. Run the Flask server by running the following command in the terminal:
   ```
   python3 server/script.py
   ```

3. Ensure to replace the BASE_URL inside .env file with your IP address. If you are running Android device you can find your IP address by running the following command in the terminal:
   ```
   ifconfig
   ```
If not you can use 127.0.0.1