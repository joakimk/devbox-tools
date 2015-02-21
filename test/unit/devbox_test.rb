class DevboxTest < TestCase
  test "local project identifier is unique by full path" do
    assert_equal \
      Devbox.local_project_identifier("/somewhere/project_name"),
      Devbox.local_project_identifier("/somewhere/project_name")

    assert_not_equal \
      Devbox.local_project_identifier("/somewhere/project_name"),
      Devbox.local_project_identifier("/somewhere_else/project_name")
  end

  test "local project identifier starts with the project name" do
    first_part_of_identifier = Devbox.local_project_identifier("/somewhere/project_name").split("-").first
    assert_equal "project_name", first_part_of_identifier
  end
end
