from fastapi import FastAPI
from scalar_fastapi import get_scalar_api_reference
from typing import Any

app = FastAPI()

shipments = {
    12701: {
        'weight': 15.0,
        'content': 'glassware',
        'status': 'delivered',
    },
    12702: {
        'weight': 5.5,
        'content': 'books',
        'status': 'in transit',
    },
    12703: {
        'weight': 2.3,
        'content': 'clothes',
        'status': 'pending',
    },
    12704: {
        'weight': 7.8,
        'content': 'electronics',
        'status': 'delivered',
    },
    12705: {
        'weight': 3.4,
        'content': 'toys',
        'status': 'in transit',
    },
    12706: {
        'weight': 12.0,
        'content': 'furniture',
        'status': 'pending',
    }
}

@app.get("/shipment")
def get_shipment():
    return {
        'content': 'wooden table',
        'status': 'in transit',
    }


@app.get("/shipment/latest")
def get_latest_shipment():
    id = max(shipments.keys())
    return shipments[id]


@app.get("/shipment/{id}")
def get_shipment_id(id: int) -> dict[str, Any]:
    if id not in shipments:
        return {
            "detail": "Given ID does not exist!"
        }

    return shipments[id]



@app.get("/scalar", include_in_schema=False)
def get_scalar_docs():
    return get_scalar_api_reference(
        openapi_url=app.openapi_url,
        title="Scalar API"
    )