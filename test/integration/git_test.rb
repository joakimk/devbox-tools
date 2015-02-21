class GitTest < MTest::Unit::TestCase
  def setup
    @repo_with_origin_path = unpack_repo(fixture_path("git_repo_with_origin"))
    @repo_without_origin_path = unpack_repo(fixture_path("git_repo_without_origin"))
  end

  def teardown
    raise "bad path?" unless @repo_with_origin_path.to_s.start_with?("/tmp")
    shell!("rm -rf #{@repo_with_origin_path}")
    shell!("rm -rf #{@repo_without_origin_path}")
  end

  test "returns the origin url" do
    git_url = Git.origin_url(@repo_with_origin_path)
    assert_equal "git@github.com:joakimk/devbox-tools-fake-repo.git", git_url
  end

  test "returns nil when there is no origin url" do
    git_url = Git.origin_url(@repo_without_origin_path)
    assert_nil git_url
  end

  test "returns nil when there is no git repo" do
    assert_false File.exists?("/tmp/.git")

    git_url = Git.origin_url("/tmp")
    assert_nil git_url
  end

  private

  # You can't add a git repo within a git repo.
  def unpack_repo(path)
    target_path = "/tmp/#{File.basename(path)}"
    shell!("cp -rf #{path} #{target_path} && mv #{target_path}/.git- #{target_path}/.git")
    target_path
  end
end
