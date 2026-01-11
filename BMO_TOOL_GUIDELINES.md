BMO Tool Creation Guidelines (for _add_tool)

Purpose
- Ensure tools load cleanly with the current CommonJS-based loader
- Prevent recurring errors like "Unexpected token 'export'"
- Provide a consistent interface and robust error handling

Rules
1) Implementation format
- Provide only the async function body for the `implementation` field. Do NOT include module wrappers or exports.
- No `export` or `module.exports` at the top level. The loader injects the wrapper.

2) Parameters and definition
- Always provide a complete parameter schema (type: object, properties, required).
- Describe each parameter clearly.

3) Execution
- Use the `args` object provided by the loader (already parsed).
- Use built-in modules already provided by the runtime (fs, path, child_process as `cp`, https, http). Do not re-require them.
- Return JSON strings only: `JSON.stringify({ success: true, result })` on success; `JSON.stringify({ success: false, error })` on error.
- Always wrap logic in try/catch and surface concise error messages.

4) Code style and structure
- Do not declare nested functions inside the implementation body unless necessary; keep it flat and simple.
- Avoid re-requiring modules or dynamic imports.
- Prefer clear variable names and concise logic.

5) Testing
- After creating a tool with `_add_tool`, immediately call `_reload_tools`.
- Validate with a simple call to ensure the tool loads and returns JSON correctly.

Examples

Definition object (passed to _add_tool):
{
  name: "run_command",
  description: "Execute a shell command and return stdout/stderr/status",
  implementation: "try {\n  const { command, cwd } = args;\n  const opts = { cwd: cwd || process.cwd(), stdio: ['ignore', 'pipe', 'pipe'] };\n  const out = cp.execSync(command, opts).toString();\n  return JSON.stringify({ success: true, result: { stdout: out } });\n} catch (error) {\n  const stderr = error && error.stderr ? error.stderr.toString() : error.message;\n  return JSON.stringify({ success: false, error: stderr });\n}"
}

Parameter schema reminder
- Must include: type, properties, required (the loader handles the wrapper).

Common mistakes to avoid
- Using `export` / `module.exports` in the implementation string.
- Returning raw objects instead of JSON strings.
- Missing try/catch.
- Requiring modules inside the function body.

Notes
- The loader is CommonJS-based; ESM syntax (e.g., `export`) will fail to parse.
