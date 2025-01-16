# Use the official lightweight Python image.
FROM python:3.10

# Expose port for Cloud Run
EXPOSE 8080

# Set application working directory
ENV APP_HOME /app
WORKDIR $APP_HOME

# Copy local code to the container
COPY . ./

# Set Streamlit environment variables
ENV STREAMLIT_SERVER_PORT=8080
ENV STREAMLIT_SERVER_ENABLE_CORS=false
ENV STREAMLIT_GLOBAL_DEVELOPMENTMODE=false

# Set Guardrails API token directly as an environment variable
ENV GUARDRAILS_API_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnb29nbGUtb2F1dGgyfDEwNzM3MDkyOTMxODk4MjcxMzkxOSIsImFwaUtleUlkIjoiOGY5YWU3MGUtZmUxNC00ZmZlLTg4MWItZTM5ZTY5MTQ3NmI3Iiwic2NvcGUiOiJyZWFkOnBhY2thZ2VzIiwicGVybWlzc2lvbnMiOltdLCJpYXQiOjE3MzM3MzYxMjgsImV4cCI6NDg4NzMzNjEyOH0.Yn3xSjstVy3DxGXKeZZPZEWNuYo28PifxloMS4i8bJA

# Install Python dependencies
RUN pip install -r requirements.txt

# Configure Guardrails non-interactively with the API token
RUN guardrails configure --token $GUARDRAILS_API_TOKEN --enable-metrics --enable-remote-inferencing

# Install required Guardrails validators
RUN guardrails hub install hub://guardrails/toxic_language

# Run the application
CMD streamlit run --server.port $STREAMLIT_SERVER_PORT --server.enableCORS $STREAMLIT_SERVER_ENABLE_CORS --global.developmentMode $STREAMLIT_GLOBAL_DEVELOPMENTMODE app.py