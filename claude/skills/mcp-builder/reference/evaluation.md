# MCP Server Evaluation Guide

## Overview

Create evaluations to test whether LLMs can effectively use your MCP server to answer realistic, complex questions. Quality is measured by how well tools enable LLMs to accomplish tasks, not by API coverage.

## Requirements

- Create exactly 10 questions
- All operations must be READ-ONLY, INDEPENDENT, NON-DESTRUCTIVE, IDEMPOTENT
- Questions should require potentially dozens of tool calls
- Answers must be single, verifiable values (string comparison)

## Question Design

Questions should be:
- **Complex**: Requiring multiple sequential steps and deep exploration
- **Realistic**: Based on real use cases humans would care about
- **Independent**: Each stands alone
- **Stable**: Answers won't change over time
- **Difficult**: Not solvable through simple keyword searches

## Process

1. **Tool Inspection**: List available tools, understand capabilities
2. **Content Exploration**: Use READ-ONLY operations to explore data
3. **Question Generation**: Create 10 complex, realistic questions
4. **Answer Verification**: Solve each question yourself to verify

## Output Format

```xml
<evaluation>
  <qa_pair>
    <question>Your complex question here</question>
    <answer>verifiable-answer</answer>
  </qa_pair>
  <!-- 9 more qa_pairs -->
</evaluation>
```

## Running Evaluations

```bash
python scripts/evaluation.py \
  --transport stdio \
  --server-command "python your_server.py" \
  --eval-file evaluations.xml \
  --output results.json
```

Supports stdio, SSE, and HTTP transports.
