class GenerateGlobalProjectIdentifierTest < TestCase
  test "generates identifier based on a git url" do
    assert_equal \
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools.git"),
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools.git")

    assert_not_equal \
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools.git"),
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools-ruby.git")

    assert_not_equal \
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools.git"),
      "https://github.com/joakimk/devbox-tools.git"
  end

  test "generates the same identifier for different url types" do
    # not all types but those used by github and gitorious, more can be added if needed
    assert_equal \
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools.git"),
      GenerateGlobalProjectIdentifier.call("git@github.com:joakimk/devbox-tools.git")
  end

  test "does not generate the same identifier when the host differs" do
    assert_not_equal \
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools.git"),
      GenerateGlobalProjectIdentifier.call("git@gitorious.org:joakimk/devbox-tools.git")
  end

  test "returns nil when given nil" do
    assert_nil GenerateGlobalProjectIdentifier.call(nil)
  end
end
