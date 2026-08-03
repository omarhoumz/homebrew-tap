class Portwho < Formula
  desc "See which project owns each localhost port — project name, worktree, docker container, and a clickable URL."
  homepage "https://github.com/omarhoumz/portwho"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.1/portwho-aarch64-apple-darwin.tar.xz"
      sha256 "983af62107951cdea33091a0e6050560f96c6c188019eaa9526f702b9d0c846e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.1/portwho-x86_64-apple-darwin.tar.xz"
      sha256 "beabcc08ede5c700bbfdc663f0856ef96193f7f1b0dcf4a9ebd77ecb6dcfdc9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.1/portwho-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f408f0671327dd33ad463eaa4c40b69e2c7fc5210ad02d5fcbd36d6a1661165"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.1/portwho-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "45bb37215199af30be1772a0a3c8418b151caf0ad7b910e710c3aad4e05836a7"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "portwho" if OS.mac? && Hardware::CPU.arm?
    bin.install "portwho" if OS.mac? && Hardware::CPU.intel?
    bin.install "portwho" if OS.linux? && Hardware::CPU.arm?
    bin.install "portwho" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!
    # Added by .github/workflows/add-completions.yml because the
    # formula generator has no hook for installing completions.
    generate_completions_from_executable(bin/"portwho", "completions")

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
