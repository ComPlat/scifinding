module Scifinding
  class Credential < ActiveRecord::Base
  include Scifinding::Oauth2

    attr_encrypted :current_token,   :key =>  :encryption_key,algorithm: 'aes-256-gcm',mode: :per_attribute_iv
    attr_encrypted :refreshed_token, :key => :encryption_key,algorithm: 'aes-256-gcm', mode: :per_attribute_iv
    attr_encrypted :password,        :key => :encryption_key,algorithm: 'aes-256-gcm', mode: :per_attribute_iv
    attr_encrypted :password_confirmation, :key => :encryption_key,algorithm: 'aes-256-gcm', mode: :per_attribute_iv
    validates :password, confirmation: true
    belongs_to :user#, class_name: Scifinding.user_class_name
    before_save :get_and_assign_current_token, :do_not_save_cred


    def update_current_token
      logger.debug __method__
      if current_token.blank?
       get_token
      else
        rebuild_access_token
        if @access_token.expired?
          refresh_token
        end
      end
      update_token_attributes if valid_access_token?
    end

    def get_and_assign_current_token
      logger.debug __method__
      get_token && assign_token_attributes
    end

    def do_not_save_cred
      assign_attributes(username: nil)
      assign_attributes(password: nil)
    end




   # private
    def encryption_key
      Scifinding.passphrase
    end

    def assign_token_attributes
      logger.debug __method__
    #  byebug
      if valid_access_token?
        exp_at = @access_token.expires_at
        exp_in = @access_token.expires_in
        req_at = (exp_at && exp_in && Time.at(exp_at-exp_in)) || Time.now
        assign_attributes(current_token: @access_token.token)
        assign_attributes(token_expires_at: Time.at(exp_at)) if exp_at #&& exp_at.is_a?(Fixnum)
        assign_attributes(refreshed_token: @access_token.refresh_token)
        assign_attributes(token_requested_at: req_at)
      end
    end

    def update_token_attributes
      logger.debug __method__
      logger.debug @access_token
      if valid_access_token?
        logger.debug @access_token.expires_at
        exp_at = @access_token.expires_at
        exp_in = @access_token.expires_in
        req_at = (exp_at && exp_in && Time.at(exp_at-exp_in))|| Time.now
        update_attribute(:current_token, @access_token.token)
        update_attribute(:token_expires_at, Time.at(exp_at)) if exp_at #&& exp_at.is_a?(Fixnum)
        update_attribute(:refreshed_token, @access_token.refresh_token)
        update_attribute(:token_requested_at, req_at)
      else false
      end
    end



  end #class Credential
end
