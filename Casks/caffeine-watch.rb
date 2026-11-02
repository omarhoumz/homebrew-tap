cask "caffeine-watch" do
  version "0.2.0"
  sha256 "592570e4b4497904a40b777edc6a7f13703e1e3a59d7da2ac3423e25594cec1a"

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
