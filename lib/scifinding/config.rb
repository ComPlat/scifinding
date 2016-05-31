module Scifinding
  module Configuration
    extend ActiveSupport::Concern
    #attr_accessor :client_id, :client_key, :site, :passphrase, :token_path, :ping_path, :pat_inf_path, :doi_inf_path, :cas_rn_path, :lk_pat_path, :lk_doi_path, :lk_cas_path, :ans_sub_path, :ans_rea_path

    def configure
      yield self
    end

  end #module Configuration
end #module Scifinding
