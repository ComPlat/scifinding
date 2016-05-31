module Scifinding
  #class ApplicationController < ActionController::Base
  class ApplicationController < ::ApplicationController
 
    def redirect_to_home
      redirect_to home_index_path
    end

  end
end
