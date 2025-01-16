from nemoguardrails import LLMRails, RailsConfig
import os
from dotenv import load_dotenv
from openai import OpenAI


# Load environment variables
load_dotenv()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


def Nvidia_gradrails_text(vAR_input):
    try:
        # Load the guardrails configuration
        config_path = os.getenv("NVIDIA_GUARDRAILS_CONFIG_PATH", "./src/NVIDIA")
        config = RailsConfig.from_path(config_path)
        rails = LLMRails(config)

        # Generate a response with content moderation
        response = rails.generate(messages=[{"role": "user", "content": vAR_input}])
        print(response["content"])
        return response["content"]
    except Exception as e:
        print(f"An error occurred: {e}")
        pass