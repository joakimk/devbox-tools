class TestPaths < MTest::Unit::TestCase
  def test_devbox_path
    assert_include devbox_bash("echo $PATH"), "/vagrant/devbox-tools/bin"
  end
end
