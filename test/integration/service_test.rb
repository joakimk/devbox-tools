class TestService < MTest::Unit::TestCase
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

  def test_can_be_started_and_stopped
    output = shell "cd #{project_path} && dev"
    assert_include output, "Starting test_redis"

    output = shell "cd #{project_path} && dev stop"
    assert_include output, "Stopping test_redis"
  end

  def test_does_not_start_when_already_running
    output = shell "cd #{project_path} && dev"
    assert_include output, "Starting test_redis"

    sleep 0.5

    output = shell "cd #{project_path} && dev"
    assert_not_include output, "Starting test_redis"

    output = shell "cd #{project_path} && dev stop"
    assert_include output, "Stopping test_redis"
  end

  def test_does_not_stop_when_already_stopped
    output = shell "cd #{project_path} && dev"
    assert_include output, "Starting test_redis"

    output = shell "cd #{project_path} && dev stop"
    assert_include output, "Stopping test_redis"

    sleep 0.5

    output = shell "cd #{project_path} && dev stop"
    assert_not_include output, "Stopping test_redis"
  end

  #def test_can_communicate_with_the_service
  # use envs, e.g. TEST_REDIS_PORT

  #def test_can_persist_data_between_service_restarts

  def teardown
    shell "cd #{project_path} && dev stop"
  end
end
