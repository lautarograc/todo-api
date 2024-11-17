module Users
  class SignUp
    attr_reader :params

    def initialize(params:)
      @params = params
    end

    def perform
      User.create!(params)
    end
  end
end
