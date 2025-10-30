from fastapi import FastAPI
from scalar_fastapi import get_scalar_api_reference
from typing import Any

app = FastAPI()

@app.get("/shipment")
def get_shipment():
    return {
        'content': 'wooden table',
        'status': 'in transit',
    }

@app.get("/shipment/latest")
def get_latest_shipment():
    return {
        'id': 101,
        'weight': 15.0,
        'content': 'glassware',
        'status': 'delivered',
    }

@app.get("/shipment/{id}")
def get_shipment_id(id: int) -> dict[str, Any]:
    return {
        'id': id,
        'weight': 12.5,
        'content': 'wooden table',
        'status': 'in transit',
    }



@app.get("/scalar", include_in_schema=False)
def get_scalar_docs():
    return get_scalar_api_reference(
        openapi_url=app.openapi_url,
        title="Scalar API"
    )