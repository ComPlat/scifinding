module Scifinding
  class ScifindingAPI < Grape::API
    include Grape::Kaminari
    class Confirmation < Grape::Validations::Base
      def validate_param!(attr_name, params)
        unless params[attr_name] == params[(attr_name.to_s+"_confirmation").to_sym]

          fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "#{attr_name}s must be the same"
        end
      end
    end
    prefix 'scifi'
    version 'v1'
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    helpers do
    end


    resource :credentials do
      desc "return answer to molecule mdl: 71"
      params do
        requires :mdl , type: String, desc: 'MolFile mdl'
        optional :hitCount, type: Boolean, default: true, desc: 'default true'
        optional :searchType, type: String, default: 'exact', values: ['sss','exact','similarity']#regexp: /(substructure|exact|similarity)/i
        optional :elementId, type: Integer, desc: "element id"
        optional :elementType, type: String, default: 'sample',desc: "element type : sample"
      end
      post :sf71 do
        resp = {}
        cred = Scifinding::Credential.where(user_id: current_user.id).last
        resp = cred && cred.answer_to_substance(params[:searchType],params[:hitCount],params[:mdl])
        if (sampId=params[:elementId]) && params[:elementType] == "sample" && params[:searchType] == 'exact'
          id = Sample.find(sampId).molecule_id
          tag = Scifinding::Tag.find_or_create_by(molecule_id: id)
        end

        if resp.is_a?(OAuth2::Response) && resp.respond_to?(:body)
          body = resp.body && JSON.parse(resp.body) || {}
          hits = body['hitCount'].to_s
          url = body['url']
          status = resp.status.to_i
          message = body if status != 200
        else
          hits = 0
          url = '/pages/settings'
          status = '500'
          message = 'The query could not be processed. Please check your access token in the Account Settings'
        end
        if tag && status == 200
          tag.update_attributes(count: hits.to_i)
        end
      #  sleep(5)
        {hitCount: hits, url: url, status: status, message: message}
      end

      desc "return answer to reaction rxn (reagent mdl + product mdl): 72"
      params do
        requires :rxn , type: String, desc: 'MolFile reaction file rxn'
        optional :elementId, type: Integer, desc: "element id"
        optional :search_type, type: String, default: 'substructure', values: ['substructure','variable']
        optional :elementType, type: String, default: 'reaction',desc: "element type : reaction"
      end
      post :sf72 do
        p __method__
        p params
        resp = {}
        cred = Scifinding::Credential.where(user_id: current_user.id).last
        resp = cred && cred.answer_to_reaction(params[:search_type],params[:rxn])
        if resp.is_a?(OAuth2::Response)
          p resp.status
          status = resp.status
          p resp

          case status.to_i
            when 200
              url = resp.body
            else
              message = resp.body
          end
        else
          url = '/pages/settings'
          status = '500'
          message = 'The query could not be processed. Please check your access token in the Account Settings'
        end
        {url: url, status: status, message: message}
      end

      desc "update credential by id"
      params  do
        requires :credential, type: Hash do
          requires :username , type: String
          requires :password , type: String,confirmation: true
          requires :password_confirmation , type: String#, values: [params[:password]]
        end
      end
      put ':id' do
        c = Credential.find(params[:id])
        return if c.user_id != @current_user.id
        if c.update({
          username: params[:credential][:username],
          password: params[:credential][:password]
          })
          {username: c.username, expires_at: c.token_expires_at}
        else {error: 'nope'}
        end

      end #put

      desc "Delete a credential by id"
      params do
      #  requires :id, type: Integer, desc: "Cred id"
      end

      get :del  do
          Scifinding::Credential.where(user_id: current_user.id).last.destroy
          {username: '', expires_at: 'none'}
      end #delete


      desc "create credential "
      params  do
        requires :credential, type: Hash do
          requires :username , type: String
          requires :password , type: String, confirmation: true
          requires :password_confirmation , type: String#, values: [params[:password]]
        end
      end
      post do
        user_id = @current_user.id
        attributes={
          user_id: user_id,
          username: params[:credential][:username],
          password: params[:credential][:password]
        }

        c = Credential.new(attributes)
        c.save && {username: c.username, expires_at: c.token_expires_at} || {error: 'nope'}

      end #put

    end #resource :credentials

  end
end
