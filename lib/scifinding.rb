require "scifinding/engine"
require "scifinding/config"
require "scifinding/oauth2"
require 'attr_encrypted'
#require 'oauth2'


module Scifinding

  mattr_accessor :user_class,:user_class_name # , :client_id,:client_key
  mattr_accessor :client_id, :client_key, :site, :passphrase, :token_path, :ping_path, :pat_inf_path, :doi_inf_path, :cas_rn_path, :lk_pat_path, :lk_doi_path, :lk_cas_path, :ans_sub_path, :ans_rea_path

  def self.user_class
    @@user_class_name.constantize
  end

  extend Scifinding::Configuration
 # class Credential < ActiveRecord::Base
  #  include Scifinding::Oauth2
 # end #class Base
  self.client_id    = ENV['SF_CLIENT_ID']
  self.client_key   = ENV['SF_CLIENT_KEY']
  self.site         = ENV['SF_SITE']
  # NB: see https://github.com/attr-encrypted/encryptor/issues/26
  # use ` Base64.encode64(SecureRandom.random_bytes(length)).delete("\n") ` to generate ENV['SF_PASS_PHRASE']
  self.passphrase   = Base64.decode64 ENV['SF_PASS_PHRASE'] 
  self.token_path   = ENV['SF_TOKEN_PATH']
  self.ping_path    = ENV['SF_PING_PATH']
  self.pat_inf_path = ENV['SF_PAT_INF_PATH']
  self.doi_inf_path = ENV['SF_DOI_INF_PATH']
  self.cas_rn_path  = ENV['SF_CAS_RN_PATH']
  self.lk_pat_path  = ENV['SF_LK_PAT_PATH']
  self.lk_doi_path  = ENV['SF_LK_DOI_PATH']
  self.lk_cas_path  = ENV['SF_LK_CAS_PATH']
  self.ans_sub_path = ENV['SF_ANS_SUB_PATH']
  self.ans_rea_path = ENV['SF_ANS_REA_PATH']

end
