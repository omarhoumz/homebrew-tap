cask "caffeine-watch" do
  version "0.1.0"
  sha256 "9ce0076d6714746c4a0b1fcccab0672cca3d1c5f56f7db0fdc212fb4f6bff43a"

  url "https://github.com/omarhoumz/caffeine-watch/releases/download/v#{version}/CaffeineWatch.zip"
  name "CaffeineWatch"
  desc "Menu bar indicator and CLI for what is keeping your Mac awake"
  homepage "https://github.com/omarhoumz/caffeine-watch"

  depends_on macos: ">= :ventura"

  app "CaffeineWatch.app"
  binary "#{appdir}/CaffeineWatch.app/Contents/MacOS/CaffeineWatch", target: "caffeine-watch"

  # The app is ad-hoc signed, not notarized; without this Gatekeeper refuses the first launch.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/CaffeineWatch.app"]
  end

  uninstall quit: "io.github.omarhoumz.caffeine-watch",
            login_item: "CaffeineWatch"

  zap trash: "~/Library/Preferences/io.github.omarhoumz.caffeine-watch.plist"
end
