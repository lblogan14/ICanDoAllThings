"""Structured Schemas for Email Assistant."""
from pydantic import BaseModel, Field
from typing_extensions import TypedDict, Literal
from langgraph.graph import MessagesState


class RouterSchema(BaseModel):
    """Analyze the unread email and route it according to its content."""
    reasoning: str = Field(
        description="Step-by-step reasoning behind the classification."
    )
    classification: Literal['ignore', 'respond', 'notify'] = Field(
        description="The classification of an email: 'ignore' for irrelevant emails,"
        "'notify' for important information that does not need a response,"
        "'respond' for emails that need a reply."
    )


class StateInput(TypedDict):
    # Input state for the graph
    email_input: dict


class State(MessagesState):
    # State for the graph
    email_input: dict
    classification_decision: Literal['ignore', 'respond', 'notify']
    # `messages` field inherited from MessagesState


class EmailData(TypedDict):
    id: str
    thread_id: str
    from_email: str
    subject: str
    page_content: str
    send_time: str
    to_email: str


class UserPreferences(BaseModel):
    """Updated user preferences based on user's feedback."""
    chain_of_thought: str = Field(
        description="Reasoning about which user preferences need to add/update if required."
    )
    user_preferences: str = Field(
        description="Updated user preferences"
    )