class Portwho < Formula
  desc "See which project owns each localhost port — project name, worktree, docker container, and a clickable URL."
  homepage "https://github.com/omarhoumz/portwho"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.0/portwho-aarch64-apple-darwin.tar.xz"
      sha256 "bbef9da8b000dd1453e06bff4e9fc1732d32d27fa4673195ceb7dec7afc4cca7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.0/portwho-x86_64-apple-darwin.tar.xz"
      sha256 "4b76c17e2ccfb1d7c5c6eec417b5517e866f0aec1ff694956eb59d22de7a1b66"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.0/portwho-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c21fb078ed4cd31898b4c09ce5f8402d4d10cbc0069feff8ba44f30d69a6274"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.0/portwho-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bcfc3f978905ad962fe4e44d03e082571dfccfac2fcb25e0b931a0f46cf5834c"
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
