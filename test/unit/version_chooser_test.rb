class VersionChooserTest < MTest::Unit::TestCase
  def test_chooses_an_auto_detected_version_over_the_default
    chooser = VersionChooser.new("1.2.3", nil, "1.1.0")
    assert_equal "1.2.3", chooser.version
    assert_equal :autodetected, chooser.version_source
  end

  def test_chooses_a_configured_version_over_an_autodetected_version
    chooser = VersionChooser.new("1.2.3", "0.5", "1.1.0")
    assert_equal "0.5", chooser.version
    assert_equal :configured, chooser.version_source
  end

  def test_chooses_a_default_version_when_nothing_else_exists
    chooser = VersionChooser.new(nil, nil, "1.1.0")
    assert_equal "1.1.0", chooser.version
    assert_equal :default, chooser.version_source
  end

  def test_is_nil_and_unknown_when_no_version_exists
    chooser = VersionChooser.new(nil, nil, nil)
    assert_equal nil, chooser.version
    assert_equal :unknown, chooser.version_source
  end
end
