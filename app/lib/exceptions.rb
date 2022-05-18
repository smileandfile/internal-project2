class BaseGstnException < StandardError
  attr_accessor :response

  def upstream_headers
    response.present? ? response.to_hash : {}
  end
end

class GstnAspException < StandardError
end

class GstnAuthenticationFailedException < BaseGstnException
  def initialize(msg = "GSTN Authentication Failed", response = nil)
    self.response = response
    super(msg)
  end
end
class GstnUpstreamException < BaseGstnException
  def initialize(msg = "GSTN Upstream Exception", response = nil)
    self.response = response
    super(msg)
  end
end

class RoleCheckFailedException < BaseGstnException
  def initialize(action_name, user)
    msg = "#{user.name} don't have access to perform #{action_name} action."
    super(msg)
  end
end

class GstnUpstreamConnectionError < BaseGstnException
  def initialize(msg = "Service Unavailable at the moment", response = nil)
    self.response = response
    super(msg)
  end
end

class EwayBillGstinNilException < StandardError
  def initialize(msg = "Please Provide gstin number")
    super(msg)
  end
end

class EwayBillUpstreamException < BaseGstnException
  def initialize(msg = "An Exception occured", response = nil)
    self.response = response
    super(msg)
  end
end

class SslDecryptionError < BaseGstnException
  def initialize(msg = "An Exception occured", response = nil)
    self.response = response
    super(msg)
  end
end

class NotValidEwayBillUserException < StandardError
  def initialize(msg = "Please Provide clientid and client-secret or invalid credentails")
    super(msg)
  end
end
class AuthTokenExpiredException < StandardError
  def initialize(msg = "Unauthorised User. Please generate Auth Token")
    super(msg)
  end
end
