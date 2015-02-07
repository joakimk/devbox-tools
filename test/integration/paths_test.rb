class TestPaths < MTest::Unit::TestCase
  def test_devbox_path
    assert_include devbox_bash("export | grep PATH"), "/vagrant/devbox_tools/bin"
  end

  #def test_path_setup_when_entering_project
  #end
end
