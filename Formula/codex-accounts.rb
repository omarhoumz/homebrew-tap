class CodexAccounts < Formula
  desc "Manage multiple OpenAI Codex CLI accounts"
  homepage "https://github.com/omarhoumz/codex-accounts"
  # The release asset built by git archive, not GitHub's auto-generated source
  # archive: the workflow hashes the asset, and the two differ byte for byte.
  url "https://github.com/omarhoumz/codex-accounts/releases/download/v0.1.0/codex-accounts-0.1.0.tar.gz"
  sha256 "679a2efb6ba93c6fc4d87526f8b81e0defa1c88bace981f03c66611a677ea426"
  license "MIT"

  def install
    libexec.install "lib"
    libexec.install "shell"
    libexec.install "bin" => "tools"
    # The scripts source ../lib/common.sh relative to their own real
    # path, so the bin/ and lib/ pair has to stay adjacent in libexec.
    bin.install_symlink libexec/"tools/codex-switch"
    bin.install_symlink libexec/"tools/codex-run"
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
    assert_match "codex-switch", shell_output("#{bin}/codex-switch --version")
    assert_match "codex-run", shell_output("#{bin}/codex-run --version")
    assert_match "no accounts saved yet",
                 shell_output("CODEX_ACCOUNTS_DIR=#{testpath}/acc #{bin}/codex-switch list")
  end
end
