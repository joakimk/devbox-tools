class TestGit < MTest::Unit::TestCase
  def setup
    unpack_repo fixture_path("git_repo_with_origin")
    unpack_repo fixture_path("git_repo_without_origin")
  end

  def test_returns_the_origin_url
    git_url = Git.origin_url(fixture_path("git_repo_with_origin"))
    assert_equal "git@github.com:joakimk/devbox-tools-fake-repo.git", git_url
  end

  def test_returns_nil_when_there_is_no_origin_url
    git_url = Git.origin_url(fixture_path("git_repo_without_origin"))
    assert_nil git_url
  end

  def test_returns_nil_when_there_is_no_git_repo
    assert_false File.exists?("/tmp/.git")

    git_url = Git.origin_url("/tmp")
    assert_nil git_url
  end

  private

  # You can't add a git repo within a git repo.
  def unpack_repo(path)
    Shell.run("cp -rf #{path}/.git- #{path}/.git")
  end
end
