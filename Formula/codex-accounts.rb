class CodexAccounts < Formula
  desc "Manage multiple OpenAI Codex CLI accounts"
  homepage "https://github.com/omarhoumz/codex-accounts"
  # The release asset built by git archive, NOT GitHub's auto-generated
  # /archive/refs/tags tarball: the sha256 below is computed from the
  # asset, and the two differ byte for byte. Pointing at the wrong one
  # fails every brew install with a checksum mismatch.
  url "https://github.com/omarhoumz/codex-accounts/releases/download/v0.1.4/codex-accounts-0.1.4.tar.gz"
  sha256 "704e973a29d54b1145e4ff94b7eb92fd15c7f4c1a56910276ee4d4ea1a726b8f"
  license "MIT"

  def install
    libexec.install "lib"
    libexec.install "shell"
    libexec.install "completions"
    libexec.install "bin" => "tools"
    # The scripts source ../lib/common.sh relative to their own real
    # path, so the bin/ and lib/ pair has to stay adjacent in libexec.
    bin.install_symlink libexec/"tools/codex-accounts"
    bin.install_symlink libexec/"tools/codex-switch"
    bin.install_symlink libexec/"tools/codex-run"

    # One completion file serves all three commands.
    zsh_completion.install libexec/"completions/_codex-accounts" => "_codex-accounts"
    bash_completion.install libexec/"completions/codex-accounts.bash" => "codex-accounts"
  end

  def caveats
    <<~EOS
      Optional but recommended - stop a bare `codex login` from overwriting
      another account:

        codex-switch shell-init

      That adds one line to your shell rc file, and `codex-switch shell-init
      --remove` takes it out again. Homebrew is not allowed to edit your
      dotfiles, which is why this is a command rather than automatic.

      Without it everything still works: the tools detect a credential that a
      bare `codex login` has broken and refuse to launch Codex with it. With
      it, that login is intercepted so nothing breaks in the first place.
    EOS
  end

  test do
    assert_match "codex-accounts", shell_output("#{bin}/codex-accounts --version")
    assert_match "codex-switch", shell_output("#{bin}/codex-switch --version")
    assert_match "codex-run", shell_output("#{bin}/codex-run --version")
    assert_match "no accounts saved yet",
                 shell_output("CODEX_ACCOUNTS_DIR=#{testpath}/acc #{bin}/codex-switch list")
    # The umbrella must reach codex-run, which lives beside it in libexec.
    assert_match "run <account>",
                 shell_output("#{bin}/codex-accounts run 2>&1", 1)
  end
end
