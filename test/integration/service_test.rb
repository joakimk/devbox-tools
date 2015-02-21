class ServiceTest < MTest::Unit::TestCase
  def setup
    redis_image_exists = system("sudo docker images redis | grep 2.8 > /dev/null")

    unless redis_image_exists
      puts
      puts "NOTE: Pulling redis image to run service tests, it may take a few minutes the first time you run these tests."
      puts
    end
  end

  def project_path
    fixture_path("project_using_redis")
  end

  test "can be started and stopped" do
    output = shell "cd #{project_path} && dev"
    assert_include output, "Starting test redis"

    output = shell "cd #{project_path} && dev stop"
    assert_include output, "Stopping test redis"
  end

  test "does not start when already running" do
    output = shell "cd #{project_path} && dev"
    assert_include output, "Starting test redis"

    sleep 0.5

    output = shell "cd #{project_path} && dev"
    assert_not_include output, "Starting test redis"

    output = shell "cd #{project_path} && dev stop"
    assert_include output, "Stopping test redis"
  end

  test "does not stop when already stopped" do
    output = shell "cd #{project_path} && dev"
    assert_include output, "Starting test redis"

    output = shell "cd #{project_path} && dev stop"
    assert_include output, "Stopping test redis"

    sleep 0.5

    output = shell "cd #{project_path} && dev stop"
    assert_not_include output, "Stopping test redis"
  end

  test "can communicate with the service" do
    shell "cd #{project_path} && dev"

    shell %{cd #{project_path} && echo "SET X 42" | nc localhost $TEST_REDIS_PORT}
    result = shell %{cd #{project_path} && echo "GET X" | nc localhost $TEST_REDIS_PORT}

    assert_equal "$2\r\n42\r\n", result
  end

  test "can persist data between service restarts" do
    shell "cd #{project_path} && dev"

    shell %{cd #{project_path} && echo "SET X 42" | nc localhost $TEST_REDIS_PORT}

    # Restart
    shell "cd #{project_path} && dev stop && dev"

    result = shell %{cd #{project_path} && echo "GET X" | nc localhost $TEST_REDIS_PORT}

    assert_equal "$2\r\n42\r\n", result
  end

  def teardown
    shell "cd #{project_path} && dev stop"
  end
end
