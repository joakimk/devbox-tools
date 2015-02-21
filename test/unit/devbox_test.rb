class DevboxTest < MTest::Unit::TestCase
  def test_local_project_identifier_is_unique_by_full_path
    assert_equal \
      Devbox.local_project_identifier("/somewhere/project_name"),
      Devbox.local_project_identifier("/somewhere/project_name")

    assert_not_equal \
      Devbox.local_project_identifier("/somewhere/project_name"),
      Devbox.local_project_identifier("/somewhere_else/project_name")
  end

  def test_local_project_identifier_starts_with_the_project_name
    first_part_of_identifier = Devbox.local_project_identifier("/somewhere/project_name").split("-").first
    assert_equal "project_name", first_part_of_identifier
  end
end
