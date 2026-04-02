# Python MCP Server Guide

## Key Imports
```python
from mcp.server.fastmcp import FastMCP
from pydantic import BaseModel, Field, field_validator, ConfigDict
from typing import Optional, List, Dict, Any
from enum import Enum
import httpx
```

## Server Initialization
```python
mcp = FastMCP("service_mcp")
```

## Tool Registration
```python
@mcp.tool(
    name="service_tool_name",
    annotations={
        "title": "Human-Readable Title",
        "readOnlyHint": True,
        "destructiveHint": False,
        "idempotentHint": True,
        "openWorldHint": False
    }
)
async def service_tool_name(params: InputModel) -> str:
    '''Tool description becomes the description field.'''
    pass
```

## Pydantic v2 Models
```python
class SearchInput(BaseModel):
    model_config = ConfigDict(str_strip_whitespace=True, validate_assignment=True, extra='forbid')

    query: str = Field(..., description="Search string", min_length=2, max_length=200)
    limit: Optional[int] = Field(default=20, ge=1, le=100)
    offset: Optional[int] = Field(default=0, ge=0)

    @field_validator('query')
    @classmethod
    def validate_query(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("Query cannot be empty")
        return v.strip()
```

## Context Injection
```python
from mcp.server.fastmcp import FastMCP, Context

@mcp.tool()
async def advanced_tool(query: str, ctx: Context) -> str:
    await ctx.report_progress(0.5, "Processing...")
    await ctx.log_info("Info message")
    return result
```

## Resources
```python
@mcp.resource("file://documents/{name}")
async def get_document(name: str) -> str:
    return read_file(name)
```

## Lifespan Management
```python
from contextlib import asynccontextmanager

@asynccontextmanager
async def app_lifespan():
    db = await connect()
    yield {"db": db}
    await db.close()

mcp = FastMCP("service_mcp", lifespan=app_lifespan)
```

## Transport
```python
# stdio (default)
mcp.run()

# Streamable HTTP
mcp.run(transport="streamable_http", port=8000)
```

## Quality Checklist
- All tools use `@mcp.tool(name=..., annotations=...)`
- Pydantic BaseModel with Field() for all inputs
- Comprehensive docstrings with Args/Returns/Examples
- Type hints throughout
- Async/await for all I/O
- Common functionality extracted into reusable functions
- Error handling with specific exception types (httpx.HTTPStatusError)
