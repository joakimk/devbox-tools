class TestGenerateGlobalProjectIdentifier < MTest::Unit::TestCase
  def test_generates_identifier_based_on_a_git_url
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

  def test_generates_the_same_identifier_for_different_url_types
    # not all types but those used by github and gitorious, more can be added if needed
    assert_equal \
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools.git"),
      GenerateGlobalProjectIdentifier.call("git@github.com:joakimk/devbox-tools.git")
  end

  def test_does_not_generate_the_same_identifier_when_the_host_differs
    assert_not_equal \
      GenerateGlobalProjectIdentifier.call("https://github.com/joakimk/devbox-tools.git"),
      GenerateGlobalProjectIdentifier.call("git@gitorious.org:joakimk/devbox-tools.git")
  end

  def test_returns_nil_when_given_nil
    assert_nil GenerateGlobalProjectIdentifier.call(nil)
  end
end
