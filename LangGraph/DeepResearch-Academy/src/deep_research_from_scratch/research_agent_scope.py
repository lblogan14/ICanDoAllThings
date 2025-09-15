"""User Clarification and Research Brief Generation.

Description: This module implements the scoping phase of the research agent workflow, where we
1. assess if the user's request needs clarification, and
2. generate a detailed research brief from the conversation.

The workflow uses structured output to make deterministic decisions about whether sufficient context exists to proceed with research.
"""
from datetime import datetime
from typing_extensions import Literal

from langchain.chat_models import init_chat_model
from langchain_core.messages import HumanMessage, AIMessage, get_buffer_string
from langgraph.graph import StateGraph, START, END
from langgraph.types import Command

from deep_research_from_scratch.prompts import clarify_with_user_instructions, transform_messages_into_research_topic_prompt
from deep_research_from_scratch.state_scope import AgentState, AgentInputState, ClarifyWithUser, ResearchQuestion


# ===== UTILITY FUNCTIONS =====

def get_today_str() -> str:
    """Get current date in a human-readable format."""
    # Use cross-platform format or handle Windows specifically
    today = datetime.now()
    return today.strftime("%a %b %d, %Y").replace(" 0", " ")

# ===== CONFIGURATION =====
# Initialize a chat model
model = init_chat_model(model="openai:gpt-4.1", temperature=0)

# ===== WORKFLOW NODES =====

def clarify_with_user(state: AgentState) -> Command[Literal['write_research_brief', '__end__']]:
    """Determine if the user's request contains sufficient information to proceed with research.
    Use structured output to make deterministic decisions and avoid halluciation.
    Route to either research brief generation or end with a clarification question.
    """
    # Set up structured output model
    structured_output_model = model.with_structured_output(ClarifyWithUser)
    # Invoke the model with clarification prompt
    response = structured_output_model.invoke([
        HumanMessage(content=clarify_with_user_instructions.format(
            messages=get_buffer_string(messages=state['messages']),
            date=get_today_str()
        ))
    ])

    # Route based on clarification need
    if response.need_clarification:
        # Need to clarify with user - end workflow and ask question
        return Command(
            goto=END,
            update={'messages': [AIMessage(content=response.question)]}
        )
    else:
        return Command(
            goto='write_research_brief',
            update={'messages': [AIMessage(content=response.verification)]}
        )


def write_research_brief(state: AgentState):
    """Transform the conversation history into a comprehensive research brief.
    Use structured output to ensure the brief follows the required format
    and contain all necessary details for effective research.
    """
    # Set up structured output model
    structured_output_model = model.with_structured_output(ResearchQuestion)
    # Generate research brief from conversation history
    response = structured_output_model.invoke([
        HumanMessage(content=transform_messages_into_research_topic_prompt.format(
            messages=get_buffer_string(messages=state.get('messages', [])),
            date=get_today_str()
        ))
    ])

    # Update state with generated research brief and pass it to the supervisor
    return {
        'research_brief': response.research_brief,
        'supervisor_messages': [HumanMessage(content=f"{response.research_brief}.")]
    }


# ===== GRAPH CONSTRUCTION =====
# Build the scoping graph
deep_researcher_builder = StateGraph(AgentState, input_schema=AgentInputState)

# Add nodes
deep_researcher_builder.add_node('clarify_with_user', clarify_with_user)
deep_researcher_builder.add_node('write_research_brief', write_research_brief)
# Add edges
deep_researcher_builder.add_edge(START, 'clarify_with_user')
deep_researcher_builder.add_edge('write_research_brief', END)
# Compile the graph
scope_research = deep_researcher_builder.compile()
