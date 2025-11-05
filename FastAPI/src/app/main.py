from fastapi import FastAPI, HTTPException, status
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


# Endpoint to get shipment details by ID (query parameter)
@app.get("/shipment")
def get_shipment(id: int | None = None) -> dict[str, Any]:
    if not id:
        id = max(shipments.keys())
        return shipments[id]
        
    if id not in shipments:
        # this is new
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Given ID does not exist!"
        )
    return shipments[id]


@app.get("/shipment/latest")
def get_latest_shipment():
    id = max(shipments.keys())
    return shipments[id]



@app.post("/shipment")
def submit_shipment(content: str, weight: float) -> dict[str, int]:
    if weight > 25:
        raise HTTPException(
            status_code=status.HTTP_406_NOT_ACCEPTABLE,
            detail="Maximum weight limit is 25 units."
        )

    # Find the next available ID
    new_id = max(shipments.keys()) + 1
    # Create a new shipment entry
    shipments[new_id] = {
        'weight': weight,
        'content': content,
        'status': 'placed'
    }

    return {'id': new_id}


@app.get("/shipment/{field}")
def get_shipment_field(field: str, id: int) -> dict[str, Any]:
    return {
        field: shipments[id][field]
    }


@app.put("/shipment")
def shipment_update(
    id: int, content: str, weight: float, status: str
) -> dict[str, Any]:
    shipments[id] = {
        'weight': weight,
        'content': content,
        'status': status,
    }

    return shipments[id]


@app.patch("/shipment")
def patch_shipment(
    id: int, 
    content: str | None = None, 
    weight: float | None = None, 
    status: str | None = None
):
    shipment = shipments[id]
    # Update the provided fields only
    if content:
        shipment['content'] = content
    if weight:
        shipment['weight'] = weight
    if status:
        shipment['status'] = status

    shipments[id] = shipment
    return shipment


@app.get("/scalar", include_in_schema=False)
def get_scalar_docs():
    return get_scalar_api_reference(
        openapi_url=app.openapi_url,
        title="Scalar API"
    )