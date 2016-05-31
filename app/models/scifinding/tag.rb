module Scifinding
  class Tag < ActiveRecord::Base
    after_save :touch
  end
end
