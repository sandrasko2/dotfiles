# Node/TypeScript MCP Server Guide

## Key Imports
```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
```

## Server Initialization
```typescript
const server = new McpServer({ name: "service-mcp-server", version: "1.0.0" });
```

## Tool Registration
Use `server.registerTool()` (NOT deprecated `server.tool()`):

```typescript
server.registerTool(
  "tool_name",
  {
    title: "Tool Display Name",
    description: "What the tool does",
    inputSchema: { param: z.string() },
    outputSchema: { result: z.string() },
    annotations: { readOnlyHint: true, destructiveHint: false }
  },
  async ({ param }) => ({
    content: [{ type: "text", text: JSON.stringify(output) }],
    structuredContent: output
  })
);
```

## Project Structure
```
{service}-mcp-server/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── types.ts
│   ├── tools/
│   ├── services/
│   ├── schemas/
│   └── constants.ts
└── dist/
```

## Zod Schemas
```typescript
const SearchSchema = z.object({
  query: z.string().min(2).max(200).describe("Search string"),
  limit: z.number().int().min(1).max(100).default(20),
  offset: z.number().int().min(0).default(0)
}).strict();
```

## Transport Options

**Streamable HTTP (remote):**
```typescript
const app = express();
app.post('/mcp', async (req, res) => {
  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: undefined,
    enableJsonResponse: true
  });
  res.on('close', () => transport.close());
  await server.connect(transport);
  await transport.handleRequest(req, res, req.body);
});
```

**stdio (local):**
```typescript
const transport = new StdioServerTransport();
await server.connect(transport);
```

## Package Configuration
- `"type": "module"` in package.json
- `"strict": true` in tsconfig.json
- Dependencies: `@modelcontextprotocol/sdk`, `zod`, `axios`
- Always run `npm run build` before considering implementation complete

## Quality Checklist
- All tools use `registerTool` with title, description, inputSchema, annotations
- Zod schemas with `.strict()` enforcement
- No `any` types — use `unknown` or proper types
- Async/await for all I/O
- Common functionality extracted into reusable functions
- CHARACTER_LIMIT constant (25000) for response truncation
