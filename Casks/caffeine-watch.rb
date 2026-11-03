cask "caffeine-watch" do
  version "0.3.1"
  sha256 "9471807f8f1065b650a3caa842ac76ad48e2b613632cab01517210fa566abd88"

  url "https://github.com/omarhoumz/caffeine-watch/releases/download/v#{version}/CaffeineWatch.zip"
  name "CaffeineWatch"
  desc "Menu bar indicator and CLI for what is preventing sleep"
  homepage "https://github.com/omarhoumz/caffeine-watch"

  depends_on macos: :ventura

  app "CaffeineWatch.app"
  binary "#{appdir}/CaffeineWatch.app/Contents/MacOS/CaffeineWatch", target: "caffeine-watch"
  bash_completion "#{appdir}/CaffeineWatch.app/Contents/Resources/completions/caffeine-watch.bash"
  zsh_completion "#{appdir}/CaffeineWatch.app/Contents/Resources/completions/_caffeine-watch"
  fish_completion "#{appdir}/CaffeineWatch.app/Contents/Resources/completions/caffeine-watch.fish"

  # The app is ad-hoc signed, not notarized; without this Gatekeeper refuses the first launch.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/CaffeineWatch.app"]
  end

  uninstall quit:       "io.github.omarhoumz.caffeine-watch",
            login_item: "CaffeineWatch"

  zap trash: "~/Library/Preferences/io.github.omarhoumz.caffeine-watch.plist"
end
