from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health() -> None:
    response = client.get('/health')
    assert response.status_code == 200
    body = response.json()
    assert body['status'] == 'ok'
    assert body['version'] == '0.1.0'


def test_status_identifies_as_ai_agent() -> None:
    response = client.get('/status')
    assert response.status_code == 200
    assert response.json()['identity'] == 'ai-agent'


def test_agent_card_is_machine_readable() -> None:
    response = client.get('/.well-known/agent-card.json')
    assert response.status_code == 200
    body = response.json()
    assert body['name']
    assert body['capabilities']['research'] is True
    assert any(skill['id'] == 'collaboration' for skill in body['skills'])


def test_tasks_are_not_falsely_claimed_as_executed() -> None:
    response = client.post('/tasks', json={'objective': 'Review bootstrap security'})
    assert response.status_code == 202
    body = response.json()
    assert body['accepted'] is False
    assert body['state'] == 'bootstrap_not_ready'
