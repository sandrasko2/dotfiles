# MCP Server Best Practices

## Server Naming
- **Python**: `{service}_mcp` (e.g., `slack_mcp`)
- **Node/TypeScript**: `{service}-mcp-server` (e.g., `slack-mcp-server`)

## Tool Naming
- Use snake_case with service prefix: `{service}_{action}_{resource}`
- Example: `slack_send_message`, `github_create_issue`

## Response Formats
- Support both JSON and Markdown
- JSON for programmatic processing, Markdown for human readability

## Pagination
- Always respect `limit` parameter
- Return `has_more`, `next_offset`, `total_count`
- Default to 20-50 items

## Transport
- **Streamable HTTP**: For remote servers, multi-client scenarios
- **stdio**: For local integrations, command-line tools
- Avoid SSE (deprecated)

| Criterion | stdio | Streamable HTTP |
|-----------|-------|-----------------|
| Deployment | Local | Remote |
| Clients | Single | Multiple |
| Complexity | Low | Medium |

## Security
- Use OAuth 2.1 or API keys in environment variables
- Sanitize file paths, validate URLs, prevent command injection
- Use schema validation (Pydantic/Zod) for all inputs
- For local streamable HTTP: bind to 127.0.0.1, validate Origin header

## Tool Annotations

| Annotation | Type | Default | Description |
|-----------|------|---------|-------------|
| readOnlyHint | boolean | false | Tool does not modify its environment |
| destructiveHint | boolean | true | Tool may perform destructive updates |
| idempotentHint | boolean | false | Repeated calls same args no additional effect |
| openWorldHint | boolean | true | Tool interacts with external entities |

## Error Handling
- Use standard JSON-RPC error codes
- Report tool errors within result objects
- Provide helpful, actionable error messages
- Don't expose internal implementation details
