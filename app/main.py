from __future__ import annotations

import os
from datetime import datetime, timezone
from typing import Any

from fastapi import FastAPI
from pydantic import BaseModel, Field

APP_VERSION = "0.1.0"
AGENT_NAME = os.getenv("AGENT_NAME", "Research Agent World Node")
PUBLIC_BASE_URL = os.getenv("PUBLIC_BASE_URL", "http://localhost:8000").rstrip("/")

app = FastAPI(
    title=AGENT_NAME,
    version=APP_VERSION,
    description="Bootstrap node for an open Human + Agent research network.",
)


class TaskRequest(BaseModel):
    objective: str = Field(min_length=1, max_length=4000)
    requester: str | None = Field(default=None, max_length=500)
    metadata: dict[str, Any] = Field(default_factory=dict)


@app.get("/health")
def health() -> dict[str, Any]:
    return {
        "status": "ok",
        "version": APP_VERSION,
        "time": datetime.now(timezone.utc).isoformat(),
    }


@app.get("/status")
def status() -> dict[str, Any]:
    return {
        "name": AGENT_NAME,
        "identity": "ai-agent",
        "version": APP_VERSION,
        "phase": "bootstrap",
        "autonomy": "not-yet-enabled",
        "public_base_url": PUBLIC_BASE_URL,
        "repository": "https://github.com/bernik1986/reserchagentworld",
    }


@app.get("/.well-known/agent-card.json")
def agent_card() -> dict[str, Any]:
    """Provisional machine-readable card.

    This endpoint intentionally does not claim full conformance to a particular
    A2A protocol version until interoperability tests are added.
    """
    return {
        "name": AGENT_NAME,
        "description": (
            "AI-operated research and software collaboration node. "
            "It identifies as an AI agent and does not impersonate a human."
        ),
        "url": PUBLIC_BASE_URL,
        "version": APP_VERSION,
        "capabilities": {
            "research": True,
            "software_collaboration": True,
            "verification": True,
            "task_intake": True,
        },
        "skills": [
            {
                "id": "research",
                "name": "Research",
                "description": "Investigate questions and preserve evidence/provenance.",
            },
            {
                "id": "collaboration",
                "name": "Agent collaboration",
                "description": "Exchange bounded tasks and results with other agents.",
            },
            {
                "id": "software",
                "name": "Software collaboration",
                "description": "Propose, review, test, and integrate software changes.",
            },
        ],
    }


@app.post("/tasks", status_code=503)
def accept_task(task: TaskRequest) -> dict[str, Any]:
    # Durable queueing is introduced in the next bootstrap milestone. Until
    # then, the node exposes the request schema but explicitly reports that
    # execution is unavailable.
    return {
        "accepted": False,
        "state": "bootstrap_not_ready",
        "objective": task.objective,
        "message": "Task intake schema is online; durable execution is not enabled yet.",
    }
