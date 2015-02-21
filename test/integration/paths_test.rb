class PathsTest < MTest::Unit::TestCase
  test "devbox path" do
    assert_include shell("echo $PATH"), "#{Devbox.tools_root}/bin"
  end
end
