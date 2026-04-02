---
name: obsidian-markdown
description: Create and edit Obsidian Flavored Markdown with wikilinks, embeds, callouts, properties, and other Obsidian-specific syntax. Use when working with .md files in Obsidian, or when the user mentions wikilinks, callouts, frontmatter, tags, embeds, or Obsidian notes.
user_invocable: false
---

# Obsidian Flavored Markdown

This skill teaches Obsidian-specific extensions to Markdown, assuming familiarity with standard Markdown features like headings, lists, and code blocks.

## Workflow: Creating an Obsidian Note

1. **Add frontmatter** with properties (title, tags, aliases) at the top
2. **Write content** using standard Markdown plus Obsidian extensions
3. **Link related notes** using wikilinks for vault notes; standard links for external URLs
4. **Embed content** from other notes, images, or PDFs
5. **Add callouts** for highlighted information
6. **Verify** rendering in Obsidian's reading view

## Key Syntax Elements

**Wikilinks:** `[[Note Name]]`, `[[Note Name|Display Text]]`, `[[Note Name#Heading]]`

**Embeds:** `![[Note Name]]`, `![[image.png|300]]`, `![[document.pdf#page=3]]`

**Callouts:**
```
> [!note]
> Content here
```

Supported types: note, tip, warning, danger, info, abstract, todo, example, quote, bug, success, failure, question

**Properties (Frontmatter):**
```yaml
---
title: My Note
tags: [project, active]
aliases: [alternate-name]
---
```

**Tags:** `#tag`, `#nested/tag`

**Highlighting:** `==text==`

**Math:** `$e^{i\pi}$` (inline) or `$$..$$` (block)

**Comments:** `%%hidden text%%`

**Footnotes:** `Text[^1]` with `[^1]: Note`

## References

- [Obsidian Flavored Markdown](https://help.obsidian.md/obsidian-flavored-markdown)
- [Internal links](https://help.obsidian.md/links)
- [Embed files](https://help.obsidian.md/embeds)
- [Callouts](https://help.obsidian.md/callouts)
- [Properties](https://help.obsidian.md/properties)
