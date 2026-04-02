---
name: mcp-builder
description: Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK).
user_invocable: false
---

## Overview

Create MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. The quality of an MCP server is measured by how well it enables LLMs to accomplish real-world tasks.

## Process

### Phase 1: Deep Research and Planning

#### 1.1 Understand Modern MCP Design

**API Coverage vs. Workflow Tools:**
Balance comprehensive API endpoint coverage with specialized workflow tools. When uncertain, prioritize comprehensive API coverage.

**Tool Naming and Discoverability:**
Use consistent prefixes (e.g., `github_create_issue`, `github_list_repos`) and action-oriented naming.

**Context Management:**
Design tools that return focused, relevant data with pagination support.

**Actionable Error Messages:**
Error messages should guide agents toward solutions with specific suggestions.

#### 1.2 Study MCP Protocol Documentation

Start with the sitemap: `https://modelcontextprotocol.io/sitemap.xml`
Fetch specific pages with `.md` suffix (e.g., `https://modelcontextprotocol.io/specification/draft.md`).

#### 1.3 Study Framework Documentation

**Recommended stack:**
- **Language**: TypeScript (high-quality SDK support) or Python (FastMCP)
- **Transport**: Streamable HTTP for remote servers, stdio for local servers

**Load framework documentation:**
- **MCP Best Practices**: [reference/mcp_best_practices.md](./reference/mcp_best_practices.md)
- **TypeScript Guide**: [reference/node_mcp_server.md](./reference/node_mcp_server.md)
- **Python Guide**: [reference/python_mcp_server.md](./reference/python_mcp_server.md)
- **TypeScript SDK**: `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`
- **Python SDK**: `https://raw.githubusercontent.com/modelcontextprotocol/python-sdk/main/README.md`

#### 1.4 Plan Your Implementation

Review the service's API documentation to identify key endpoints, authentication requirements, and data models.

### Phase 2: Implementation

1. Set up project structure (see language-specific guides)
2. Implement core infrastructure (API client, error handling, pagination)
3. Implement tools with:
   - Input Schema (Zod/Pydantic)
   - Output Schema where possible
   - Tool annotations (readOnlyHint, destructiveHint, idempotentHint, openWorldHint)
   - Comprehensive descriptions

### Phase 3: Review and Test

- Review for DRY, consistent error handling, full type coverage
- Build and test with MCP Inspector: `npx @modelcontextprotocol/inspector`

### Phase 4: Create Evaluations

Create 10 complex, realistic evaluation questions. See [reference/evaluation.md](./reference/evaluation.md).

## Reference Files

- [MCP Best Practices](./reference/mcp_best_practices.md)
- [TypeScript Implementation Guide](./reference/node_mcp_server.md)
- [Python Implementation Guide](./reference/python_mcp_server.md)
- [Evaluation Guide](./reference/evaluation.md)
