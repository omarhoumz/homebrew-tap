class Agentic < Formula
  desc "Manage multiple Codex and Cursor Agent CLI accounts"
  homepage "https://github.com/omarhoumz/agentic"
  # The release asset built by git archive, NOT GitHub's auto-generated
  # /archive/refs/tags tarball: the sha256 below is computed from the
  # asset, and the two differ byte for byte.
  url "https://github.com/omarhoumz/agentic/releases/download/v0.1.0/agentic-0.1.0.tar.gz"
  sha256 "1d9abb63ab9e6f34f57968f6a9b8600ed634b7ced03cd2ae3280af54ce31c898"
  license "MIT"

  def install
    libexec.install "lib"
    libexec.install "providers"
    libexec.install "shell"
    libexec.install "completions"
    libexec.install "bin" => "tools"
    # Scripts source ../lib relative to their real path, so bin/ and
    # lib/ must stay adjacent under libexec.
    bin.install_symlink libexec/"tools/agentic"

    zsh_completion.install libexec/"completions/_agentic" => "_agentic"
    bash_completion.install libexec/"completions/agentic.bash" => "agentic"
  end

  def caveats
    <<~EOS
      Optional but recommended - stop bare `codex login` / `agent login`
      from overwriting a managed account:

        agentic shell-init

      That adds a marked block to your shell rc file;
      `agentic shell-init --remove` takes it out again. Homebrew is
      not allowed to edit your dotfiles, which is why this is a
      command rather than automatic.

      When ~/.agentic/cursor exists, shell-init also exports
      AGENT_CLI_CREDENTIAL_STORE=file so bare `agent` follows the
      managed file credential store.
    EOS
  end

  test do
    assert_match "agentic", shell_output("#{bin}/agentic --version")
    assert_match "no account is active",
                 shell_output("AGENTIC_DIR=#{testpath}/acc #{bin}/agentic which codex")
  end
end
