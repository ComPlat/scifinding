require_dependency "scifinding/application_controller"

module Scifinding
  class HomeController < ApplicationController
    before_action :get_cred 
     
    def index
       
    end

    def resource_53  
      cas_rn = params[:cas_rn] || ''
      if !cas_rn.blank?
        cas_rn = cas_rn.strip.gsub(/\s/,'-')
        resp=@cred.retrieve_mdl_from_cas_rn(cas_rn)
        return unless resp.is_a?(OAuth2::Response)   
        begin 
          mdl = resp.body
          info =  mdl.match(/^(.+)\n/) && $1.strip
          svg = Rubabel::Molecule.from_string(mdl, :mdl).write(:svg)#,{d: true, u: true, p: '50'})
        rescue => e
          puts e
        end
      else
      end
      svg = svg || "no structure"
      info = info || "no info"
      render json: {info: info,svg: svg}
    end # 
  
    def resource_52
     p __method__
     doi = params[:doi] || nil
      if !doi.blank?   
        if doi.strip.match(/^(10(\w|\.)+)\//)
          doi_prefix,doi_suffix = $1,$'
          resp=@cred.retrieve_doi_info(doi_prefix,doi_suffix)
          return unless resp.is_a?(OAuth2::Response)
          begin
            info = resp.body
           p info.encoding
          rescue => e
            puts e
          end
        end
      else
      end
      info  = info || "no info"
      render json: {info: info}
    end
 
    def resource_51
      p __method__
      patent_num = params[:patent_num] || nil
      if !patent_num.blank?   
        patent_num = patent_num.strip.gsub(/\s/,'-')
        resp=@cred.retrieve_patent_info(patent_num)
        return unless resp.is_a?(OAuth2::Response)
        begin
          info = resp.body.force_encoding(Encoding::UTF_8)
          p '+++++  inspect res.body from resource  51'
          p info.encoding
        rescue => e
          puts e
        end
      else
      end
      info  = info || "no info"
      render json: {info: info}
    end
 
    def resource_61
      p __method__
      patent_num = params[:patent_num] || ""
      # resp=OAuth2::Response.new
      if !patent_num.blank?
         patent_num = patent_num.strip.gsub(/\s/,'')
        begin
          resp=@cred.link_to_patent(patent_num)
          return unless resp.is_a?(OAuth2::Response)
          (info=resp.status) == 200 &&   link = resp.body
        rescue => e
          puts e
        end
      else
       info= ""
      end
      if link
        render json: {link: link}
      else
         render json: {info: info}
      end
    end

    def resource_62
      p __method__
      doi = params[:doi] || ""
      # resp=OAuth2::Response.new
      if !doi.blank?
         doi = doi.strip
        if doi.strip.match(/^(10(\w|\.)+)\//)
          doi_prefix,doi_suffix = $1,$'
          begin
            resp=@cred.link_to_doi(doi_prefix,doi_suffix)
            return unless resp.is_a?(OAuth2::Response)
            (info=resp.status) == 200 && link = resp.body
          rescue => e
            puts e
          end
        end
      else
       info = ""
      end
      if link
        render json: {link: link}
      else
         render json: {info: info}
      end
    end

    def resource_63
       p __method__
      cas_rn = params[:cas_rn] || nil
      # resp=OAuth2::Response.new
      if !cas_rn.blank?
         cas_rn = cas_rn.strip.gsub(/\s/,'-')
        begin
          resp=@cred.link_to_CAS_rn(cas_rn)
          return unless resp.is_a?(OAuth2::Response)
          (info=resp.status) == 200 &&   link = resp.body
        rescue => e
          puts e
        end
      else
       info= ""
      end
      if link
        render json: {link: link}
      else
         render json: {info: info}
      end
    end

    def resource_71
      ### prepare input
      s,h,t ,m,f=  params[:smiles],params[:hit_count],params[:search_type],params[:mdl],params[:sdf_file]
      smiles = s || ''
      sdf=File.read(f.tempfile) if f
      hit_count_option = (h && h == 'true' && 'true') || 'false' 
      search_type = (t && t.match(/(substructure|exact|similarity)/i) && $1)||'exact'
      search_type = 'sss' if search_type == 'substructure'
      mdl_arr=smiles_text_2_mdls_array(smiles)
      mdl_arr += m.split(/\$\$\$\$/) if !m.blank?
      mdl_arr += sdf.split(/\$\$\$\$/) if sdf
      resp_arr=[]

      ### retrieve answers
       mdl_arr=mdl_arr[0..5]
       mdl_arr.each do |mdl|
        if !mdl.blank?
          begin      
            resp_arr<<@cred.answer_to_substance(search_type,hit_count_option,mdl)
          rescue => e
            resp_arr << e
          end
        else
          resp_arr << 'input issue'
        end
      end

      ### process answers
      links,status,hits=[],[],[]
      resp_arr.each do |resp|
        if resp.is_a?(OAuth2::Response)
          body=JSON.parse(resp.body)
          hits << body['hitCount'].to_s+' hits'
          links << body['url']
          status << resp.status
        else
          hits << 'n/a'
          links << 'NULL'
          status << 'e'
        end
     end

      p hits
      p links
      p status
      render json: {info: hits,links: links, status: status}
 #  render json: {info: ["1","2"],links: ["link1","link2"]}
    end

    def resource_72
      r,p,t =  params[:smiles_r],params[:smiles_p],params[:search_type]
      rxn_file= params[:rxn_file]
      reagents = smiles_text_2_mdls_array(r)
      products = smiles_text_2_mdls_array(p)
      search_type = (t && t.match(/(substructure|variable)/i) && $1)||'exact'
      px = reagents.compact.size
      rx = products.compact.size
   
      if rx+px > 0
        rxn_data=mdl_2_rxn_file(reagents,products)  
      elsif !rxn_file.blank?
        p rxn_file[0]
        rxn_data= File.read(rxn_file[0].tempfile)  
      end
        p rxn_data
      begin
         resp=@cred.answer_to_reaction(search_type,rxn_data)
        # body = (resp.is_a?(OAuth2::Response)&& JSON.parse(resp.body)) || {}      
         resp.is_a?(OAuth2::Response) &&   ((status=resp.status) == 200 &&   link = resp.body) || info = resp.body
      rescue =>e
       info= e
      end
      if link   
        render json: {link: link}
      else
         render json: {info: info}
      end
    end
    #todo check openbabel vs rubabel for gen3d
    def smiles_text_2_mdls_array(smis)
      return [] if !smis.is_a?(String)
      smi_arr = smis.split(/\n/).map(&:strip)
      @smi_err = Array.new
      mdl_arr = Array.new
      smi_arr.map do |smiles,i|
        begin
          mdl_arr << Rubabel::Molecule.from_string(smiles, :smi).write(:mdl,{gen3D: true})
          @smi_err<< nil     
        rescue => e
          @smi_err<<e
        end   
      end
      mdl_arr
    end

    #desc: "creates a mdl-rxn text from reagent and products mdls"
    def mdl_2_rxn_file(reagent_mdls,product_mdls)
      all = [reagent_mdls,product_mdls]
      all.map{ |mdls|  mlds.is_a?(String) && mdls.split(/\$\$\$\$/)}
      rs=all[0].compact.size
      ps=all[1].compact.size
      rxn_data="$RXN"
      mol="$MOL\n" #emol="M  END"
      all=all.flatten.compact.join(mol)
      rxn_data << (4*"\n") << ("%3d%3d\n" %[rx,px]) <<mol<< all 
      rxn_data
    end
    private
 
    #todo authenticate user and find associated cred  
    def get_cred
      #todo authenticate user and get corresponding credentials 
      @cred=Credential.last
    end
  
    
  end #class 
end #module
