class PathsTest < MTest::Unit::TestCase
  def test_devbox_path
    assert_include shell("echo $PATH"), "#{Devbox.tools_root}/bin"
  end
end
