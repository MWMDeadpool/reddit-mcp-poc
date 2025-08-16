# Use the official Python image as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Install uv
RUN pip install uv

# Copy the project files into the container
COPY . .

# Install dependencies using uv
RUN uv pip install --system .

# Expose the port the app runs on
EXPOSE 8000

# Run the server
CMD ["uv", "run", "--host", "0.0.0.0", "--port", "8000", "src/server.py"]
