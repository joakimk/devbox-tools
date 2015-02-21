class VersionChooser
  CONFIGURED   = :configured
  AUTODETECTED = :autodetected
  DEFAULT      = :default
  UNKNOWN      = :unknown

  def initialize(autodetected, configured, default)
    @autodetected, @configured, @default = autodetected, configured, default
  end

  def version
    case version_source
    when CONFIGURED
      configured
    when AUTODETECTED
      autodetected
    when DEFAULT
      default
    else
      nil
    end
  end

  def version_source
    if configured
      CONFIGURED
    elsif autodetected
      AUTODETECTED
    elsif default
      DEFAULT
    else
      UNKNOWN
    end
  end

  private

  attr_reader :autodetected, :configured, :default
end
