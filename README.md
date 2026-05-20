# InsightFlow: Autonomous Business Decision-Making System

InsightFlow is an advanced AI-powered platform designed to autonomously ingest unstructured business data (such as PDFs, web articles, and raw text), extract critical facts, analyze business impacts, and simulate executable actions. Built for the Innovista Hackathon, this system bridges the gap between raw data and actionable business intelligence using a Multi-Agent architecture.

---

## 🏗️ 1. Overall Design & Architecture

The solution is divided into a robust backend AI pipeline and a user-friendly cross-platform frontend:

- **Frontend (Flutter):** A seamless mobile and web interface where users can upload business reports (Text, URL, or PDF). It displays the processed data cleanly in structured formats (Facts, Insights, Impact, Recommended Actions, and Simulations).
- **Backend (Python / FastAPI):** The core engine that orchestrates the AI agents. It receives the unstructured data, passes it through a multi-agent pipeline, and returns a strictly formatted JSON response.
- **Database (MongoDB):** All generated insights and simulations are persisted asynchronously to a MongoDB cluster for historical tracking and auditing.
- **Deployment (Google Cloud Run):** The backend is fully containerized using Docker and deployed on Google Cloud Run for serverless, scalable execution.

---

## 🤖 2. Agents Developed

The system utilizes the latest **OpenAI Agents SDK** to implement a sequential, multi-agent handoff architecture. This ensures deterministic, high-quality reasoning by dividing complex tasks among specialized agents:

1. **Content Extractor Agent:**
   - **Role:** Data Ingestion & Formatting.
   - **Responsibility:** Ingests the cleaned text/PDF and extracts specific, numerical, and factual data points without generic summarization.
   - **Handoff:** Transfers the pure facts to the Analyzer Agent.

2. **Insight & Impact Analyzer Agent:**
   - **Role:** Deep Reasoning.
   - **Responsibility:** Reviews the extracted facts to find meaningful patterns (Insights). It then calculates the real-world business consequences (Impact Analysis) and formulates a strategic recommendation.
   - **Handoff:** Transfers the analysis to the Action Agent.

3. **Action & Simulation Agent:**
   - **Role:** Execution & Tool Calling.
   - **Responsibility:** Receives the recommendation and uses **Function Calling (Tools)** to simulate the execution of that action (e.g., triggering a CRM update or sending a notification). It compiles the final 6-field structured JSON payload for the frontend.

---

## 🔌 3. Mock & Real APIs Used

### Real APIs
1. **OpenRouter / OpenAI API:** Used to power the language models (`gpt-oss-120b:free` or similar) via the OpenAI Agents SDK for deep reasoning and tool execution.
2. **MongoDB Atlas API:** The backend uses `Motor AsyncIO` to connect to a real, cloud-hosted MongoDB cluster to insert records into `insights_collection`.

### Mock / Internal APIs
1. **FastAPI Endpoints:** 
   - `POST /analyze`: The primary endpoint that accepts `multipart/form-data` (text, url, or pdf) and triggers the multi-agent pipeline.
2. **Simulated Tools (Function Calling):** The Action Agent has access to simulated internal APIs to prove the concept of autonomous execution:
   - `simulate_dashboard_update()`
   - `simulate_notification()`
   - `simulate_crm_update()`

---

## 🔗 4. Integrations Implemented

1. **Flutter to FastAPI (Cloud Run):** The Dart `ApiService` seamlessly integrates with the Google Cloud Run backend via HTTP multipart requests, capable of handling binary PDF uploads and text.
2. **Backend to MongoDB:** Fully asynchronous integration using the `Motor` driver. The system automatically injects timestamps and collection routing based on the agent's output.
3. **Multi-Agent Handoffs:** Integration of the `openai-agents` SDK to allow AI agents to independently decide when their task is complete and transfer their memory/context to the next agent in the pipeline.
4. **Web Scraping / PDF Parsing:** Integration of `PyMuPDF` and `BeautifulSoup` in the pre-processing layer to normalize various unstructured file formats before they reach the LLM.

---

## 🚀 5. Getting Started

### Backend Setup
1. Navigate to the `/backend` directory.
2. Install dependencies: `uv pip install -r pyproject.toml`
3. Add a `.env` file with `OPENROUTER_API_KEY` and `DATABASE_URL`.
4. Run locally: `uvicorn server:app --reload`
5. *Or deploy to GCP:* `gcloud run deploy --source .`

### Frontend Setup
1. Navigate to the `/frontend` directory.
2. Install dependencies: `flutter pub get`
3. Run on Chrome: `flutter run -d chrome`
4. Build APK: `flutter build apk --release`
