class Portwho < Formula
  desc "See which project owns each localhost port — project name, worktree, docker container, and a clickable URL."
  homepage "https://github.com/omarhoumz/portwho"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.2/portwho-aarch64-apple-darwin.tar.xz"
      sha256 "34c2ed36689579282492130e145f4e541b3686595bb1d1b1165e6e3e97c4023e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.2/portwho-x86_64-apple-darwin.tar.xz"
      sha256 "4bc4dfbd87edb5c6c5a528180fdb3e163d8de4b7a4302b42b56dce82915dbf5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.2/portwho-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "10d5209b2024552b45621a257f7bde55d26717debbd02ae942283bf5114a1c61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omarhoumz/portwho/releases/download/v0.1.2/portwho-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3733bbb406ca3f16f6aeaf9a5562f40aa377283135c32fc0509412a907aa85d9"
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

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
