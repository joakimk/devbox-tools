class TestPaths < MTest::Unit::TestCase
  def test_devbox_path
    assert_include shell("echo $PATH"), "/vagrant/devbox-tools/bin"
  end
end
