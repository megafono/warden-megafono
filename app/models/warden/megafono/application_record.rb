module Warden
  module Megafono
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
