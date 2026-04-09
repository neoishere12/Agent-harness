#!/usr/bin/env bash
set -euo pipefail

repo_owner="neoishere12"
repo_name="Agent-harness"
repo_ref="main"
skill_name="designing-agent-harnesses"
tarball_url="https://codeload.github.com/${repo_owner}/${repo_name}/tar.gz/refs/heads/${repo_ref}"

usage() {
  cat <<'EOF'
Usage: install.sh [codex|claude|cursor|cursor-rule|cursor-skill]

  codex         Install the skill into $CODEX_HOME/skills or ~/.codex/skills
  claude        Install the skill into ~/.claude/skills
  cursor        Install the Cursor project-rule equivalent into ./.cursor/rules
  cursor-rule   Install the Cursor project-rule equivalent into ./.cursor/rules
  cursor-skill  Install the skill into ./.cursor/skills
EOF
}

target="${1:-}"

if [[ -z "${target}" ]]; then
  usage
  exit 1
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

curl -fsSL "${tarball_url}" | tar -xz -C "${tmp_dir}"

source_dir="${tmp_dir}/${repo_name}-${repo_ref}/${skill_name}"

if [[ ! -d "${source_dir}" ]]; then
  echo "Could not find ${skill_name} in downloaded archive." >&2
  exit 1
fi

install_folder() {
  local destination_root="$1"

  mkdir -p "${destination_root}"
  rm -rf "${destination_root}/${skill_name}"
  cp -R "${source_dir}" "${destination_root}/"
}

strip_frontmatter() {
  local input_file="$1"

  awk '
    NR == 1 && $0 == "---" { in_frontmatter = 1; next }
    in_frontmatter && $0 == "---" { in_frontmatter = 0; next }
    !in_frontmatter { print }
  ' "${input_file}"
}

case "${target}" in
  codex)
    codex_home="${CODEX_HOME:-${HOME}/.codex}"
    install_folder "${codex_home}/skills"
    echo "Installed ${skill_name} to ${codex_home}/skills/${skill_name}"
    echo "Restart Codex to pick up the new skill."
    ;;
  claude)
    install_folder "${HOME}/.claude/skills"
    echo "Installed ${skill_name} to ${HOME}/.claude/skills/${skill_name}"
    echo "Restart Claude Code to pick up the new skill."
    ;;
  cursor|cursor-rule)
    cursor_rules_dir="${PWD}/.cursor/rules"
    cursor_support_dir="${cursor_rules_dir}/${skill_name}-support"

    mkdir -p "${cursor_rules_dir}"
    rm -rf "${cursor_support_dir}" "${cursor_rules_dir}/${skill_name}.mdc"
    mkdir -p "${cursor_support_dir}"

    cp -R "${source_dir}/agents" "${cursor_support_dir}/"
    cp -R "${source_dir}/references" "${cursor_support_dir}/"

    {
      cat <<'EOF'
---
description: Use when designing, refining, or debugging long-running coding-agent harnesses for software work, especially when agents drift on multi-hour tasks, under-scope from short prompts, miss last-mile behavior, or need better planning, observability, repository context, and mechanical guardrails.
alwaysApply: false
---

EOF
      strip_frontmatter "${source_dir}/SKILL.md"
      cat <<EOF

## Attached References

@${skill_name}-support/references/harness-artifacts.md
@${skill_name}-support/references/repository-layout.md
@${skill_name}-support/references/source-synthesis.md
@${skill_name}-support/agents/openai.yaml
EOF
    } > "${cursor_rules_dir}/${skill_name}.mdc"

    echo "Installed the Cursor rule to ${cursor_rules_dir}/${skill_name}.mdc"
    echo "Installed supporting files to ${cursor_support_dir}"
    echo "Reopen Cursor or start a new Agent chat in this project to load the rule."
    ;;
  cursor-skill)
    cursor_skills_dir="${PWD}/.cursor/skills"
    install_folder "${cursor_skills_dir}"
    echo "Installed ${skill_name} to ${cursor_skills_dir}/${skill_name}"
    echo "Reopen Cursor or start a new Agent chat in this project to load the skill."
    ;;
  *)
    usage
    exit 1
    ;;
esac
