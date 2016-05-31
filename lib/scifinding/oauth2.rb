require 'oauth2'
require 'base64'

module Scifinding
  module Oauth2

    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
    end

    #############################################
    #### OAuth2 bindings
    #############################################
    def client
      logger.debug __method__
      @client ||= OAuth2::Client.new(Scifinding.client_id, Scifinding.client_key,:site => Scifinding.site, :token_url => Scifinding.token_path, :raise_errors => false)
    end #client

    def valid_access_token?
      @access_token.is_a?(OAuth2::AccessToken) && !@access_token.token.blank?
    end

    def rebuild_access_token
      logger.debug __method__
      return false unless (current_token && refreshed_token)
      exp_at = (token_expires_at && token_expires_at.utc.to_i) || nil
       h=client.options.merge(
         :access_token => current_token,
         :refresh_token => refreshed_token,
         :expires_at => exp_at)
      h.delete(:authorize_url)

      @access_token = OAuth2::AccessToken.from_hash(client, h)
      @access_token
    end

    def authorization(client_id=Scifinding.client_id, client_secret=Scifinding.client_key)
      #from OAuth2::Strategy::ClientCredentials
      'Basic ' + Base64.encode64(client_id + ':' + client_secret).gsub("\n", '')
    end
    #############################################
    ####  Scifinder API
    #############################################

    #API 3.1

    #desc: "request new access token. mixed Oauth2 strategy (password & client credentials)"
    #AccessToken
    def get_token
      logger.debug __method__
      return false unless (username && password )
      params = {:headers => {'Authorization' => authorization},
                'grant_type' => 'password',
                'username'   => username,
                'password'   => password}
      @access_token = client.get_token(params)
      if valid_access_token?
        @access_token
      else
        errors.add("Warning", "Could not get the access token" )
        false
      end
    end

    #desc: "request token refresh. mixed Oauth2 strategy (password & client credentials)"
    #AccessToken
    def refresh_token
      logger.debug __method__
      return false unless (@access_token && refreshed_token)
      params = {
        :headers => {'Authorization' => authorization},
        'grant_type' => 'refresh_token',
        'refresh_token' => refreshed_token
      }
      @access_token.refresh_token ||= @access_token.token
      @access_token
    end



    #API 4.1
    #Desc: "Validate connectivity and authentication processing"
    #Boolean
    def ping
      logger.debug __method__
      sleep(0.1)
      @response =  @access_token.get(Scifinding.ping_path)
      if @status = (@response.status) || nil
        logger.debug   (@status == 200) && "ping successful" || "ping failed"
        @status == 200
      else
        false
      end
    end

    # Desc: "Refresh or get new token and ping it"
    # Boolean
    def pong
      logger.debug __method__
      case @status
      when 401
        refresh_token && update_token_attributes
      else
        get_token && update_token_attributes
      end

    end

    # Desc: "check/rebuild  @access_token and check its valid connection with cas.org"
    # Boolean
    def ping_pong
      logger.debug __method__
      if valid_access_token? || rebuild_access_token
        logger.debug ' acces token present (or rebuild successful)'
          ping || pong || ping
      end
    end

    #API 5.1
    def retrieve_patent_info(patent_number,content='BIBABS')
      logger.debug __method__
      path = Scifinding.pat_inf_path+"#{patent_number}?content=#{content}"
      ping_pong && @access_token.get(path)
    end

    #API 5.2
    def retrieve_doi_info(doi_prefix,doi_suffix,content='BIBABS')
      logger.debug __method__
      path = Scifinding.doi_inf_path+"#{URI::encode(doi_prefix+'/'+doi_suffix)}?content=#{content}"
      ping_pong && @access_token.get(path)
    end

    #API 5.3
    def retrieve_mdl_from_cas_rn(cas_rn)
      logger.debug __method__
      path = Scifinding.cas_rn_path+"#{cas_rn}"
      ping_pong &&  @access_token.get(path)
    end

    #API 6.1
    def link_to_patent(patent_number)
      path = Scifinding.lk_pat_path + "#{patent_number}"
      ping_pong &&  @access_token.get(path)
    end
    #API 6.2
    def link_to_doi(doi_prefix,doi_suffix)
      path = Scifinding.lk_doi_path + "#{doi_prefix}/#{doi_suffix}"
      ping_pong &&  @access_token.get(path)
    end

    #API 6.3
    def link_to_CAS_rn(cas_rn)
      path=Scifinding.lk_cas_path + "#{cas_rn}"
      ping_pong &&  @access_token.get(path)
    end

    #API 7.1
    def answer_to_substance(search_type,hit_count_option,mdl_file)
      logger.debug __method__
      path=Scifinding.ans_sub_path + "#{search_type}?includeHitCount=#{hit_count_option}"
      ping_pong &&  @access_token.post(path,{:headers =>{"content-type"=>"chemical/x-mdl-molfile", :accept => "application/json"},:body => mdl_file})
    end

    #API 7.2
    def answer_to_reaction(search_type,mdl_file)
      logger.debug __method__
      path = Scifinding.ans_rea_path + "#{search_type}"
      ping_pong &&  @access_token.post(path,{:headers =>{"content-type"=>"chemical/x-mdl-rxnfile"},:body => mdl_file})
    end

  end #module Oauth2
end #module Scifinding
