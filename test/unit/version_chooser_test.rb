class VersionChooserTest < TestCase
  test "chooses an auto detected version over the default" do
    chooser = VersionChooser.new("1.2.3", nil, "1.1.0")
    assert_equal "1.2.3", chooser.version
    assert_equal :autodetected, chooser.version_source
  end

  test "chooses a configured version over an autodetected version" do
    chooser = VersionChooser.new("1.2.3", "0.5", "1.1.0")
    assert_equal "0.5", chooser.version
    assert_equal :configured, chooser.version_source
  end

  test "chooses a default version when nothing else exists" do
    chooser = VersionChooser.new(nil, nil, "1.1.0")
    assert_equal "1.1.0", chooser.version
    assert_equal :default, chooser.version_source
  end

  test "is nil and unknown when no version exists" do
    chooser = VersionChooser.new(nil, nil, nil)
    assert_equal nil, chooser.version
    assert_equal :unknown, chooser.version_source
  end
end
